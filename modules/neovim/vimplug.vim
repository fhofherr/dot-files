" vim: set foldmethod=marker:

if empty($VIMPLUG_HOME)
    finish
end

call plug#begin($VIMPLUG_HOME)

" General {{{
Plug 'junegunn/vim-plug'
Plug 'tpope/vim-sensible'

Plug 'editorconfig/editorconfig-vim'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'simnalamburt/vim-mundo'
Plug 'unblevable/quick-scope'

if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
endif
" }}}

" Eye candy and color schemes {{{
Plug 'TaDaa/vimade'
Plug 'mhinz/vim-startify'
Plug 'psliwka/vim-smoothie'

if $DOTFILES_COLOR_SCHEME == 'dracula'
    Plug 'dracula/vim', {'as': 'dracula'}
else
    Plug 'gruvbox-community/gruvbox'
endif

Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'
" }}}

" Buffers, Files, Searching and Finding {{{
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
" }}}

" Git {{{
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" }}}

" Snippets {{{
Plug 'sirver/ultisnips'
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

    Plug 'nvim-lua/completion-nvim'
    Plug 'hrsh7th/vim-vsnip'
    Plug 'hrsh7th/vim-vsnip-integ'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/completion-treesitter'
    Plug 'nvim-treesitter/nvim-treesitter-refactor'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
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
Plug 'cespare/vim-toml'
Plug 'hashivim/vim-terraform'
" }}}

" Text editing {{{
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'freitass/todo.txt-vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}

call plug#end()
call dotfiles#plugin#load_config($VIMHOME . '/plugin.conf.d')
