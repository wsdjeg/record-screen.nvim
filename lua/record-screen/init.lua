local M = {}

local target_dir = vim.fn.stdpath('cache') .. '/record-screen.nvim'
local job = require('job')
local nt = require('notify')
local jobid = -1
local command = 'ffmpeg'
local argvs = { '-f', 'gdigrab', '-i', 'desktop', '-pix_fmt', 'yuv420p', '-f', 'mp4' }
local log = require('record-screen.logger')
local env
local auto_create_target_dir = true

local function get_output_file_name()
    local t = os.date('*t')
    return string.format('%d-%d-%d-%d-%d-%d', t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function creaet_dir(dir)
    local ok, rst = pcall(vim.fn.mkdir, dir, 'p')
    if ok and rst ~= 0 then
        return true
    end
end

function M.start()
    if jobid > 0 then
        return nt.notify('previous recording has not finished!')
    end
    local dir = vim.fs.normalize(target_dir)
    if vim.fn.isdirectory(dir) == 0 then
        if auto_create_target_dir then
            vim.api.nvim_echo({
                -- yes: create and start recording
                -- other: cancel recording screen
                {
                    'target_dir:"' .. dir .. '" does not exist, create target_dir?  Yes/No',
                    'WarningMsg',
                },
            }, false, {})
            local c = vim.fn.getchar()
            -- clear cmdline text
            vim.cmd.mode()
            if c == 121 then
                if not creaet_dir(dir) then
                    vim.api.nvim_echo({
                        { 'failed to create target_dir', 'ModeMsg' },
                    }, false, {})
                    return
                end
            else
                vim.api.nvim_echo({
                    { 'canceled!', 'ModeMsg' },
                }, false, {})
                return
            end
        else
            vim.api.nvim_echo({
                {
                    'target_dir:"' .. dir .. '" does not exist.',
                    'ModeMsg',
                },
            }, false, {})
            return
        end
    end
    local cmd = { command }
    for _, v in ipairs(argvs) do
        table.insert(cmd, v)
    end
    table.insert(cmd, dir .. '/' .. get_output_file_name() .. '.mp4')
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
            jobid = -1
        end,
        env = env,
    })
    if jobid > 0 then
        nt.notify('Start recording.')
    end
end

function M.stop()
    if jobid > 0 then
        job.send(jobid, 'q')
    end
end

function M.setup(opt)
    opt = opt or {}

    target_dir = opt.target_dir or target_dir
    auto_create_target_dir = opt.auto_create_target_dir or auto_create_target_dir
    command = opt.command or command
    argvs = opt.argvs or argvs
    env = opt.env
end

return M
