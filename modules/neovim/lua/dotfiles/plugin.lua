local M = {}

function M.safe_require(name)
    ok, v = pcall(require, name)
    if ok then
        return v
    end
end

return M
