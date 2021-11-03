local M = {}

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local wk = require("dotfiles.plugin.which-key")

function M.config()
    telescope.setup({
        defaults = {
            layout_config = {
                prompt_position = "top",
            },
            sorting_strategy = "ascending",
            mappings = {
                i = {
                    ["<C-h>"] = "which_key",
                }
            },
            extensions = {
                fzy_native = {
                    override_generic_sorter = true,
                    override_file_sorter = true
                }
            }
        }
    })
    -- FZY extension does not work on all machines (e.g. raspberry pi)
    if vim.tbl_contains({"fhhc", "wintermute"}, vim.fn.hostname()) then
        telescope.load_extension('fzy_native')
    end

    wk.register({
        name = "Telescope",
        ["<C-p>"] = { "<cmd>lua require('dotfiles.plugin.telescope').find_files()<CR>", "Find files" },
        -- ["<localleader>e"] = {
        --     "<cmd>lua require('dotfiles.plugin.telescope').file_browser()<CR>",
        --     "Browse current working directory.",
        -- },
        -- ["<localleader>E"] = {
        --     "<cmd>lua require('dotfiles.plugin.telescope').file_browser({cwd=vim.fn.expand('%:p:h')})<CR>",
        --     "Browse current file directory.",
        -- },
        ["<localleader>f"] = {
            name = "Find",
            b = { "<cmd>lua require('dotfiles.plugin.telescope').buffers()<CR>", "Find buffers." },
            f = { "<cmd>lua require('dotfiles.plugin.telescope').find_files()<CR>", "Find files." },
            g = { "<cmd>lua require('dotfiles.plugin.telescope').live_grep()<CR>", "Live grep." },
            l = { "<cmd>lua require('dotfiles.plugin.telescope').loclist()<CR>", "Find tags." },
            m = { "<cmd>lua require('dotfiles.plugin.telescope').marks()<CR>", "Find marks." },
            q = { "<cmd>lua require('dotfiles.plugin.telescope').quickfix()<CR>", "Find tags." },
            r = { "<cmd>lua require('dotfiles.plugin.telescope').registers()<CR>", "Find tags." },
            S = {
                "<cmd>lua require('dotfiles.plugin.telescope').lsp_dynamic_workspace_symbols()<CR>",
                "Find LSP workspace symbols.",
            },
            s = { "<cmd>lua require('dotfiles.plugin.telescope').treesitter()<CR>", "Find Treesitter symbols." },
            t = { "<cmd>lua require('dotfiles.plugin.telescope').tags()<CR>", "Find tags." },
        },
    }, { noremap = true, silent = true})
end

function M.buffers()
    builtin.buffers({
        attach_mappings = function(_, map)
            map("i", "<C-q>", actions.delete_buffer)
            map("n", "<C-q>", actions.delete_buffer)
            return true
        end
    })
end

M.file_browser = builtin.file_browser
M.live_grep = builtin.live_grep
M.loclist = builtin.loclist
M.lsp_dynamic_workspace_symbols = builtin.lsp_dynamic_workspace_symbols
M.marks = builtin.marks
M.quickfix = builtin.quickfix
M.registers = builtin.registers
M.tags = builtin.tags
M.treesitter = builtin.treesitter


function M.find_files()
    local opts = {
        shorten_path = false,
    }
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

function M.lsp_code_actions()
    if not builtin then
        return vim.lsp.buf_code_action()
    end
    local opts = themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false,
    }
    return builtin.lsp_code_actions(opts)
end

return M
