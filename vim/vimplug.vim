" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
call plug#begin($VIMHOME."/bundle")
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
    Plug 'junegunn/fzf', {'do': './install --all'}
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
    Plug 'janko-m/vim-test'

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
    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh' }

    " Eye candy and color schemes
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    if executable('tmux')
        Plug 'edkolev/tmuxline.vim'
        Plug 'christoomey/vim-tmux-navigator'
    endif
    " I don't need all of those. But if I want to switch I want
    " the others handy. So they are just commented out.
    " Plug 'altercation/vim-colors-solarized'
    Plug 'drewtempelmeyer/palenight.vim'
    " Plug 'morhetz/gruvbox'
    " Plug 'arcticicestudio/nord-vim'

    " Clojure plugins
    if executable('clj') || executable('clojure') || executable('lein')
        Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
        Plug 'tpope/vim-classpath', {'for': 'clojure'}
        Plug 'tpope/vim-salve', {'for': 'clojure'}
        Plug 'tpope/vim-fireplace', {'for': 'clojure'}
    endif

    " CommonLisp plugins
    if executable('sbcl')
        Plug 'l04m33/vlime', {'rtp': './vim', 'for': 'lisp'}
    endif

    " Go plugins
    if executable('go')
        Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries'}
        Plug 'zchee/deoplete-go', {'do': 'make'}
    endif

    " Text editing
    Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
    Plug 'reedes/vim-pencil', {'for': ['markdown', 'asciidoc', 'text']}
    Plug 'reedes/vim-wordy', {'for': ['markdown', 'asciidoc', 'text']}
endif
call plug#end()            " required
