local M = {}

-- Init v:lua.dotfiles.settings namespace, so that other modules
-- in here may add to it.
_G.dotfiles = { settings = {} }

local completion = require("dotfiles.settings.completion")
local lualine = require("dotfiles.settings.lualine")
local lsp = require("dotfiles.settings.lsp")
local telescope = require("dotfiles.settings.telescope")
local tmux = require("dotfiles.settings.tmux")
local treesitter = require("dotfiles.settings.treesitter")
local autopairs = require("dotfiles.settings.autopairs")
local vsnip = require("dotfiles.settings.vsnip")

function M.setup()
    autopairs.setup()
    lsp.setup()
    treesitter.setup()
    completion.setup()

    tmux.setup()
    lualine.setup()
    vsnip.setup()
    telescope.setup()
end

return M
