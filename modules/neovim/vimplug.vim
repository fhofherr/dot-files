" vim: set foldmethod=marker:

if empty($VIMPLUG_HOME)
    finish
end

call plug#begin($VIMPLUG_HOME)

" General {{{
Plug 'junegunn/vim-plug'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'simnalamburt/vim-mundo'
Plug 'unblevable/quick-scope'

Plug 'antoinemadec/FixCursorHold.nvim' " See https://github.com/lambdalisue/fern.vim/issues/120 and https://github.com/neovim/neovim/issues/12587
" }}}

" Terminal {{{
Plug 'kassio/neoterm'
if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
endif
" }}}

" Eye candy and color schemes {{{
Plug 'TaDaa/vimade'
Plug 'mhinz/vim-startify'
Plug 'folke/which-key.nvim'
" Plug 'psliwka/vim-smoothie'

if $DOTFILES_COLOR_SCHEME == 'dracula'
    Plug 'dracula/vim', {'as': 'dracula'}
elseif $DOTFILES_COLOR_SCHEME =~ 'onehalf'
    Plug 'sonph/onehalf', {'rtp': 'vim'}
elseif $DOTFILES_COLOR_SCHEME =~ 'iceberg'
    Plug 'cocopon/iceberg.vim'
elseif $DOTFILES_COLOR_SCHEME =~ 'everforest'
    Plug 'sainnhe/everforest'
else
    Plug 'gruvbox-community/gruvbox'
endif

" Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" }}}

Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'

Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

" Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/fern-git-status.vim'
" Plug 'lambdalisue/fern-renderer-nerdfont.vim'
" Plug 'lambdalisue/fern-hijack.vim'
" Plug 'lambdalisue/nerdfont.vim'  " Required by fern-renderer-nerdfont.vim
" }}}

" Git {{{
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
" }}}

" Programming {{{
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-projectionist'

Plug 'embear/vim-localvimrc'

if exists("g:python3_host_prog")
    Plug 'dense-analysis/ale'
    if executable('buf')
        Plug 'bufbuild/vim-buf'
    endif
endif


if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'
    Plug 'folke/trouble.nvim'
    Plug 'folke/lsp-colors.nvim'

    Plug 'windwp/nvim-autopairs'
    Plug 'hrsh7th/nvim-compe'
    Plug 'hrsh7th/vim-vsnip'

    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'lewis6991/spellsitter.nvim'
endif

" Works best with universal-ctags (https://ctags.io)
" Install with: brew install --HEAD universal-ctags/universal-ctags/universal-ctags on Mac
" Compile it yourself from https://github.com/universal-ctags on Linux
if executable('ctags')
    Plug 'ludovicchabant/vim-gutentags'
endif

" Golang plugins
if executable('go')
    Plug 'sebdah/vim-delve'
    Plug 'mattn/vim-goaddtags'
endif

if executable('pio')
    if filereadable(expand('~/Projects/github.com/fhofherr/nvim-pio/bin/nvim-pio'))
        Plug '~/Projects/github.com/fhofherr/nvim-pio'
    else
        " Plug 'fhofherr/nvim-pio', {'do': 'make'}
    endif
endif

Plug 'aliou/bats.vim'
Plug 'hashivim/vim-terraform'
" }}}

" Text editing {{{
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'freitass/todo.txt-vim'
" }}}

call plug#end()
call dotfiles#plugin#load_config($VIMHOME . '/plugin.conf.d')
