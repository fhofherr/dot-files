local M = {}

local ls = require("luasnip")
local types = require("luasnip.util.types")

function M.expand_or_jump()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end

function M.jump_back()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end

function M.select_choice()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end

function M.load_snippets()
	-- Using the luasnip snippets loader seems convenient at first look,
	-- but leads to a lot of linting errors due to pre-defined globals.
	-- Since I don't want to deal with those I manually load the snippets
	-- I want. This is a little less comfortable but more explicit.
	require("dotfiles.plugin.luasnip.snippets").load()
end

function M.config()
	ls.config.set_config({
		history = true,
		update_events = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged",
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "choiceNode", "Comment" } },
				},
			},
		},
	})

	M.load_snippets()
	vim.api.nvim_command("command! ReloadSnippets :lua require('dotfiles.plugin.luasnip').load_snippets()<CR>")
end

return M
