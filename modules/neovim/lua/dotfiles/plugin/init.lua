local M = {}

function M.safe_require(name)
    local ok, v = pcall(require, name)
    if ok then
        return v
    end
end

local function ensure_packer()
    local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
    local packer_url = "https://github.com/wbthomason/packer.nvim"

    if vim.fn.executable("git") and vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system({"git", "clone", packer_url, install_path})
    end
    vim.api.nvim_command("packadd packer.nvim")

    return require("packer")
end
local packer = ensure_packer()

function M.hererocks_bin()
    if not jit then
        return
    end

    -- Nicked from packer.nvim:
    -- https://github.com/wbthomason/packer.nvim/blob/4012bd40af350a38696a6ba92a5df9bd99b48527/lua/packer/luarocks.lua#L19
    local jit_version = string.gsub(jit.version, "LuaJIT ", "")
    if not jit_version then
        return
    end
    return vim.fn.stdpath("cache") .. "/packer_hererocks/" .. jit_version .. "/bin"
end

function M.setup()
    -- Note:
    --
    -- config and startup functions imported from other modules usually need to
    -- be wrapped into a function to avoid an upvalue error.
    packer.startup({
        function(use)
            use "wbthomason/packer.nvim" -- Packer can manage itself

            use "editorconfig/editorconfig-vim"
            use {
                "mbbill/undotree",
                config = function()
                    vim.g.undotree_WindowLayout = 4
                    vim.g.undotree_SplitWidth = 50
                    vim.g.undotree_SetFocusWhenToggle = 1
                end
            }

            use {
                "tpope/vim-surround",
                requires = { "tpope/vim-repeat" },
            }
            use {
                "tpope/vim-unimpaired",
                requires = { "tpope/vim-repeat" },
            }
            use "tpope/vim-fugitive" -- TODO config?
            use "tpope/vim-commentary"
            use {
                "tpope/vim-projectionist",
                config = function()
                    require("dotfiles.plugin.projectionist").config()
                end
            }

            use "unblevable/quick-scope"
            use {
                "TaDaa/vimade",
                config = function()
                    require("dotfiles.plugin.vimade").config()
                end
            }

            use {
                "mhinz/vim-startify",
                config = function()
                    vim.g.startify_session_persistence = 1
                    vim.g.starify_change_to_vcs_root = 0
                end
            }
            use "mhinz/vim-signify"
            use {
                "mhinz/vim-grepper",
                config = function()
                    vim.api.nvim_set_keymap("n", "gs", "<Plug>(GrepperOperator)", { silent = true})
                    vim.api.nvim_set_keymap("x", "gs", "<Plug>(GrepperOperator)", { silent = true})
                    if vim.fn.executable("ag") then
                        vim.api.nvim_command("command -nargs=+ Ag GrepperAg <args>")
                    end
                    if vim.fn.executable("rg") then
                        vim.api.nvim_command("command -nargs=+ Rg GrepperRg <args>")
                    end
                end
            }

            use "nelstrom/vim-visual-star-search"

            use {
                "vim-test/vim-test",
                after = { "which-key.nvim" },
                requires = { "tpope/vim-dispatch" },
                config = function()
                    require("dotfiles.plugin.test").config()
                end
            }

            use {
                "folke/which-key.nvim",
                config = function()
                    require("dotfiles.plugin.which-key").config()
                end
            }
            use {
                "hoob3rt/lualine.nvim",
                requires = { "kyazdani42/nvim-web-devicons" },
                config = function()
                    require("dotfiles.plugin.lualine").config()
                end
            }

            use {
                "folke/lsp-colors.nvim",
                config = function()
                    require("lsp-colors").setup()
                end
            }
            use {
                "folke/trouble.nvim",
                after = { "which-key.nvim" },
                config = function()
                    require("dotfiles.plugin.trouble").config()
                end
            }
            use {
                "neovim/nvim-lspconfig",
                after = { "which-key.nvim" },
                config = function()
                    require("dotfiles.plugin.lsp").config()
                end
            }
            use {
                "mfussenegger/nvim-lint",
                rocks = {
                    "luacheck",
                },
                config = function()
                    require("dotfiles.plugin.lint").config()
                end
            }

            use {
                "mhartington/formatter.nvim",
                rocks = {
                    {"luaformatter", server = "https://luarocks.org/dev"},
                },
                config = function()
                    require("dotfiles.plugin.formatter").config()
                end
            }

            use {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup()
                end
            }
            use {
                "hrsh7th/nvim-compe",
                after = { "nvim-autopairs" },
                config = function()
                    require("dotfiles.plugin.compe").config()
                end
            }
            use {
                "hrsh7th/vim-vsnip",
                config = function()
                    require("dotfiles.plugin.vsnip").config()
                end
            }

            use {
                "nvim-lua/telescope.nvim",
                requires = {
                    "nvim-lua/plenary.nvim",
                    "nvim-lua/popup.nvim" ,
                    "nvim-telescope/telescope-fzy-native.nvim"
                },
                after = { "which-key.nvim" },
                config = function()
                    require("dotfiles.plugin.telescope").config()
                end
            }

            use "lewis6991/spellsitter.nvim"
            use {
                "nvim-treesitter/nvim-treesitter",
                run = ":TSUpdate",
                after = { "spellsitter.nvim" },
                config = function()
                    require("dotfiles.plugin.treesitter").config()
                end
            }
            use {
                "nvim-treesitter/nvim-treesitter-refactor",
                after = { "nvim-treesitter" },
            }
            use {
                "nvim-treesitter/nvim-treesitter-textobjects",
                after = { "nvim-treesitter" },
            }

            -- Works best with universal-ctags (https://ctags.io)
            -- Install with: brew install --HEAD universal-ctags/universal-ctags/universal-ctags on Mac
            -- Compile it yourself from https://github.com/universal-ctags on Linux
            use {
                "ludovicchabant/vim-gutentags",
                cond = function()
                    return vim.fn.executable("ctags")
                end,
                config = function()
                    vim.g.gutentags_modules = { "ctags" }
                    vim.g.gutentags_define_advanced_commands = 1
                end
            }

            use {
                "ptzz/lf.vim",
                requires = {"voldikss/vim-floaterm"},
                config = function()
                    vim.g.lf_map_keys = 0
                    vim.g.lf_replace_netrw = 1
                    vim.g.lf_width = 0.8
                    vim.g.lf_height = 0.8
                end
            }

            use "hashivim/vim-terraform"
            use "mattn/vim-goaddtags"
            use "sebdah/vim-delve" -- TODO consider trying nvim-dap

            -- Colorschemes
            use {
                "dracula/vim",
                as = "dracula",
                cond = function()
                    return vim.env.DOTFILES_COLOR_SCHEME == "dracula"
                end,
                config = function()
                    vim.o.background = "dark"
                    vim.api.nvim_command("colorscheme dracula")
                end
            }
            use {
                "sonph/onehalf",
                rtp = "vim",
                cond = function()
                    return vim.tbl_contains({
                        "onehalf-dark",
                        "onehalf-light",
                    }, vim.env.DOTFILES_COLOR_SCHEME)
                end,
                config = function()
                    if vim.env.DOTFILES_COLOR_SCHEME == "onehalf-dark" then
                        vim.o.background = "dark"
                        vim.api.nvim_command("colorscheme onehalfdark")
                    end
                    if vim.env.DOTFILES_COLOR_SCHEME == "onehalf-light" then
                        vim.o.background = "dark"
                        vim.api.nvim_command("colorscheme onehalflight")
                    end
                end
            }
            use {
                "cocopon/iceberg.vim",
                cond = function()
                    return vim.tbl_contains({
                        "iceberg-dark",
                        "iceberg-light",
                    }, vim.env.DOTFILES_COLOR_SCHEME)
                end,
                config = function()
                    vim.o.background = "dark"
                    if vim.env.DOTFILES_COLOR_SCHEME == "iceberg-light" then
                        vim.o.background = "light"
                    end
                    vim.api.nvim_command("colorscheme iceberg")
                end
            }
            use {
                "sainnhe/everforest",
                cond = function()
                    return vim.startswith(vim.env.DOTFILES_COLOR_SCHEME, "everforest")
                end,
                config = function()
                    vim.o.background = "dark"
                    if vim.startswith(vim.env.DOTFILES_COLOR_SCHEME, "everforest-light") then
                        vim.o.background = "light"
                    end
                    vim.g.everforest_transparent_background = 1
                    if vim.endswith(vim.env.DOTFILES_COLOR_SCHEME, "hard") then
                        vim.g.everforest_background = "hard"
                    elseif vim.endswith(vim.env.DOTFILES_COLOR_SCHEME, "medium") then
                        vim.g.everforest_background = "medium"
                    else
                        vim.g.everforest_background = "soft"
                    end
                    vim.api.nvim_command("colorscheme everforest")
                end
            }
             use {
                "gruvbox-community/gruvbox",
                cond = function()
                    return vim.startswith(vim.env.DOTFILES_COLOR_SCHEME, "gruvbox")
                end,
                config = function()
                    vim.g.background = "dark"
                    if vim.endswith(vim.env.DOTFILES_COLOR_SCHEME, "light") then
                        vim.g.background = "light"
                    end
                    vim.api.nvim_command("colorscheme gruvbox")
                end
            }
        end,
        -- Place any packer config overrides in the table below.
        config = {
            max_jobs = 4,
        },
    })
end

function M.exists(name)
    return _G.packer_plugins and _G.packer_plugins[name] and _G.packer_plugins[name].loaded
end

return M
