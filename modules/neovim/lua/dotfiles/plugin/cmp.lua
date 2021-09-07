local M = {}

local cmp = require("cmp")
local npairs_cmp = require("nvim-autopairs.completion.cmp")

function M.config()
    cmp.setup({
        completion = {
            completeopt = "menu,menuone,noselect,noinsert",
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "buffer" },
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
        },
    })
    npairs_cmp.setup({
        map_cr = true,
        map_complete = true,
        auto_select = false,
    })
end

return M
