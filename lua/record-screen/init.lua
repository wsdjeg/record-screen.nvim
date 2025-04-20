local M = {}

local target_dir = 'C:/Users/wsdjeg/Desktop/'
local job = require('job')
local nt = require('notify')
local jobid
local command = 'ffmpeg'
local argvs = { '-f', 'gdigrab', '-i', 'desktop', '-pix_fmt', 'yuv420p', '-f', 'mp4' }
local log = require('record-screen.logger')

local function get_output_file_name()
    local t = os.date('*t')
    return string.format('%d-%d-%d-%d-%d-%d', t.year, t.month, t.day, t.hour, t.min, t.sec)
end

function M.start()
    local cmd = { command }
    for _, v in ipairs(argvs) do
        table.insert(cmd, v)
    end
    table.insert(cmd, target_dir .. get_output_file_name() .. '.mp4')
    log.info('cmd is: ' .. table.concat(cmd, ' '))
    jobid = job.start(cmd, {
        on_stderr = function(id, data)
            for _, v in ipairs(data) do
                log.error(v)
            end
        end,
        on_stdout = function(id, data)
            for _, v in ipairs(data) do
                log.info(v)
            end
        end,
        on_exit = function(id, data, single)
            log.info(string.format('job exit with: code %s single %s', data, single))
            if data == 0 and single == 0 then
                nt.notify('Recording completed')
            else
                nt.notify('Failed to record')
            end
        end,
    })
    if jobid > 0 then
        nt.notify('Start recording.')
    end
end

function M.stop()
    job.send(jobid, 'q')
end

function M.setup(opt)
    opt = opt or {}

    target_dir = opt.target_dir or target_dir
    command = opt.command or command
    argvs = opt.argvs or argvs
end

return M
