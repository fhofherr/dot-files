local M = {}

local plugin = require("dotfiles.plugin")
local wk = require("dotfiles.settings.which-key")

local terminal_mappings = {
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
            if vim.fn.winwidth(".") > 120 then
                vim.g.neoterm_default_mod = "botright vertical"
            else
                vim.g.neoterm_default_mod = "botright"
            end
        end
    }

    vim.api.nvim_command("command! STerm :belowright :Tnew")
    vim.api.nvim_command("command! VTerm :vertical :Tnew")
    vim.api.nvim_command("command! TTerm :tab :Tnew")

    terminal_mappings.X = {"<cmd>Ttoggle<cr>", "Toggle the last Neoterm"}
end

function M.setup()
    vim.env.DOTFILES_PROTECT_VAR_PATH = 1
    vim.api.nvim_command([[
    " Use <ESC> in Terminal mode and <C-v><ESC> to send <ESC> to a program in
    " Terminal mode
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>

    augroup dotfiles_terminal
        " Send q to the terminal even when in normal mode.
        autocmd TermOpen * nnoremap <buffer> q iq<C-\><C-n>
    augroup END
    ]])

    setup_neoterm()
    wk.register({ ["<localleader>T"] = terminal_mappings }, { noremap = true, silent = true })
end

return M
