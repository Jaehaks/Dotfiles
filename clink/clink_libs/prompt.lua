local green   = "\x1b[92m"
local yellow  = "\x1b[33m"
local magenta = "\x1b[95m"
local cyan    = "\x1b[96m"
local red     = "\x1b[91m"
local orange  = "\x1b[38;2;255;165;0m"
local teal    = "\x1b[38;2;0;128;128m"
local purple  = "\x1b[38;2;128;0;128m"
local gray    = "\x1b[38;2;200;200;200m"
local blue    = "\x1b[38;2;89;131;255m"
local normal  = "\x1b[0m"

-- prompt filter for getting cwd
-- os.getcwd() is not supported in pure lua. but clink add getcwd(), chdir(), path.* helpers.
local cwd_prompt = clink.promptfilter(30)
function cwd_prompt:filter(prompt)
    return green .. os.getcwd() .. normal
end

-- prompt filter for getting date
local date_prompt = clink.promptfilter(40)
function date_prompt:filter(prompt)
    return yellow .. os.date("%Y/%m/%d %H:%M:%S") .. normal .. " " .. prompt
end


local git_status = function (status, name)
	local result =''

	if name == 'branch' then
		result = status.branch and magenta .. ' ' .. status.branch or ''
	elseif name == 'workingModified' then
		result = status.workingModified > 0 and red .. 'M' .. status.workingModified or ''
	elseif name == 'workingDeleted' then
		result = status.workingDeleted > 0 and cyan .. 'D' .. status.workingDeleted or ''
	elseif name == 'stagingAdded' then
		result = status.stagingAdded > 0 and green .. 'A' .. status.stagingAdded or ''
	elseif name == 'stagingRenamed' then
		result = status.stagingRenamed > 0 and teal .. 'R' .. status.stagingRenamed or ''
	elseif name == 'stagingCopied' then
		result = status.stagingCopied > 0 and purple .. 'C' .. status.stagingCopied or ''
	elseif name == 'stagingDeleted' then
		result = status.stagingDeleted > 0 and cyan .. 'D' .. status.stagingDeleted or ''
	elseif name == 'stagingConflict' then
		result = status.stagingConflict > 0 and orange .. 'U' .. status.stagingConflict or ''
	elseif name == 'untracked' then
		result = status.untracked > 0 and gray .. '?' .. status.untracked or ''
	elseif name == 'ignored' then
		result = status.ignored > 0 and gray .. '!' .. status.ignored or ''
	elseif name == 'stash' then
		result = status.stash > 0 and blue .. '$' .. status.stash or ''
	elseif name == 'commit' then
		result = status.commit > 0 and yellow .. '+' .. status.commit or ''
	elseif name == 'behind' then
		result = status.behind > 0 and yellow .. '-' .. status.behind or ''
	else
		result = ''
	end

	return #result > 0 and result .. ' ' or ''
end

