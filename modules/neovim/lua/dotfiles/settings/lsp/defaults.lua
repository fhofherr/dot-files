local M = {}

local plugin = require("dotfiles.plugin")
local lspsaga = plugin.safe_require("lspsaga")

local function on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local function buf_def_cmd(name, rhs)
        vim.api.nvim_command("command! -buffer " .. name .. " " .. rhs)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<c-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

    buf_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    buf_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)

    buf_def_cmd("LspRename", "lua vim.lsp.buf.rename()")

    if client.resolved_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting then
        buf_def_cmd("LspFmt", "lua vim.lsp.buf.formatting()")
        vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end

    if lspsaga then
        buf_def_cmd("LspCodeActions", "lua require('lspsaga.codeaction').code_action()")
    end

    vim.b.dotfiles_lsp_enabled = 1
end

function M.new_defaults()
    local opts = { on_attach = on_attach }
    return opts
end

function M.extend_capabilities(current, additional)
    -- Use force instead of keep since our rightmost map contains the settings
    -- we prefer. The example in the lsp status readme does it the other way
    -- around since there the lsp status capabilities are in the rightmost
    -- table.
    return vim.tbl_extend("force", current or {}, additional)
end

return M
