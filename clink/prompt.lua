local green   = "\x1b[92m"
local yellow  = "\x1b[33m"
local magenta = "\x1b[95m"
local cyan    = "\x1b[96m"
local red     = "\x1b[91m"
local gray    = "\x1b[38;2;200;200;200m"
local blue    = "\x1b[38;2;89;131;255m"
local normal  = "\x1b[0m"

-- prompt filter for getting cwd 
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
	elseif name == 'stagingAdded' then
		result = status.stagingAdded > 0 and green .. '+' .. status.stagingAdded or ''
	elseif name == 'stagingModified' then
		result = status.stagingModified > 0 and red .. 'M' .. status.stagingModified or ''
	elseif name == 'stagingDeleted' then
		result = status.stagingDeleted > 0 and cyan .. 'D' .. status.stagingDeleted or ''
	elseif name == 'workingAdded' then
		result = status.workingAdded > 0 and green .. '+' .. status.workingAdded or ''
	elseif name == 'workingModified' then
		result = status.workingModified > 0 and red .. 'M' .. status.workingModified or ''
	elseif name == 'workingDeleted' then
		result = status.workingDeleted > 0 and cyan .. 'D' .. status.workingDeleted or ''
	elseif name == 'untracked' then
		result = status.untracked > 0 and gray .. '?' .. status.untracked or ''
	elseif name == 'ignored' then
		result = status.ignored > 0 and gray .. '!' .. status.ignored or ''
	elseif name == 'stash' then
		result = status.stash > 0 and blue .. '$' .. status.stash or ''
	else
		result = ''
	end

	return #result > 0 and result .. ' ' or ''
end

-- A prompt filter that appends the current git branch.
local git_branch_prompt = clink.promptfilter(65)
function git_branch_prompt:filter(prompt)
	local status = {
		branch          = nil,
		oid             = nil,
		Chnaged         = false,
		-- after add
		stagingAdded    = 0, -- A
		stagingModified = 0, -- M
		stagingDeleted  = 0, -- D
		-- after modified
		workingAdded    = 0, --  A
		workingModified = 0, --  M
		workingDeleted  = 0, --  D
		-- etc
		untracked       = 0, -- ??
		ignored         = 0, -- !!
		stash           = 0, -- stash 
	}

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

		-- get stash
		local stash = line:match("^# stash%s+(%d+)")
		if stash then
			status.stash = tonumber(stash)
		end

		-- get status
		if line:match("^1 A(.+)$") then status.stagingAdded     = status.stagingAdded + 1 end
        if line:match("^1 M(.+)$") then status.stagingModified  = status.stagingModified + 1 end
        if line:match("^1 R(.+)$") then status.stagingModified  = status.stagingModified + 1 end
        if line:match("^1 C(.+)$") then status.stagingModified  = status.stagingModified + 1 end
        if line:match("^1 D(.+)$") then status.stagingDeleted   = status.stagingDeleted + 1 end

        if line:match("^1 .A(.+)$") then status.workingAdded    = status.workingAdded + 1 end
        if line:match("^1 .M(.+)$") then status.workingModified = status.workingModified + 1 end
        if line:match("^1 .R(.+)$") then status.workingModified = status.workingModified + 1 end
        if line:match("^1 .C(.+)$") then status.workingModified = status.workingModified + 1 end
        if line:match("^1 .D(.+)$") then status.workingDeleted  = status.workingDeleted + 1 end

        if line:match("^%?(.+)$") then status.untracked         = status.untracked + 1 end
        if line:match("^%!(.+)$") then status.ignored           = status.ignored + 1 end

        status.anyChanges = true

	end

	if status.branch then
		local git_status_branch = git_status(status, 'branch')
		local git_status_working = string.format('%s%s%s%s%s%s',
									git_status(status, 'workingAdded'),
									git_status(status, 'workingModified'),
									git_status(status, 'workingDeleted'),
									git_status(status, 'untracked'),
									git_status(status, 'ignored'),
									git_status(status, 'stash'))
		local git_status_staging = string.format('\x1b[0m| %s%s%s',
									git_status(status, 'stagingAdded'),
									git_status(status, 'stagingModified'),
									git_status(status, 'stagingDeleted'))

		if (status.stagingAdded + status.stagingModified + status.stagingDeleted) == 0 then
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