-- A prompt filter that appends the current git branch.
-- local last_fetch_time = 0
-- local wait_fetch_time = 10 * 60 -- 10 min
local git_branch_prompt = clink.promptfilter(65)
function git_branch_prompt:filter(prompt)
	local status = {
		branch          = nil,
		oid             = nil,
		-- after modified
		-- A, R, C mark cannot be shown in status before the files are added
		workingModified = 0, --  M
		workingDeleted  = 0, --  D
		-- after add
		stagingAdded    = 0, -- A(new untracked file), M(tracked file)
		stagingRenamed  = 0, -- R
		stagingCopied   = 0, -- C
		stagingDeleted  = 0, -- D
		stagingConflict = 0, -- U(merge conflict)
		-- etc
		untracked       = 0, -- ??
		ignored         = 0, -- !!
		stash           = 0, -- stash
		commit          = 0, -- committed (remote hash < local hash)
		behind          = 0, -- behind (remote hash > local hash)
	}

	-- get information of remote repo to gather `behind` as result of `git status`
	-- INFO: git fetch is too heavy load operation because it use network.
	-- INFO: To reduce the load at every prompt, wait time is set to reduce calling frequency
	-- `--all` : fetch from all registered remote repo
	-- `--prune` : remove local tracked status which don't exist in remote repo
	-- local current_time = os.time()
	-- if current_time - last_fetch_time > wait_fetch_time then
	-- 	os.execute('git fetch --all --prune 2>nul 1>nul')
	-- 	last_fetch_time = current_time
	-- end

	-- check status
	for line in io.popen('git status --porcelain=v2 --branch --ignored=matching --show-stash 2>nul'):lines() do
		-- get commit hash
		local oid = line:match('^# branch%.oid%s+(.......)')
		if oid then status.oid = oid end

		-- get branch
		local branch = line:match('^# branch%.head%s+(.+)')
		if branch then
			if branch == '(detached)' then
				status.branch = status.oid
			else
				status.branch = branch
			end
		end

		-- get number of commit
		local commit, behind = line:match("^# branch%.ab%s+%+(%d+)%s+%-(%d+)")
		if commit and behind then
			status.commit = tonumber(commit)
			status.behind = tonumber(behind)
		end

		-- get stash
		local stash = line:match("^# stash%s+(%d+)")
		if stash then
			status.stash = tonumber(stash)
		end

		-- get status
        if line:match("^1 .M(.+)$") then status.workingModified = status.workingModified + 1 end
        if line:match("^1 .D(.+)$") then status.workingDeleted  = status.workingDeleted + 1 end

		if line:match("^1 A(.+)$") then status.stagingAdded     = status.stagingAdded + 1 end
        if line:match("^1 M(.+)$") then status.stagingAdded     = status.stagingAdded + 1 end
        if line:match("^2 R(.+)$") then status.stagingRenamed   = status.stagingRenamed + 1 end
        if line:match("^2 C(.+)$") then status.stagingCopied    = status.stagingCopied + 1 end
        if line:match("^1 D(.+)$") then status.stagingDeleted   = status.stagingDeleted + 1 end
        if line:match("^u%w%w (.+)$") then status.stagingConflict   = status.stagingConflict + 1 end

        if line:match("^%?(.+)$") then status.untracked         = status.untracked + 1 end
        -- if line:match("^%!(.+)$") then status.ignored           = status.ignored + 1 end

	end

	if status.branch then
		local git_status_branch = git_status(status, 'branch')
		local git_status_working = string.format('%s%s%s%s%s',
									git_status(status, 'workingModified'),
									git_status(status, 'workingDeleted'),
									git_status(status, 'untracked'),
									git_status(status, 'ignored'),
									git_status(status, 'stash'))
		local git_status_staging = string.format('\x1b[0m| %s%s%s%s%s%s%s',
									git_status(status, 'stagingAdded'),
									git_status(status, 'stagingRenamed'),
									git_status(status, 'stagingCopied'),
									git_status(status, 'stagingDeleted'),
									git_status(status, 'stagingConflict'),
									git_status(status, 'commit'),
									git_status(status, 'behind'))

		if (status.stagingAdded + status.stagingRenamed + status.stagingCopied + status.stagingDeleted + status.stagingConflict + status.commit + status.behind) == 0 then
			return prompt .. ' ' .. git_status_branch .. git_status_working .. normal
		else
			return prompt .. ' ' .. git_status_branch .. git_status_working .. git_status_staging .. normal
		end
	end


end

-- A prompt filter that show python virtual env name
local venv_prompt = clink.promptfilter(100)
function venv_prompt:filter(prompt)
	local env = os.getenv('VIRTUAL_ENV')
	if env then
		env = env:match("^.+[/\\](.*)$")
		return prompt .. cyan .. '\n[' .. env .. ']' .. normal
	else
		return prompt .. '\n'
	end
end

-- A prompt filter that adds a line feed and angle bracket.
local bracket_prompt = clink.promptfilter(150)
function bracket_prompt:filter(prompt)
    return prompt.." >> "
end
