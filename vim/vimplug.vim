" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
let $VIMPLUGHOME = $HOME . '/.vimplug'
call plug#begin($VIMPLUGHOME)
Plug 'junegunn/vim-plug'

Plug 'tpope/vim-sensible'
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

if $DOTFILES_MINIMAL == 'false'
    Plug 'godlygeek/tabular'
    Plug 'junegunn/fzf', {'do': './install --all --no-update-rc'}
    Plug 'junegunn/fzf.vim'
    Plug 'mileszs/ack.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'sirver/ultisnips'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-projectionist'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-tbone'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-obsession'
    Plug 'w0rp/ale'
    Plug 'embear/vim-localvimrc'

    " Requires universal-ctags (https://ctags.io)
    " Install with: brew install --HEAD universal-ctags/universal-ctags/universal-ctags on Mac
    if executable('ctags')
        Plug 'majutsushi/tagbar'
    endif

    if has('nvim')
        Plug 'vimlab/split-term.vim'
    endif

    " Code completion
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif

    if executable('tmux')
        Plug 'christoomey/vim-tmux-navigator'
    endif

    " Eye candy and color schemes
    Plug 'itchyny/lightline.vim'
    " I don't need all of those. But if I want to switch I want
    " the others handy. So they are just commented out.
    " Plug 'altercation/vim-colors-solarized'
    " Plug 'drewtempelmeyer/palenight.vim'
    " Plug 'morhetz/gruvbox'
    " Plug 'arcticicestudio/nord-vim'
    " Plug 'reedes/vim-colors-pencil'
    Plug 'dracula/vim', {'as': 'dracula'}

    " Clojure plugins
    if executable('clj') || executable('clojure') || executable('lein')
        Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
        Plug 'tpope/vim-classpath', {'for': 'clojure'}
        Plug 'tpope/vim-salve', {'for': 'clojure'}
        Plug 'tpope/vim-fireplace', {'for': 'clojure'}
    endif

    " Go plugins
    if executable('go')
        Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
        Plug 'jodosha/vim-godebug'
    endif

    " Text editing
    Plug 'reedes/vim-lexical'
    Plug 'reedes/vim-pencil'
    Plug 'reedes/vim-wordy'
endif
call plug#end()            " required
