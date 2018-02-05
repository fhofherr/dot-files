" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
call plug#begin($VIMHOME."/bundle")
Plug 'junegunn/vim-plug'

" Eye candy and color schemes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-vividchalk'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sirver/ultisnips'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'christoomey/vim-tmux-navigator'

" Code completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-zsh'

" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" Clojure plugins
Plug 'kien/rainbow_parentheses.vim', {'for': 'clojure'}
Plug 'tpope/vim-classpath', {'for': 'clojure'}
Plug 'tpope/vim-salve', {'for': 'clojure'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'venantius/vim-cljfmt', {'for': 'clojure'}

" Go plugins
if executable('go')
    Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
endif

" Text editing
Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
Plug 'reedes/vim-pencil', {'for': ['markdown', 'asciidoc', 'text']}
Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
Plug 'reedes/vim-lexical', {'for': ['markdown', 'asciidoc', 'text']}
Plug 'reedes/vim-wordy', {'for': ['markdown', 'asciidoc', 'text']}

"" TODO what do I need those for? Delete them if nothing breaks.
" Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'tomtom/tlib_vim'

call plug#end()            " required
