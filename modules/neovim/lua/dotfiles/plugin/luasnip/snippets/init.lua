local M = {}

function M.load()
    require("dotfiles.plugin.luasnip.snippets.all").load()
    require("dotfiles.plugin.luasnip.snippets.go").load()
end

return M
