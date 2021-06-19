local M = {}

function M.pkg_name()
    local file_name = vim.fn.expand("%:t:r")
    local dir_name = vim.fn.expand("%:h:t")

    if vim.endswith(file_name, "_test") and not vim.endswith(file_name, "_internal_test") then
        return dir_name .. "_test"
    end
    return dir_name
end

return M
