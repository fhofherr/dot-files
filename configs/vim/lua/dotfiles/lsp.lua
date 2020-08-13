local M = {}

local has_nvim_lsp, nvim_lsp = pcall(require, "nvim_lsp")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_diagnostic, diagnostic = pcall(require, "diagnostic")

local function chain_on_attach(f1, f2)
    return function(client, bufnr)
        f1(client, bufnr)
        f2(client, bufnr)
    end
end

function M.setup()
    if not has_nvim_lsp then
        return
    end

    local gopls_opts = {
        on_attach = function(_) end
    }
    local pyls_opts = {
        on_attach = function(_) end
    }

    if has_lsp_status then
        lsp_status.register_progress()

        gopls_opts.on_attach = chain_on_attach(gopls_opts.on_attach, lsp_status.on_attach)
        gopls_opts.capabilities = lsp_status.capabilities

        pyls_opts.on_attach = chain_on_attach(gopls_opts.on_attach, lsp_status.on_attach)
        pyls_opts.capabilities = lsp_status.capabilities

    end

    if has_diagnostic then
        gopls_opts.on_attach = chain_on_attach(gopls_opts.on_attach, diagnostic.on_attach)
        pyls_opts.on_attach = chain_on_attach(gopls_opts.on_attach, diagnostic.on_attach)
    end

    nvim_lsp.gopls.setup(gopls_opts)
    nvim_lsp.pyls.setup(pyls_opts)
end

function M.status()
    if not has_nvim_lsp then
        return
    end

    -- TODO have a look at the file mentioned in
    -- https://github.com/nvim-lua/lsp-status.nvim#lsp-statusline-segment and
    -- develop a custom status line segment.
    if has_lsp_status and #vim.lsp.buf_get_clients() > 0  then
        return lsp_status.status()
    end
    if #vim.lsp.buf_get_clients() > 0 then
        return "LSP"
    end

    return "NO LSP"
end

return M
