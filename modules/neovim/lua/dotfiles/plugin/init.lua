local M = {}

function M.safe_require(name)
	local ok, v = pcall(require, name)
	if ok then
		return v
	end
end

local function ensure_packer()
	local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	local packer_url = "https://github.com/wbthomason/packer.nvim"

	if vim.fn.executable("git") and vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system({ "git", "clone", packer_url, install_path })
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

local function try_local(name)
	local plugin_dir = "~/Projects/github.com/" .. name
	if vim.fn.isdirectory(vim.fn.expand(plugin_dir)) == 1 then
		return plugin_dir
	end
	return name
end

function M.setup()
	-- Note:
	--
	-- config and startup functions imported from other modules usually need to
	-- be wrapped into a function to avoid an upvalue error.
	packer.startup({
		function(use)
			use("wbthomason/packer.nvim") -- Packer can manage itself
			use("antoinemadec/FixCursorHold.nvim")

			use({
				try_local("fhofherr/termmaker.nvim"),
				after = { "which-key.nvim" },
				config = function()
					-- Send q to the executing application even in normal mode.
					-- vim.api.nvim_buf_set_keymap("n", "q", "iq<C-\\><C-n>", { noremap = true, silent = true })
					local window = require("termmaker.window")
					require("termmaker").setup({
						env = {
							DOTFILES_PROTECT_VAR_PATH = 1,
						},
						window_opts = {
							window_factory = window.auto_split(),
						},
						buffer_opts = {
							t_mappings = {
								["<Esc>"] = "<C-\\><C-n>",
								["<C-v><Esc>"] = "<Esc>",
							},
						},
					})

					require("dotfiles.plugin.which-key").register({
						["<localleader>T"] = {
							name = "TermMaker",
							T = { "<cmd>:TermMakerToggle<CR>", "Toggle termmaker terminal." },
						},
					}, {
						noremap = true,
						silent = true,
					})
				end,
			})

			use({
				"numToStr/Navigator.nvim",
				config = function()
					require("Navigator").setup()
					local opts = { noremap = true, silent = true }
					vim.api.nvim_set_keymap("n", "<C-J>", "<CMD>lua require('Navigator').down()<CR>", opts)
					vim.api.nvim_set_keymap("n", "<C-K>", "<CMD>lua require('Navigator').up()<CR>", opts)
					vim.api.nvim_set_keymap("n", "<C-L>", "<CMD>lua require('Navigator').right()<CR>", opts)
					vim.api.nvim_set_keymap("n", "<C-H>", "<CMD>lua require('Navigator').left()<CR>", opts)
				end,
			})

			use("editorconfig/editorconfig-vim")

			-- I hardly ever use that
			-- use({
			-- 	"mbbill/undotree",
			-- 	config = function()
			-- 		vim.g.undotree_WindowLayout = 4
			-- 		vim.g.undotree_SplitWidth = 50
			-- 		vim.g.undotree_SetFocusWhenToggle = 1
			-- 	end,
			-- })

			use("tpope/vim-eunuch")
			use({
				"tpope/vim-surround",
				requires = { "tpope/vim-repeat" },
			})
			use({
				"tpope/vim-unimpaired",
				requires = { "tpope/vim-repeat" },
			})
			use("tpope/vim-commentary")
			use({
				"tpope/vim-projectionist",
				config = function()
					require("dotfiles.plugin.projectionist").config()
				end,
			})
			use("tpope/vim-fugitive") -- TODO config?
			use({
				"lewis6991/gitsigns.nvim",
				requires = { "nvim-lua/plenary.nvim" },
				after = { "which-key.nvim" },
				config = function()
					require("gitsigns").setup({
						current_line_blame = false,
					})
				end,
			})

			use("unblevable/quick-scope")
			use({
				"TaDaa/vimade",
				config = function()
					require("dotfiles.plugin.vimade").config()
				end,
			})

			use({
				"goolord/alpha-nvim",
				requires = { "kyazdani42/nvim-web-devicons" },
				config = function()
					local dashboard = require("alpha.themes.dashboard")
					local leader = vim.g.maplocalleader
					if leader == " " then
						leader = "Space"
					end

					dashboard.section.buttons.val = {
						dashboard.button("CTRL-p", "  Find file"),
						dashboard.button(leader .. " f o", "  Recently opened files"),
						dashboard.button(leader .. " f g", "  Live grep"),
						dashboard.button(leader .. " f m", "  Jump to bookmarks"),
						dashboard.button("e", "  New file", ":enew <CR>"),
						dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
					}
					require("alpha").setup(require("alpha.themes.dashboard").opts)
				end,
			})
			-- use({
			-- 	"mhinz/vim-startify",
			-- 	config = function()
			-- 		vim.g.startify_session_persistence = 1
			-- 		vim.g.startify_change_to_dir = 0
			-- 		vim.g.startify_change_vcs_root = 1
			-- 	end,
			-- })
			-- use("mhinz/vim-signify")

			use("nelstrom/vim-visual-star-search")

			use({
				"rcarriga/vim-ultest",
				after = { "which-key.nvim" },
				requires = { "vim-test/vim-test", "tpope/vim-dispatch" },
				run = ":UpdateRemotePlugins",
				config = function()
					require("dotfiles.plugin.test").config()
				end,
			})

			-- use({
			-- 	"kevinhwang91/nvim-bqf",
			-- 	ft = "qf",
			-- 	requires = {
			-- 		{
			-- 			"junegunn/fzf",
			-- 			-- run = function() vim.fn['fzf#install']() end ,
			-- 		},
			-- 	},
			-- })

			use({
				"folke/which-key.nvim",
				config = function()
					require("dotfiles.plugin.which-key").config()
				end,
			})
			use({
				"nvim-lualine/lualine.nvim",
				requires = { "kyazdani42/nvim-web-devicons" },
				config = function()
					require("dotfiles.plugin.lualine").config()
				end,
			})

			use({
				"folke/lsp-colors.nvim",
				config = function()
					require("lsp-colors").setup()
				end,
			})
			use({
				"folke/trouble.nvim",
				after = { "which-key.nvim" },
				config = function()
					require("dotfiles.plugin.trouble").config()
				end,
			})
			use({
				"ray-x/lsp_signature.nvim",
				config = function()
					require("lsp_signature").setup({
						hint_enable = false,
						handler_opts = {
							border = "single",
						},
						zindex = 50,
						toggle_key = "<M-x>",
					})
				end,
			})
			use({
				"neovim/nvim-lspconfig",
				after = { "which-key.nvim" },
				config = function()
					require("dotfiles.plugin.lsp").config()
				end,
			})

			use({
				"mfussenegger/nvim-lint",
				rocks = {
					"luacheck",
					"luafilesystem",
				},
				config = function()
					require("dotfiles.plugin.lint").config()
				end,
			})

			use({
				"mhartington/formatter.nvim",
				-- rocks = {
				--     {"luaformatter", server = "https://luarocks.org/dev"},
				-- },
				config = function()
					require("dotfiles.plugin.formatter").config()
				end,
			})

			use({
				"windwp/nvim-autopairs",
				requires = {
					"windwp/nvim-ts-autotag",
				},
				config = function()
					local npairs = require("nvim-autopairs")
					npairs.setup({
						disable_filetype = { "TelescopePrompt", "vim" },
						disable_in_macro = true,
						enable_moveright = true,
						enable_afterquote = true,
						enable_check_bracket_in_line = true,
						check_ts = true, -- See https://github.com/windwp/nvim-autopairs#treesitter
						map_bs = true,
						map_c_w = false,
						autotag = {
							enable = true,
						},
					})
					-- Enabble experimental endwise support.
					-- See https://github.com/windwp/nvim-autopairs/wiki/Endwise
					npairs.add_rules(require("nvim-autopairs.rules.endwise-elixir"))
					npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
					npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))
				end,
			})
			use({
				"hrsh7th/nvim-cmp",
				after = { "nvim-autopairs" },
				requires = {
					"hrsh7th/cmp-emoji",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-path",
					"hrsh7th/cmp-vsnip",
					"hrsh7th/cmp-buffer",
					"hrsh7th/vim-vsnip",
					"onsails/lspkind-nvim",
					"ray-x/cmp-treesitter",
				},
				config = function()
					require("dotfiles.plugin.vsnip").config()
					require("dotfiles.plugin.cmp").config()
				end,
			})
			use({
				"nvim-lua/telescope.nvim",
				requires = {
					"nvim-lua/plenary.nvim",
					{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				},
				after = { "which-key.nvim" },
				config = function()
					require("dotfiles.plugin.telescope").config()
				end,
			})

			use({
				"nvim-treesitter/nvim-treesitter",
				requires = {
					"nvim-treesitter/nvim-treesitter-refactor",
					"nvim-treesitter/nvim-treesitter-textobjects",
					"nvim-treesitter/playground",
					"p00f/nvim-ts-rainbow",
				},
				run = ":TSUpdate",
				config = function()
					require("dotfiles.plugin.treesitter").config()
				end,
			})

			use({
				"lewis6991/spellsitter.nvim",
				config = function()
					require("spellsitter").setup({
						enable = true,
						spellchecker = "vimfn",
					})
				end,
			})

			-- Works best with universal-ctags (https://ctags.io)
			-- Install with: brew install --HEAD universal-ctags/universal-ctags/universal-ctags on Mac
			-- Compile it yourself from https://github.com/universal-ctags on Linux
			use({
				"ludovicchabant/vim-gutentags",
				cond = function()
					return vim.fn.executable("ctags")
				end,
				config = function()
					vim.g.gutentags_modules = { "ctags" }
					vim.g.gutentags_define_advanced_commands = 1
				end,
			})

			use({
				"mcchrish/nnn.vim",
				config = function()
					require("nnn").setup({
						command = "nnn -o",
						set_default_mappings = 0,
						replace_netrw = 1,
						layout = { window = { width = 0.6, height = 0.9 } },
						explorer_layout = { left = "25%" },
						action = {
							["<c-t>"] = "tab split",
							["<c-x>"] = "split",
							["<c-v>"] = "vsplit",
						},
					})
					local wk = require("dotfiles.plugin.which-key")
					wk.register({
						["<localleader>n"] = {
							["e"] = { "<cmd>:NnnPicker<CR>", "Toggle NNN picker for working directory." },
							["E"] = {
								"<cmd>:NnnPicker %:p:h<CR>",
								"Toggle NNN picker for directory containing file.",
							},
						},
					}, {
						noremap = true,
						silent = true,
					})
				end,
			})

			-- use {
			--     "ptzz/lf.vim",
			--     requires = {"voldikss/vim-floaterm"},
			--     config = function()
			--         vim.g.lf_map_keys = 0
			--         vim.g.lf_replace_netrw = 1
			--         vim.g.lf_width = 0.8
			--         vim.g.lf_height = 0.8
			--     end
			-- }

			use("hashivim/vim-terraform")
			use("mattn/vim-goaddtags")
			use("sebdah/vim-delve") -- TODO consider trying nvim-dap

			-- Smooth scrolling
			use({
				"karb94/neoscroll.nvim",
				config = function()
					require("neoscroll").setup({
						easing_function = "cubic",
					})
				end,
			})
			-- Colorschemes
			use({
				"dracula/vim",
				as = "dracula",
				cond = function()
					return vim.env.DOTFILES_COLOR_SCHEME == "dracula"
				end,
				config = function()
					vim.o.background = "dark"
					vim.api.nvim_command("colorscheme dracula")
				end,
			})
			use({
				"folke/tokyonight.nvim",
				cond = function()
					return vim.tbl_contains({
						"tokyonight-storm",
						"tokyonight-night",
						"tokyonight-day",
					}, vim.env.DOTFILES_COLOR_SCHEME)
				end,
				config = function()
					vim.o.background = "dark"
					vim.g.tokyonight_transparent = true
					if vim.env.DOTFILES_COLOR_SCHEME == "tokyonight-storm" then
						vim.g.tokyonight_style = "storm"
					elseif vim.env.DOTFILES_COLOR_SCHEME == "tokyonight-night" then
						vim.g.tokyonight_style = "storm"
					else
						vim.o.background = "light"
						vim.g.tokyonight_day_brightness = 0.1
						vim.g.tokyonight_style = "day"
					end
					vim.api.nvim_command("colorscheme tokyonight")
				end,
			})
			use({
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
				end,
			})
			use({
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
				end,
			})
			use({
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
				end,
			})
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
