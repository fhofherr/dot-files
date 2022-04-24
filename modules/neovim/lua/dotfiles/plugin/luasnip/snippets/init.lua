local M = {}

local snippet_pkgs = {
    "dotfiles.plugin.luasnip.snippets.all",
    "dotfiles.plugin.luasnip.snippets.go",
}

function M.load()
	for _, pkg in pairs(snippet_pkgs) do
		-- Ensure snippet package is not loaded
		package.loaded[pkg] = nil
		require(pkg).load()
	end
end

return M
