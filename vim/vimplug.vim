" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
let $VIMPLUGHOME = $HOME . '/.vimplug'
call plug#begin($VIMPLUGHOME)
Plug 'junegunn/vim-plug'

Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', 'as': 'lcn' }
Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
Plug 'embear/vim-localvimrc'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', {'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-signify'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'Raimondi/delimitMate'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sirver/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'vimlab/split-term.vim'

" Eye candy and color schemes
Plug 'itchyny/lightline.vim'
" I don't need all of those. But if I want to switch I want
" the others handy. So they are just commented out.
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'morhetz/gruvbox'
" Plug 'reedes/vim-colors-pencil'
if exists('$DOTFILES_COLOR_PROFILE') && $DOTFILES_COLOR_PROFILE == 'dark'
    Plug 'dracula/vim', {'as': 'dracula'}
else
    Plug 'altercation/vim-colors-solarized'
endif

" Some plugins require Python 3 to work properly.
if exists("g:python3_host_prog")
    Plug 'dense-analysis/ale'
    if has_key(g:plugs, 'lightline.vim')
        Plug 'maximbaz/lightline-ale'
    endif
endif

" Requires universal-ctags (https://ctags.io)
" Install with: brew install --HEAD universal-ctags/universal-ctags/universal-ctags on Mac
if executable('ctags')
    Plug 'majutsushi/tagbar'
endif

if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
endif

" Clojure plugins
if executable('clj') || executable('clojure') || executable('lein')
    Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
    Plug 'tpope/vim-classpath', {'for': 'clojure'}
    Plug 'tpope/vim-salve', {'for': 'clojure'}
    Plug 'tpope/vim-fireplace', {'for': 'clojure'}
endif

" Go plugins
if executable('go')
    Plug 'sebdah/vim-delve'
endif

" Deoplete extensions
if has_key(g:plugs, 'deoplete.nvim')
    Plug 'Shougo/neco-vim'

    if !has_key(g:plugs,  'lcn') && (executable('python') || executable('python3'))
        Plug 'deoplete-plugins/deoplete-jedi'
    endif
endif

call plug#end()
