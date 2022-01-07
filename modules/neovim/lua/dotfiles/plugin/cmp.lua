local M = {}

local cmp = require("cmp")
local lspkind = require("lspkind")
local npairs_cmp = require("nvim-autopairs.completion.cmp")

function M.config()
	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noselect,noinsert",
		},
        experimental = {
            native_menu = true,
        },
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "treesitter" },
			{ name = "nvim_lua" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_list_bufs()
					end,
				},
			},
			{ name = "path" },
			{ name = "vsnip" },
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

	-- See https://github.com/windwp/nvim-autopairs/issues/171 for info
	cmp.event:on("confirm_done", npairs_cmp.on_confirm_done())
end

return M
