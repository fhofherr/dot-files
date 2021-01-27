local M = {}

M.supported_file_types = {}

local has_nvim_lsp, nvim_lsp = pcall(require, "lspconfig")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_completion, completion = pcall(require, "completion")
local has_lspsaga, lspsaga = pcall(require, "lspsaga")


local function attach_completion(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    if not has_completion then
        return
    end
    completion.on_attach(client, bufnr)

    vim.g.completion_enable_auto_popup = 1
    vim.g.completion_enable_snippet = "UltiSnips"
    vim.g.completion_auto_change_source = 1
    vim.g.completion_enable_auto_signature = 1
    vim.g.completion_timer_cycle = 100

    local opts = { noremap=true, silent=true }
    buf_set_keymap("i", "<tab>", "<cmd>lua require('completion').smart_tab()<CR>", opts)
    buf_set_keymap("i", "<s-tab>", "<cmd>lua require('completion').smart_s_tab()<CR>", opts)
end

local function on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local function buf_def_cmd(name, rhs)
        vim.api.nvim_command("command! -buffer " .. name .. " " .. rhs)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    if has_lsp_status then
        lsp_status.on_attach(client, bufnr)
    end
    attach_completion(client, bufnr)

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

    buf_def_cmd("LspRename", "<cmd>lua vim.lsp.buf.rename()<CR>")

    if client.resolved_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting then
        vim.api.nvim_command('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
    end

    if has_lspsaga then
        buf_def_cmd("LspCodeActions", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
    end

    vim.b.dotfiles_lsp_enabled = 1
end

local function setup_ccls(ls_opts)
    -- Create a deep copy of the passed in ls_opts. We modify this copy
    -- instead of the common options.
    local ccls_opts = vim.deepcopy(ls_opts)

    ccls_opts.root_dir = nvim_lsp.util.root_pattern("compile_commands.json", ".ccls", "compile_flags.txt")
    if vim.g.dotfiles_lsp_ccls_root_patterns then
        ccls_opts.root_dir = nvim_lsp.util.root_pattern(vim.g.dotfiles_lsp_ccls_root_patterns)
    end
    if vim.g.dotfiles_lsp_ccls_compilation_db_dir then
        ccls_opts.init_options.compilationDatabaseDirectory = vim.g.dotfiles_lsp_ccls_compilation_db_dir
    end
    nvim_lsp.ccls.setup(ccls_opts)

    table.insert(M.supported_file_types, "c")
    table.insert(M.supported_file_types, "cpp")
end

local function setup_gopls(ls_opts)
    local gopls_opts = vim.deepcopy(ls_opts)

    gopls_opts.cmd = {"gopls", "--remote=auto"}
    gopls_opts.capabilities ={
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = false
                }
            }
        }
    }
    gopls_opts.init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    }

    nvim_lsp.gopls.setup(gopls_opts)
    table.insert(M.supported_file_types, "go")
end

function M.buf_attach_client()
    if not has_nvim_lsp then
        return
    end
    local ft = vim.bo.filetype
    if M.supported_file_types[ft] ~= nil then
        return
    end
    if vim.b.dotfiles_lsp_enabled == 1 then
        -- dotfiles_lsp_enabled was set by on_attach. We are already attached.
        -- Nothing more to do.
        return
    end

    -- Always attach to the first client for now. Later we might want to try
    -- to find the correct client based on the buffer's file type.
    vim.lsp.buf_attach_client(0, 1)
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

    local ls_opts = { on_attach = on_attach }

    if has_lsp_status then
        lsp_status.register_progress()
        ls_opts.capabilities = lsp_status.capabilities
    end

    setup_ccls(ls_opts)
    setup_gopls(ls_opts)

    nvim_lsp.pyls.setup(ls_opts)
    table.insert(M.supported_file_types, "python")

    -- No-one besides me seems to use such a hack. I wonder if I can get by
    -- without it.
    --
    -- vim.api.nvim_command([[
    -- autocmd BufEnter * lua require("dotfiles/lsp").buf_attach_client()
    -- ]])
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
