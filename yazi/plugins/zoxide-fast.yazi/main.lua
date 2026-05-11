--- @since 26.1.22

--- set or get state
local state = ya.sync(function(state, value)
    if value then
        state.query = value
    end
    return state.query or ""
end)

--- get current directory path
local get_cwd = ya.sync(function()
    return tostring(cx.active.current.cwd)
end)


--- setup funciton
local function setup(self, opts)
    opts = opts or {}

	ya.async(function()
		local child = Command("zoxide"):arg({ "query", "-l" }):stdout(Command.PIPED):spawn()
		-- check zoxide is installed
		if not child then
			ya.notify ({
				title = 'zoxide-fast',
				content = 'zoxide not found! please ensure it is installed',
				timeout = 3,
				level = 'error'
			})
			return
		end

		-- fill state cache at first
		local output = child:wait_with_output()
		if output and output.status.success then
			state(output.stdout)
		end
	end)

	if opts.update_db then
		-- whenever 'cd' occurs in yazi (ps.sub is sync)
		ps.sub("cd", function()
			local cwd = get_cwd()
			ya.async(function()
				-- add cwd to db asynchronously
				local output, _ = Command("zoxide"):arg({ "add", cwd }):output()

				-- if zoxide add is succeeded, update query to global variable
				if output and output.status.success then
					local query_out, _ = Command("zoxide"):arg({ "query", "-l" }):stdout(Command.PIPED):output()
					if query_out and query_out.status.success then
						state(query_out.stdout)
					end
				end
			end)
		end)
	end
end

local function entry()
	-- get query from saved global variable
    local queries = state()

    if queries == "" then
        ya.notify { title = "zoxide-fast", content = "Query is empty. Try moving to a folder first.", timeout = 3 }
        return
    end

	-- hide yazi
    local permit = ui.hide()

	-- call fzf
    local child, _ = Command("fzf")
        :arg({ "--exact", "--no-sort", "--layout=reverse", "--height=100%" })
        :stdin(Command.PIPED)
        :stdout(Command.PIPED)
        :spawn()

    if not child then
        permit:drop()
        return
    end

    -- Inject the queries into fzf's stdin directly to show list
	-- entry() is already an async context, so it can be written immediately
    -- child:take_stdin():write(queries)
    child:write_all(queries)

	-- wait until user select some directories
    local output, _ = child:wait_with_output()
    permit:drop()

	-- if output is valid, go to cd
    if output and output.status.success then
        local target = output.stdout:gsub("\n$", "")
        if target ~= "" then
            ya.emit("cd", { target, raw = true })
        end
    end
end


return {
	setup = setup,
	entry = entry,
}
