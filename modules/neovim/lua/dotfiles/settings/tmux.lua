local M = {}

function M.spawn_lazygit()
    if vim.fn.executable("lazygit") == 0 then
        return
    end

    local handle
    handle = vim.loop.spawn("tmux", {args={"new-window", "lazygit"}}, function()
        vim.loop.close(handle)
    end)
end

function M.spawn_lf(dir)
    if vim.fn.executable("lf") == 0 then
        return
    end
    if dir == nil then
        dir = vim.loop.cwd()
    end

    local handle
    handle = vim.loop.spawn("tmux", {
        args={"new-window", "-e", "NVIM_LISTEN_ADDRESS=" .. vim.env.NVIM_LISTEN_ADDRESS, "lf", dir},
    }, function()
        vim.loop.close(handle)
    end)
end

function M.setup()
    if vim.fn.executable("tmux") == 0 then
        return
    end

    vim.api.nvim_command("command! Lg lua require('dotfiles.settings.tmux').spawn_lazygit()")
    vim.api.nvim_command("command! -nargs=? Lf lua require('dotfiles.settings.tmux').spawn_lf(<f-args>)")
end

return M
