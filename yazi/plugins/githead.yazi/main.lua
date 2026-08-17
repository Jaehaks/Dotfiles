--- @since 26.8.15

--- update git status message
local update_git_state = ya.sync(function(state, status)
	-- set empty state
	state.branch = ""
	state.stash = ""
	state.commit = ""
	state.staged = ""
	state.unstaged = ""
	state.untracked = ""

	if not status or status == "" then
		return true
	end

	-- Branch
	local branch = status:match('On branch (%S+)')
	state.branch = branch and '  ' .. branch or ""

	-- Stash
	local stash = status:match('Your stash currently has (%S+)')
	state.stash = stash and ' $' .. stash or ""

	-- Commit
	local commit = status:match('onto (%S+)')
	state.commit = commit and ' @' .. commit or ""

	-- Staged
	local result_staged = status:match('Changes to be committed:%s*(.-)%s*\n\n')
	if result_staged then
		local count = 0
		for line in result_staged:gsub("^[%s]*%b()[%s]*", ""):gmatch("[^\r\n]+") do
			if line:match("%S") then count = count + 1 end
		end
		state.staged = count > 0 and (" A" .. count) or ""
	end

	-- Unstaged
	local result_unstaged = status:match('Changes not staged for commit:%s*(.-)%s*\n\n')
	if result_unstaged then
		local count = 0
		for line in result_unstaged:gsub("^[%s]*%b()[\r\n]*", ""):gsub("^[%s]*%b()[\r\n]*", ""):gmatch("[^\r\n]+") do
			if line:match("%S") then count = count + 1 end
		end
		state.unstaged = count > 0 and (" M" .. count) or ""
	end

	-- Untracked
	local result_untracked = status:match('Untracked files:%s*(.-)%s*\n\n')
	if result_untracked then
		local count = 0
		for line in result_untracked:gsub("^[%s]*%b()[\r\n]*", ""):gmatch("[^\r\n]+") do
			if line:match("%S") then count = count + 1 end
		end
		state.untracked = count > 0 and (" ?" .. count) or ""
	end
end)


-- setup function to register Header
local setup = function(state, args)
	-- initialize
	update_git_state(nil)

	-- githead main function
	function Header:githead()
		-- ui.render() -- it needs to erase branch fast out of git repo

		return ui.Line{ -- must not be nil, it branch is nil, header isn't shown
			ui.Span(state.branch):fg('bright magenta'),
			ui.Span(state.stash):fg('bright blue'),
			ui.Span(state.staged):fg('bright green'),
			ui.Span(state.unstaged):fg('red'),
			ui.Span(state.commit):fg('bright yellow'),
			ui.Span(state.untracked):fg('gray'),
		}
	end

	-- register githead() to Header process
	Header:children_add(Header.githead, 3000, Header.LEFT)
end


--- cache to call git command at once whenever user enter a directory
---@class git_cache
---@field cwd string
---@field time number
local git_cache = {
	cwd = '',
	time = 0,
}

-- fetch contents whenever entities have some changes
-- it seems that once fetch,
-- it must return any value
local fetch = function (self, job)
	-- in yazi.toml, fetch call at * and */ => it means when I enter in directory,
	-- fetch first item with job.files[1].url each of them.
	-- so fetch one folder and one file at the top of the list (entering or file changing)
	--
	-- setting branch is fast, but clearing branch is slower than it
	-- I think all files are fetched at first time entering
	-- it will be waste time to show correct branch name because if they have lots of files to fetch

	local cwd = job.files[1].url.parent -- get cwd
	local current_time = os.time()
	-- check cache
	-- fetch() will be called for every file in directory. To prevent duplicated fetch call in cwd, use cache and check cwd.
	-- or If timeout is over, the fetch will be executed because file changing checker of yazi will call it.
	if git_cache.cwd == cwd and (current_time - git_cache.time) < 2 then
		return true
	end
	git_cache.cwd = cwd
	git_cache.time = current_time

	-- ya.notify({
	-- 	title = 'githead',
	-- 	content = cwd,
	-- 	timeout = 2,
	-- })

	-- if there are no --no-optional-locks options, command call permanently
	-- if `2>nul` is added, it works in terminal to delete stderr,
	-- but it erase commit / staged lists in Commnad()
	local status, err = Command('git')
						:cwd(tostring(cwd))
						:arg('--no-optional-locks')
						:arg('-c')
						:arg('core.quotePath=')
						:arg('status')
						:arg('--ignore-submodules')
						:arg('--branch')
						:arg('--show-stash')
						:arg('--ahead-behind')
						:stdout(Command.PIPED)
						:output()
	if not status then
		update_git_state(nil)
		return true, Err("Cannot spawn `git` command, error: %s", err)
	end

	-- save branch name
	update_git_state(status.stdout)
	return false
end

-- INFO: it follows git.yazi
-- INFO: I don't know why, but 'fetch' in return item must return function not one of fetch()
-- INFO: If not, 'error converting Lua boolean to function' error is shown.
local function fetch_compact(self, job)
	if ya.throttle then
		fetch(self, job)
		return ya.co(function()
			for _, file in ipairs(job.files) do
				coroutine.yield(file, { retry = true })
			end
		end)
	else
		return fetch(self, job)
	end
end


return {setup = setup, fetch = fetch_compact}
