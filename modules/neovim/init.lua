local vimcompat = require("dotfiles.vimcompat")

-- Configure leader and local leader. This should be one very early in the
-- configuration. We therefore do it right at the top.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Configure language providers (most notably pyhton which we mostly use)
if vim.env.DOTFILES_NEOVIM_PYTHON3 then
    vim.g.python3_host_prog = vim.env.DOTFILES_NEOVIM_PYTHON3
end

-------------------------------------------------------------------------------
-- General editor settings according to our liking. Some of them might get
-- overriden by editorconfig on a per file-type basis.
-------------------------------------------------------------------------------
vim.o.backup = false       -- never keep backup files
vim.o.writebackup = false  -- not even before writing a file
vim.o.mouse = "n"          -- enable mouse support in normal mode
vim.o.showcmd = true       -- show partial commands in the last line of the screen
vim.o.hidden = true        -- hide buffers when abandoning them
vim.o.hlsearch = false
vim.o.jumpoptions = "stack"
vim.o.shada = "!,'0,<50,s10,h"

vim.o.cmdheight = 2
vim.o.signcolumn = "yes:2"
vim.o.scrolloff = 4
-- vim.o.updatetime = 100

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.diffopt = "filler,vertical"

vim.wo.lcs = "eol:$,tab:>-,trail:·"
vim.wo.list = false
vim.wo.colorcolumn = "80,120"

vim.wo.foldenable = false -- disable folding by default
vim.wo.foldcolumn = "auto:1"
vim.wo.foldnestmax = 5

vim.o.fileencoding = "utf-8"
vim.bo.fileencoding = "utf-8"

vim.o.expandtab = true -- indent using spaces by default
vim.bo.expandtab = true

vim.o.shiftwidth = 4 -- set the indentation width to 4 spaces
vim.bo.shiftwidth = 4

vim.o.softtabstop = 4 -- display each tab as 4 spaces
vim.bo.softtabstop = 4

vim.api.nvim_command("language messages en_US.UTF-8")

if vim.fn.has("termguicolors") then
    vim.o.termguicolors = true
end

-- Enable a transparent terminal background and create an autocmd to ensure
-- it stays that way even after calling :colorscheme
vim.api.nvim_command("highlight! Normal ctermbg=None guibg=None")
vim.api.nvim_command("highlight! NonText ctermbg=None guibg=None")
vimcompat.augroup("dotfiles_colors", {
    [[
        ColorScheme * highlight! Normal ctermbg=None guibg=None |
                      highlight! NonText ctermbg=None guibg=None
    ]]
})

-- Configure number and relative number. Ensure relative number is toggled of
-- when entering insert mode
vim.o.number = true
vim.o.numberwidth = 5
vimcompat.add_to_globals("dotfiles.set_relative_number", function(v)
    local ignored_file_types = {
        "aerial", "alpha", "help", "packer", "qf", "termmaker", "neo-tree"
    }
    if vim.tbl_contains(ignored_file_types, vim.bo.filetype) then
        return
    end
    -- Always set number. This ensures we don't loose this setting while
    -- toggling relative number.
    vim.wo.number = true
    vim.wo.relativenumber = v
end)
vimcompat.augroup("dotfiles_numbertoggle", {
    [[
        BufEnter,FocusGained,InsertLeave * :call v:lua.dotfiles.set_relative_number(v:true)
    ]],
    [[
        BufLeave,FocusLost,InsertEnter * :call v:lua.dotfiles.set_relative_number(v:false)
    ]]
})

-- Persistent undo.
--
-- Some filetypes may choose to disable this. Additionally we disable it
-- for all files in /tmp/
vim.o.undofile = true
vim.bo.undofile = true
vimcompat.augroup("dotfiles_undofile", {
    [[
        BufWritePre /tmp/* setlocal noundofile
    ]]
})

-------------------------------------------------------------------------------
-- Language specific settings available in Neovim
-------------------------------------------------------------------------------

-- Go
vim.g.go_highlight_trailing_whitespace_error = 0

-- Markdown
vim.g.markdown_syntax_conceal = 0
vim.g.markdown_fenced_languages = { "go", "python" }

-------------------------------------------------------------------------------
-- Useful keybindings
-------------------------------------------------------------------------------

-- Delete buffer by pressing Q
vim.api.nvim_set_keymap("n", "Q", ":bdelete<cr>", { noremap = true, silent = true })

-- Move between windows using C-[HJKL]
-- vim.api.nvim_set_keymap("n", "<C-J>", "<C-W><C-J>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-K>", "<C-W><C-K>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-L>", "<C-W><C-L>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-H>", "<C-W><C-H>", { noremap = true, silent = true })

-- Reselect after using > or < in visualmode
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-------------------------------------------------------------------------------
-- Useful commands
-------------------------------------------------------------------------------

vim.api.nvim_command("command! Cd cd %:p:h")
vim.api.nvim_command("command! Lcd lcd %:p:h")
-- vim.api.nvim_command("command! Delete call delete(expand('%')) | bdelete!")

-- Open files relative to the path of the current buffer regardless of Neovim's
-- working directory.
vim.api.nvim_command("command! -nargs=1 -complete=file Edit edit %:p:h/<args>")
vim.api.nvim_command("command! -nargs=1 -complete=file Split split %:p:h/<args>")
vim.api.nvim_command("command! -nargs=1 -complete=file Vsplit vsplit %:p:h/<args>")

if vim.fn.executable("rg") == 1 then
    -- See https://github.com/BurntSushi/ripgrep/issues/425#issuecomment-702244167
    vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
    vim.o.grepprg = "rg --vimgrep --no-heading"
end

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("dotfiles.plugin").setup()
