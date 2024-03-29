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

-- local function try_local(name)
-- 	local plugin_dir = "~/Projects/github.com/" .. name
-- 	if vim.fn.isdirectory(vim.fn.expand(plugin_dir)) == 1 then
-- 		return plugin_dir
-- 	end
-- 	return name
-- end

function M.setup()
	-- Note:
	--
	-- config and startup functions imported from other modules usually need to
	-- be wrapped into a function to avoid an upvalue error.
	packer.startup({
		function(use)
			use("wbthomason/packer.nvim") -- Packer can manage itself
			use({
				"antoinemadec/FixCursorHold.nvim",
				config = function()
					vim.g.cursorhold_updatetime = 100
				end,
			})

			use({
				"kwkarlwang/bufresize.nvim",
				config = function()
					require("bufresize").setup()
				end,
			})

			use({
				"akinsho/toggleterm.nvim",
				tag = "v2.*",
				config = function()
					require("toggleterm").setup({
						size = function(term)
							if term.direction == "horizontal" then
								return 15
							elseif term.direction == "vertical" then
								return vim.o.columns * 0.4
							end
						end,
						open_mapping = [[<C-\>]],
						direction = "float",
						close_on_exit = true,
					})
				end,
			})

			use({
				"nvim-neo-tree/neo-tree.nvim",
				branch = "v2.x",
				requires = {
					"nvim-lua/plenary.nvim",
					"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
					"MunifTanjim/nui.nvim",
				},
				config = function()
					require("dotfiles.plugin.neotree").setup()
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
			--
			use({
				"sindrets/diffview.nvim",
				requires = "nvim-lua/plenary.nvim",
				config = function()
					require("diffview").setup({})
				end,
			})

			use("tpope/vim-eunuch")
			use({
				"tpope/vim-surround",
				requires = { "tpope/vim-repeat" },
			})
			use({
				"tpope/vim-unimpaired",
				requires = { "tpope/vim-repeat" },
			})
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
				config = function()
					require("gitsigns").setup({
						current_line_blame = false,
						on_attach = function(bufnr)
							require("dotfiles.mappings").on_gitsigns_attach(bufnr)
						end,
					})
				end,
			})

			use({
				"numToStr/Comment.nvim",
				config = function()
					require("Comment").setup()
				end,
			})

			-- use("ggandor/lightspeed.nvim")
			use("unblevable/quick-scope")

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
						dashboard.button("Ctrl-p", "  Find file"),
						dashboard.button(leader .. " f o", "  Recently opened files"),
						dashboard.button(leader .. " f g", "  Live grep"),
						dashboard.button(leader .. " f m", "  Jump to bookmarks"),
						dashboard.button("e", "  New file", ":enew <CR>"),
						dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
					}
					require("alpha").setup(dashboard.opts)
				end,
			})

			use({
				"mfussenegger/nvim-dap",
				requires = {
					"rcarriga/nvim-dap-ui",
					"leoluz/nvim-dap-go",
					"theHamsta/nvim-dap-virtual-text",
					"Weissle/persistent-breakpoints.nvim",
				},
				config = function()
					require("dotfiles.plugin.dap").setup()
				end,
			})

			use({
				"nvim-neotest/neotest",
				requires = {
					"nvim-lua/plenary.nvim",
					"nvim-treesitter/nvim-treesitter",
					"antoinemadec/FixCursorHold.nvim",
					"nvim-neotest/neotest-python",
					"nvim-neotest/neotest-go",
					"nvim-neotest/neotest-vim-test",
					"vim-test/vim-test",
					"tpope/vim-dispatch",
				},
				config = function()
					require("dotfiles.plugin.test").config()
				end,
			})

			use({
				"nvim-lualine/lualine.nvim",
				requires = {
					"kyazdani42/nvim-web-devicons",
				},
				after = (function()
					-- Tokyonight provides a custom lualine theme. As such
					-- we depend on it, even though this dependency is only
					-- relevant if tokyonight is actually selected.
					local tokyonight_names = {
						"tokyonight-storm",
						"tokyonight-night",
						"tokyonight-day",
					}
					if vim.tbl_contains(tokyonight_names, vim.env.DOTFILES_COLOR_SCHEME) then
						return { "tokyonight.nvim" }
					end
					return nil
				end)(),
				config = function()
					require("dotfiles.plugin.lualine").config()
				end,
			})

			use({
				"folke/todo-comments.nvim",
				requires = { requires = "nvim-lua/plenary.nvim" },
				config = function()
					require("todo-comments").setup({
						highlight = {
							pattern = [[.*<(KEYWORDS)\s*:?]],
							comments_only = true,
						},
						search = {
							pattern = [[\b(KEYWORDS):?]],
						},
					})
				end,
			})

			use({
				"williamboman/mason.nvim",
				requires = {
					"williamboman/mason-lspconfig.nvim",
					"WhoIsSethDaniel/mason-tool-installer.nvim",
				},
				config = function()
					local ensure_installed = {
						"ansible-language-server", -- aka ansiblels
						"buf",
						"buf-language-server",
						"black",
						"delve",
						"gitlint",
						"golangci-lint",
						"gopls",
						"isort",
						"lua-language-server",
						"mypy",
						"pyright",
						"python-lsp-server", --aka pylsp
						"revive",
						"rust-analyzer",
						"shellcheck",
						"shfmt",
						"stylua",
						"yamllint",
					}

					require("mason").setup()
					require("mason-lspconfig").setup({
						automatic_installation = false,
					})
					require("mason-tool-installer").setup({
						ensure_installed = ensure_installed,
						auto_update = false,
						run_on_start = false,
					})
				end,
			})

			use({
				"neovim/nvim-lspconfig",
				requires = {
					"folke/lsp-colors.nvim",
					"jose-elias-alvarez/null-ls.nvim",
					"nvim-lua/plenary.nvim", -- for null-ls
					"p00f/clangd_extensions.nvim",
					-- "ray-x/lsp_signature.nvim",
					"ranjithshegde/ccls.nvim",
					"stevearc/aerial.nvim",
				},
				rocks = {
					"luacheck",
					"luafilesystem",
				},
				config = function()
					require("dotfiles.plugin.lsp").config()
				end,
			})

			use({
				"dcampos/nvim-snippy",
				config = function()
					require("dotfiles.plugin.snippy").config()
				end,
			})

			use({
				"hrsh7th/nvim-cmp",
				after = { "nvim-snippy" },
				requires = {
					"hrsh7th/cmp-buffer",
					"hrsh7th/cmp-emoji",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-nvim-lua",
					"hrsh7th/cmp-path",
					"onsails/lspkind-nvim",
					"dcampos/cmp-snippy",
					"hrsh7th/cmp-nvim-lsp-signature-help",
					"rcarriga/cmp-dap",
				},
				config = function()
					require("dotfiles.plugin.cmp").config()
				end,
			})

			use({
				"kevinhwang91/nvim-ufo",
				requires = { "kevinhwang91/promise-async" },
				after = { "nvim-lspconfig" },
				config = function()
					local ufo = require("ufo")
					-- See https://www.reddit.com/r/neovim/comments/psl8rq/sexy_folds/
					-- See https://www.reddit.com/r/neovim/comments/sofaax/is_there_a_way_to_change_neovims_way_of/
					vim.opt.foldcolumn = "auto:1"
					vim.opt.foldlevel = 99
					vim.opt.foldlevelstart = 99
					vim.opt.foldenable = true

					local providers = {
						go = { "lsp", "indent" },
						lua = { "treesitter", "indent" },
					}

					ufo.setup({
						open_fold_hl_timeout = 150,
						win_config = {
							winhighlight = "Normal:Folded",
							winblend = 0,
						},
						mappings = {
							scrollU = "<C-u>",
							scrollD = "<C-d>",
						},
						provider_selector = function(bufnr, filetype, buftype)
							return providers[filetype] or "indent" -- { "treesitter", "indent" }
						end,
					})

					vim.keymap.set("n", "zR", ufo.openAllFolds)
					vim.keymap.set("n", "zM", ufo.closeAllFolds)
				end,
			})

			use({
				"simrat39/rust-tools.nvim",
				after = { "nvim-lspconfig" },
				config = function()
					require("rust-tools").setup({})
				end,
			})

			use({
				"nvim-telescope/telescope.nvim",
				requires = {
					"nvim-lua/plenary.nvim",
					{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
					"nvim-telescope/telescope-file-browser.nvim",
				},
				config = function()
					require("dotfiles.plugin.telescope").config()
				end,
			})

			use({
				"stevearc/dressing.nvim",
				after = { "telescope.nvim" },
				config = function()
					require("dressing").setup({})
				end,
			})

			use({
				"nvim-treesitter/nvim-treesitter",
				requires = {
					"nvim-treesitter/nvim-treesitter-refactor",
					"nvim-treesitter/nvim-treesitter-textobjects",
					"nvim-treesitter/nvim-treesitter-context",
					"nvim-treesitter/playground",
					"p00f/nvim-ts-rainbow",
				},
				run = ":TSUpdate",
				config = function()
					require("dotfiles.plugin.treesitter").config()
				end,
			})

			-- TODO not sure yet if I like this.
			-- use({
			-- 	"lukas-reineke/indent-blankline.nvim",
			-- 	config = function()
			-- 		require("indent_blankline").setup({
			-- 			show_end_of_line = true,
			-- 			show_current_context = true,
			-- 			show_current_context_start = true,
			-- 		})
			-- 	end,
			-- })

			-- use({
			-- 	"lewis6991/spellsitter.nvim",
			-- 	config = function()
			-- 		require("spellsitter").setup({
			-- 			enable = true,
			-- 			spellchecker = "vimfn",
			-- 		})
			-- 	end,
			-- })

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

			use("hashivim/vim-terraform")
			use("mattn/vim-goaddtags")

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
			use({
				"EdenEast/nightfox.nvim",
				cond = function()
					return vim.tbl_contains({
						"nightfox",
						"dayfox",
						"dawnfox",
						"duskfox",
						"nordfox",
						"terafox",
					}, vim.env.DOTFILES_COLOR_SCHEME)
				end,
				config = function()
					require("nightfox").setup({
						options = {
							dim_inactive = true,
						},
					})
					vim.api.nvim_command("colorscheme " .. vim.env.DOTFILES_COLOR_SCHEME)
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
