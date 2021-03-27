local M = {}

local plugin = require("dotfiles.plugin")
local vimcompat = require("dotfiles.vimcompat")
local compe = plugin.safe_require("compe")
local npairs = plugin.safe_require("nvim-autopairs")

function M.setup()
    if not compe then
        return
    end
    vim.cmd("set completeopt=menuone,noselect")
    vim.cmd("set shortmess+=c")

    compe.setup({
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
            buffer = true,
            calc = true,
            emoji = true,
            nvim_lsp = true,
            nvim_lua = true,
            path = true,
            treesitter = true,
            ultisnips = true,
            vsnip = true,
        },
    })

    local opts = { noremap = false, silent = true, expr = true}
    vim.api.nvim_set_keymap("i", "<CR>", "v:lua.dotfiles.settings.completion.confirm()", opts)
    vim.api.nvim_set_keymap("i", " ", "v:lua.dotfiles.settings.completion.confirm(' ')", opts)
    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.dotfiles.settings.completion.tab_complete()", opts)
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.dotfiles.settings.completion.tab_complete()", opts)
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.dotfiles.settings.completion.s_tab_complete()", opts)
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.dotfiles.settings.completion.s_tab_complete()", opts)

    vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", opts)
    vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 })", opts)
    vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 })", opts)
end

-- Checks if the position before the cursor contains a space character.
local function check_back_space()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

function M.tab_complete()
    if vim.fn.pumvisible() ~= 0 then
        return vimcompat.termesc("<C-n>")
    end
    if plugin.exists("vim-vsnip") then
        if vim.fn["vsnip#expandable"]() == 1 then
            return vimcompat.termesc("<Plug>(vsnip-expand)")
        end
        if vim.fn["vsnip#jumpable"](1) == 1 then
            return vimcompat.termesc("<Plug>(vsnip-jump-next)")
        end
    end
    if check_back_space() then
        return vimcompat.termesc("<Tab>")
    end
    return vim.fn["compe#complete"]()
end

function M.s_tab_complete()
    if vim.fn.pumvisible() ~= 0 then
        return vimcompat.termesc("<C-p>")
    end
    if plugin.exists("vim-vsnip") and vim.fn["vsnip#jumpable"](-1) == 1 then
        return vimcompat.termesc("<Plug>(vsnip-jump-prev)")
    end
    return vimcompat.termesc("<S-Tab>")
end

function M.confirm(key)
    if not key then
        key = "<CR>"
    end
    if vim.fn.pumvisible() == 0 then
        if  key == "<CR>" then
            return npairs.check_break_line_char()
        end
        return vimcompat.termesc(key)
    end
    if vim.fn.complete_info()["selected"] ~= -1 then
        return vim.fn["compe#confirm"](key)
    end
    return vimcompat.termesc("<C-e>" .. key)
end

function M.close(key)
    return vim.fn["compe#close"](key)
end

function M.scroll(amount)
    return vim.fn["compe#scroll"]({delta = amount})
end

-- Allow to call functions in this module using v:lua
_G.dotfiles.settings.completion = M

return M
