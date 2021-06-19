local M = {}

local wk = require("dotfiles.plugin.which-key")

local function on_attach(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local function buf_def_cmd(name, rhs)
        vim.api.nvim_command("command! -buffer " .. name .. " " .. rhs)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Define buffer local commands
    wk.register({
        name = "lsp",
        gD = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration." },
        gd = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition." },
        K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show documentation." },
        gi = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation." },
        ["<c-s>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature." },
        ["1gD"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition." },
        gr = { "<cmd>lua vim.lsp.buf.references()<CR>", "Show references." },
        g0 = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Document symbol." },
        gW = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "Workspace symbol." },
    }, { noremap = true, silent = true, buffer = bufnr })

    wk.register({
        name = "lsp",
        rn = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol." },
        ca = { "<cmd>lua require('dotfiles.plugin.telescope').lsp_code_actions()<CR>", "Show code actions" }
    }, { noremap = true, silent = true, buffer = bufnr, prefix = "<localleader>" })

    buf_def_cmd("LspRename", "lua vim.lsp.buf.rename()")
    buf_def_cmd("LspCodeActions", "lua require('dotfiles.plugin.telescope').lsp_code_actions()")

    if client.resolved_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting then
        buf_def_cmd("LspFmt", "lua vim.lsp.buf.formatting()")
        vim.api.nvim_command("autocmd BufWritePre <buffer> undojoin | lua vim.lsp.buf.formatting_sync()")
    end

    vim.b.dotfiles_lsp_enabled = 1
end

function M.new_defaults()
    local opts = {
        on_attach = on_attach,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    }
    return opts
end

return M
