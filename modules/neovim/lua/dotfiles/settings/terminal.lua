local M = {}

local plugin = require("dotfiles.plugin")
local wk = require("dotfiles.settings.which-key")

local leader_mappings = {
    name="Terminal",
}

local function setup_neoterm()
    if not plugin.exists("neoterm") then
        return
    end
    vim.g.neoterm_autoinsert = 0
    vim.g.neoterm_autojump = 1
    vim.g.neoterm_callbacks = {
        before_new = function()
            if vim.fn.winwidth(".") <= 80 then
                vim.g.neoterm_default_mod = nil
            elseif vim.fn.winwidth(".") < 120 then
                vim.g.neoterm_default_mod = "belowright"
            else
                vim.g.neoterm_default_mod = "botright vertical"
            end
        end
    }

    vim.api.nvim_command("command! Term :Tnew")
    vim.api.nvim_command("command! STerm :belowright :Tnew")
    vim.api.nvim_command("command! VTerm :vertical :Tnew")
    vim.api.nvim_command("command! TTerm :tab :Tnew")

    vim.api.nvim_command([[
    autocmd FileType neoterm lua require('dotfiles.settings.terminal').configure_neoterm_buffer()
    ]])

    wk.register({
        T = {"<cmd>Ttoggle<cr>", "Toggle the last Neoterm."},
    },
    { noremap = true, silent = true, prefix = "<localleader>" })
end

function M.configure_neoterm_buffer()
    -- Use <ESC> in Terminal mode and <C-v><ESC> to send <ESC> to a program in
    -- Terminal mode
    vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, "t", "<C-v><Esc>", "<Esc>", { noremap = true, silent = true })

    -- Send q to the executing application even in normal mode.
    vim.api.nvim_buf_set_keymap(0, "n", "q", "iq<C-\\><C-n>", { noremap = true, silent = true })
end

function M.setup()
    setup_neoterm()

    vim.env.DOTFILES_PROTECT_VAR_PATH = 1
end

return M
