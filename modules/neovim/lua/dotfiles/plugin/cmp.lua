local M = {}

local cmp = require("cmp")
local lspkind = require("lspkind")

function M.config()
	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noselect,noinsert",
		},
		view = {
			entries = "native",
		},
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				require("snippy").expand_snippet(args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "snippy" },
			{ name = "nvim_lua" }, -- TODO only use this source for lua files
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
			},
			{ name = "path" },
			{ name = "treesitter" },
			{ name = "emoji" },
		},
		mapping = {
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-e>"] = cmp.mapping.close(),
			["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
			["<CR>"] = cmp.mapping.confirm({ select = false }),
			["<M-CR>"] = cmp.mapping(cmp.mapping.complete({ reason = cmp.ContextReason.Manual }), { "i", "s" }),
		},
		formatting = {
			format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
		},
	})
end

return M
