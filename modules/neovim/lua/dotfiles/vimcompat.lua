local M = {}

function M.termesc(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.augroup(name, autocmds)
    vim.api.nvim_command("augroup "..name)
    vim.api.nvim_command("autocmd!")
    for _, autocmd in ipairs(autocmds) do
        vim.api.nvim_command("autocmd " .. autocmd)
    end
    vim.api.nvim_command("augroup END")
end

function M.add_to_globals(path, obj)
    local tab = _G
    local parts = vim.split(path, ".", true)
    for i, part in ipairs(parts) do
        if i < #parts and not tab[part] then
            tab[part] = {}
        end
        if i == #parts then
            tab[part] = obj
            return
        end
        tab = tab[part]
    end
end

return M
