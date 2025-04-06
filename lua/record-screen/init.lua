local M = {}

local target_dir = "~/Desktop/"
local job = require('job')
local nt = require('notify')
local jobid

function M.start(opt)
	local cmd =
		{ "ffmpeg", "-f", "gdigrab", "-r", "60", "-i", "desktop", "-s", "1920x1080", target_dir .. "output.mp4" }
    jobid = job.start(cmd, {
        on_exit = function(id, data, single)
            nt.notify(string.format('job exit with: code %s single %s', data, single))
        end
    })
end

function M.stop()

    job.send(jobid, 'q')
end

function M.setup(opt) end

return M
