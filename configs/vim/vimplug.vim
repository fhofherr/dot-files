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
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'kassio/neoterm'

" Plug 'jiangmiao/auto-pairs'
if executable('tmux')
    Plug 'tpope/vim-tbone'
    Plug 'christoomey/vim-tmux-navigator'
endif
" }}}

" Eye candy and color schemes {{{
Plug 'itchyny/lightline.vim'

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
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

Plug 'mhinz/vim-grepper'
Plug 'nelstrom/vim-visual-star-search'
" }}}

" Git {{{
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'junegunn/gv.vim' " requires fugitive
" }}}

" Snippets {{{
Plug 'sirver/ultisnips'
" Plug 'honza/vim-snippets'
" }}}

" Programming {{{
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-projectionist'

if exists("g:python3_host_prog")
    Plug 'dense-analysis/ale'
    if dotfiles#plugin#selected('lightline.vim')
        Plug 'maximbaz/lightline-ale'
    endif
    if executable('buf')
        Plug 'bufbuild/vim-buf'
    endif
endif

let s:use_built_in_lsp = v:false
if has('nvim-0.5') && s:use_built_in_lsp
    Plug 'neovim/nvim-lsp'
else
    " Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', 'as': 'lcn' }
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
endif

Plug 'prabirshrestha/asyncomplete.vim'
if dotfiles#plugin#selected('asyncomplete.vim')
    Plug 'prabirshrestha/asyncomplete-buffer.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    Plug 'prabirshrestha/asyncomplete-emoji.vim'
    Plug 'yami-beta/asyncomplete-omni.vim'

    Plug 'Shougo/neco-vim'
    Plug 'prabirshrestha/asyncomplete-necovim.vim'

    Plug 'prabirshrestha/asyncomplete-tags.vim'

    if dotfiles#plugin#selected('vim-lsp')
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
    endif

    if dotfiles#plugin#selected('ultisnips')
        Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
    endif
endif

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
if dotfiles#plugin#selected('deoplete.nvim')
    Plug 'Shougo/neco-vim'

    if !dotfiles#plugin#selected('lcn') && (executable('python') || executable('python3'))
        Plug 'deoplete-plugins/deoplete-jedi'
    endif

    Plug 'Shougo/echodoc.vim'
    Plug 'Shougo/context_filetype.vim'
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

Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'hashivim/vim-terraform'
Plug 'kylef/apiblueprint.vim'
" }}}

call plug#end()
call dotfiles#plugin#load_config($VIMHOME . '/plugin.conf.d')
