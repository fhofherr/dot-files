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

if !g:local_vim_minimal
    Plug 'junegunn/fzf', {'do': './install --all'}
    Plug 'junegunn/fzf.vim'
    Plug 'godlygeek/tabular'
    Plug 'mileszs/ack.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/syntastic'
    Plug 'sirver/ultisnips'

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
    " Plug 'drewtempelmeyer/palenight.vim'
    " Plug 'morhetz/gruvbox'
    Plug 'arcticicestudio/nord-vim'

    " Code completion
    if has('nvim')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'Shougo/neco-vim'
    Plug 'zchee/deoplete-jedi'
    Plug 'zchee/deoplete-zsh'
    Plug 'ervandew/supertab'

    " Git
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-git'

    " Clojure plugins
    if executable('lein')
        Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
        Plug 'tpope/vim-classpath', {'for': 'clojure'}
        Plug 'tpope/vim-salve', {'for': 'clojure'}
        Plug 'tpope/vim-fireplace', {'for': 'clojure'}
        Plug 'venantius/vim-cljfmt', {'for': 'clojure'}
        Plug 'clojure-vim/async-clj-omni', {'for': 'clojure'}
        if has('nvim')
            Plug 'snoe/clj-refactor.nvim', {'for': 'clojure', 'do': ':UpdateRemotePlugins'}
        endif
    endif

    " Go plugins
    if executable('go')
        Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
        Plug 'zchee/deoplete-go', {'for': 'go'}
    endif

    " Text editing
    Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
    Plug 'reedes/vim-pencil', {'for': ['markdown', 'asciidoc', 'text']}
    Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
    Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
    Plug 'reedes/vim-wordy', {'for': ['markdown', 'asciidoc', 'text']}
endif
call plug#end()            " required
