local green   = "\x1b[92m"
local yellow  = "\x1b[33m"
local magenta = "\x1b[95m"
local cyan    = "\x1b[96m"
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

-- A prompt filter that appends the current git branch.
local git_branch_prompt = clink.promptfilter(65)
function git_branch_prompt:filter(prompt)
    local line = io.popen("git branch --show-current 2>nul"):read("*a")
    local branch = line:match("(.+)\n")
    if branch then
        return prompt.. " " .. magenta .. "[" .. branch .. "]" .. normal
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
