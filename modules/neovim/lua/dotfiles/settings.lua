local M = {}

-- Init v:lua.dotfiles.settings namespace, so that other modules
-- in here may add to it.
_G.dotfiles = { settings = {} }

local autopairs = require("dotfiles.settings.autopairs")
local completion = require("dotfiles.settings.completion")
local lsp = require("dotfiles.settings.lsp")
local lualine = require("dotfiles.settings.lualine")
local telescope = require("dotfiles.settings.telescope")
local test = require("dotfiles.settings.test")
local tmux = require("dotfiles.settings.tmux")
local treesitter = require("dotfiles.settings.treesitter")
local vsnip = require("dotfiles.settings.vsnip")
local whichkey = require("dotfiles.settings.which-key")

function M.setup()
    whichkey.setup()

    autopairs.setup()
    lsp.setup()
    treesitter.setup()
    completion.setup()

    tmux.setup()
    test.setup()
    lualine.setup()
    vsnip.setup()
    telescope.setup()
end

return M
