local M = {}

local cached_opts = nil

local get_cwd = ya.sync(function()
    return tostring(cx.active.current.cwd)
end)

function M:setup(opts)
    opts = opts or {}
    if opts.update_db then
        ps.sub("cd", function()
            local cwd = get_cwd()
            Command("zoxide"):arg({ "add", cwd }):spawn()
        end)
    end
end

function M:entry()
    local cwd = get_cwd()
    local permit = ui.hide()

    local target, err = M.run_with(cwd)

    permit:drop()

    if not target then
        ya.notify { title = "Zoxide", content = tostring(err), timeout = 5, level = "error" }
    elseif target ~= "" then
        ya.emit("cd", { target, raw = true })
    end
end

function M.get_options()
    if cached_opts then
        return cached_opts
    end

    local default = {
        "--exact",
        "--no-sort",
        "--bind=ctrl-z:ignore,btab:up,tab:down",
        "--cycle",
        "--keep-right",
        "--layout=reverse",
        "--height=100%",
        "--border",
        "--scrollbar=▌",
        "--info=inline",
        "--tabstop=1",
        "--exit-0",
    }

    if ya.target_family() == "unix" then
        default[#default + 1] = "--preview-window=down,30%,sharp"
        if ya.target_os() == "linux" then
            default[#default + 1] = [[--preview='\command -p ls -Cp --color=always --group-directories-first {2..}']]
        else
            default[#default + 1] = [[--preview='\command -p ls -Cp {2..}']]
        end
    end

    cached_opts = (os.getenv("FZF_DEFAULT_OPTS") or "")
        .. " "
        .. table.concat(default, " ")
        .. " "
        .. (os.getenv("YAZI_ZOXIDE_OPTS") or "")

    return cached_opts
end

---@param cwd string
---@return string?, Error?
function M.run_with(cwd)
    local child, err = Command("zoxide")
        :arg({ "query", "-i", "--exclude", cwd })
        :env("SHELL", "sh")
        :env("CLICOLOR", "1")
        :env("CLICOLOR_FORCE", "1")
        :env("_ZO_FZF_OPTS", M.get_options())
        :stdin(Command.INHERIT)
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    if not child then
        return nil, Err("Failed to start zoxide, error: %s", err)
    end

    local output, err = child:wait_with_output()
    if not output then
        return nil, Err("Cannot read zoxide output, error: %s", err)
    elseif not output.status.success and output.status.code ~= 130 then
        return nil, Err("zoxide exited with code %s: %s", output.status.code, output.stderr:gsub("^zoxide:%s*", ""))
    end

    return output.stdout:gsub("\n$", ""), nil
end

return M
