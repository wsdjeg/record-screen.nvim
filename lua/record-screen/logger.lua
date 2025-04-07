local M = {}
local log
function M.info(msg)
    if not log then
        local ok, l = pcall(require, 'logger')
        if ok then
            log = l.derive('record-screen.nvim')
            log.info(msg)
        end
    else
        log.info(msg)
    end
end

return M
