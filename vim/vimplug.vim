" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
let $VIMPLUGHOME = $HOME . '/.vimplug'
call plug#begin($VIMPLUGHOME)
Plug 'junegunn/vim-plug'
Plug 'tpope/vim-sensible'

" Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', 'as': 'lcn' }
Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'editorconfig/editorconfig-vim'
Plug 'embear/vim-localvimrc'
"Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'hashivim/vim-terraform'
Plug 'janko/vim-test'
Plug 'junegunn/fzf', {'do': './install --all --no-update-rc'}
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-signify'
" Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'Raimondi/delimitMate'
" Plug 'reedes/vim-lexical'
" Plug 'reedes/vim-pencil'
" Plug 'reedes/vim-wordy'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sirver/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
" Plug 'vimlab/split-term.vim'
Plug 'kassio/neoterm'

" Eye candy and color schemes
Plug 'itchyny/lightline.vim'

" I don't need all of those. But if I want to switch I want
" the others handy. So they are just commented out.
if $DOTFILES_COLOR_THEME == 'challenger-deep'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
elseif $DOTFILES_COLOR_THEME == 'dracula'
    Plug 'dracula/vim', {'as': 'dracula'}
elseif $DOTFILES_COLOR_THEME == 'falcon'
    Plug 'fenetikm/falcon'
elseif $DOTFILES_COLOR_THEME == 'onehalf'
    Plug 'sonph/onehalf', {'rtp': 'vim'}
endif

" Some plugins require Python 3 to work properly.
if exists("g:python3_host_prog")
    Plug 'dense-analysis/ale'
    if dotfiles#plugin#selected('lightline.vim')
        Plug 'maximbaz/lightline-ale'
    endif
endif

" Works best with universal-ctags (https://ctags.io)
" Install with: brew install --HEAD universal-ctags/universal-ctags/universal-ctags on Mac
if executable('ctags')
    Plug 'majutsushi/tagbar'
    " Plug 'ludovicchabant/vim-gutentags'
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
" if has_key(g:plugs, 'deoplete.nvim')
"     Plug 'Shougo/neco-vim'
"
"     if !has_key(g:plugs,  'lcn') && (executable('python') || executable('python3'))
"         Plug 'deoplete-plugins/deoplete-jedi'
"     endif
" endif

if has_key(g:plugs, 'deoplete.nvim')
    Plug 'Shougo/neco-vim'
    Plug 'neoclide/coc-neco'
endif

call plug#end()
call dotfiles#plugin#load_config($VIMHOME . '/plugin.conf.d')
