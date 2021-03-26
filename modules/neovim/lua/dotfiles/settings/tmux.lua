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
        args={
            "new-window",
            "-e", "NVIM_LISTEN_ADDRESS=" .. vim.env.NVIM_LISTEN_ADDRESS,
            "-e", "DOTFILES_LF_CLOSE_AFTER_OPEN=1",
            "lf", dir},
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

    local opts = { noremap=true, silent=true }
    vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua require('dotfiles.settings.tmux').spawn_lf()<cr>", opts)
    vim.api.nvim_set_keymap("n", "<leader>E", "<cmd>lua require('dotfiles.settings.tmux').spawn_lf(vim.fn.expand('%p:h'))<cr>", opts)
end

return M
