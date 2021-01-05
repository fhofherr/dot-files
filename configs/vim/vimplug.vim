" vim: set foldmethod=marker:
let $VIMPLUGHOME = $HOME . '/.vimplug'

call plug#begin($VIMPLUGHOME)

" General {{{
Plug 'junegunn/vim-plug'
Plug 'tpope/vim-sensible'

Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/vim-easy-align'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'kassio/neoterm'

if executable('tmux')
    Plug 'tpope/vim-tbone'
    Plug 'christoomey/vim-tmux-navigator'
endif
" }}}

" Eye candy and color schemes {{{
Plug 'itchyny/lightline.vim'
Plug 'TaDaa/vimade'

" I don't need all of those. But if I want to switch I want
" the others handy. So they are just commented out.
" Plug 'ayu-theme/ayu-vim'
" Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
" Plug 'chriskempson/base16-vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', {'as': 'dracula'}
" Plug 'gruvbox-community/gruvbox'
" Plug 'sonph/onehalf', {'rtp': 'vim'}
" }}}

" Buffers, Files, Searching and Finding {{{
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
" }}}

" Git {{{
Plug 'mhinz/vim-signify'
Plug 'rhysd/git-messenger.vim'
Plug 'jreybert/vimagit'
" }}}

" Snippets {{{
Plug 'sirver/ultisnips'
" Plug 'honza/vim-snippets'
" }}}

" Programming {{{
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-projectionist'

Plug 'embear/vim-localvimrc'

if exists("g:python3_host_prog")
    Plug 'dense-analysis/ale'
    if dotfiles#plugin#selected('lightline.vim')
        Plug 'maximbaz/lightline-ale'
    endif
    if executable('buf')
        Plug 'bufbuild/vim-buf'
    endif
endif


if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/lsp-status.nvim'

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
    " Plug 'majutsushi/tagbar'
    Plug 'liuchengxu/vista.vim'
    Plug 'ludovicchabant/vim-gutentags'
endif

" Golang plugins
if executable('go')
    Plug 'sebdah/vim-delve'
    " Plug 'mattn/vim-goaddtags'
    Plug 'arp242/gopher.vim'
endif

" Clojure plugins
if executable('clj') || executable('clojure') || executable('lein')
    Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
    Plug 'tpope/vim-classpath', {'for': 'clojure'}
    Plug 'tpope/vim-salve', {'for': 'clojure'}
    Plug 'tpope/vim-fireplace', {'for': 'clojure'}
endif

if executable('pio')
    if filereadable(expand('~/Projects/github.com/fhofherr/nvim-pio/bin/nvim-pio'))
        Plug '~/Projects/github.com/fhofherr/nvim-pio'
    else
        " Plug 'fhofherr/nvim-pio', {'do': 'make'}
    endif
endif

Plug 'aklt/plantuml-syntax'
Plug 'aliou/bats.vim'
Plug 'cespare/vim-toml'
Plug 'hashivim/vim-terraform'
Plug 'kylef/apiblueprint.vim'
" }}}

" Wiki {{{
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'
" }}}

" Text editing {{{
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" }}}

call plug#end()
call dotfiles#plugin#load_config($VIMHOME . '/plugin.conf.d')
