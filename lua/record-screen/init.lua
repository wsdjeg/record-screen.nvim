local M = {}

local target_dir = "C:/User/wsdjeg/Desktop/"
local job = require("job")
local nt = require("notify")
local jobid

function M.start(opt)
	local cmd = { "ffmpeg", "-f", "gdigrab", "-i", "desktop", "-f", "mp4", target_dir .. "output.mp4" }
	jobid = job.start(cmd, {
		on_exit = function(id, data, single)
			nt.notify(string.format("job exit with: code %s single %s", data, single))
		end,
	})
end

function M.stop()
	job.send(jobid, "q")
end

function M.setup(opt) end

return M
