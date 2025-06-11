local M = {}

function M:peek(job)
	local filename = job.file.name
	local cmd = "file"
	local output, code = Command(cmd)
						 :arg("-bL")
						 :arg("--")
						 :arg(tostring(job.file.url))
						 :stdout(Command.PIPED):output()

	local text
	if output then
		--  show filename
		text = ui.Text.parse("----- File Type Classification -----\n\n"
										  .. '- Filename : ' .. '\n\n'
										  .. filename .. "\n\n"
										  .. '- Filetype : ' .. '\n\n'
										  .. output.stdout)
	else
		text = ui.Text(string.format("Failed to start `%s`, error: %s", cmd, code))
	end

	ya.preview_widgets(job, { text:area(job.area):wrap(ui.Text.WRAP) })
end

function M:seek() end

return M
