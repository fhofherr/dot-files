local M = {}

local has_nvim_lsp, nvim_lsp = pcall(require, "nvim_lsp")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_completion, completion = pcall(require, "completion")
local has_diagnostic, diagnostic = pcall(require, "diagnostic")

local function on_attach(client, bufnr)
    if has_completion then
        completion.on_attach(client, bufnr)
    end
    if has_diagnostic then
        diagnostic.on_attach(client, bufnr)
    end
    if has_lsp_status then
        lsp_status.on_attach(client, bufnr)
    end
end

function M.setup()
    if not has_nvim_lsp then
        return
    end

    local gopls_opts = {
        on_attach = on_attach
    }
    local pyls_opts = {
        on_attach = on_attach
    }

    if has_lsp_status then
        lsp_status.register_progress()
        gopls_opts.capabilities = lsp_status.capabilities
        pyls_opts.capabilities = lsp_status.capabilities
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
