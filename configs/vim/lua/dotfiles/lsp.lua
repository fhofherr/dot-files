local M = {}

local has_nvim_lsp, nvim_lsp = pcall(require, "lspconfig")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_completion, completion = pcall(require, "completion")

local function on_attach(client, bufnr)
    if has_completion then
        completion.on_attach(client, bufnr)
    end
    if has_lsp_status then
        lsp_status.on_attach(client, bufnr)
    end
end

-- Create a deep copy from orig.
--
-- Copied verbatim from http://lua-users.org/wiki/CopyTable
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function M.setup()
    if not has_nvim_lsp then
        return
    end

    -- See :help lsp-handler for more info
    -- See https://github.com/nvim-lua/diagnostic-nvim/issues/73 for transition info from diagnostic-nvim
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = false,
            update_in_insert = true,
        }
    )

    local ls_opts = {
        on_attach = on_attach
    }

    if has_lsp_status then
        lsp_status.register_progress()
        ls_opts.capabilities = lsp_status.capabilities
    end

    ccls_opts = deepcopy(ls_opts)
    ccls_opts.root_dir = nvim_lsp.util.root_pattern("compile_commands.json", ".ccls", "compile_flags.txt")
    nvim_lsp.ccls.setup(ccls_opts)

    nvim_lsp.gopls.setup(ls_opts)
    nvim_lsp.pyls.setup(ls_opts)
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
