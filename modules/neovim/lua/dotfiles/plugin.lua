local M = {}

function M.safe_require(name)
    local ok, v = pcall(require, name)
    if ok then
        return v
    end
end

function M.exists(name)
    return vim.g.plugs[name] ~= nil
end

return M
