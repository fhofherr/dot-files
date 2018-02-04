" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
function! BuildYCM(info)
    if exists('g:python3_host_prog')
        let cmd = g:python3_host_prog . ' install.py'
    elseif exists('g:python_host_prog')
        let cmd = g:python_host_prog . ' install.py'
    else
        let cmd = './install.py'
    endif
    let cmd = '!' . cmd . ' --system-libclang --clang-completer'

    if executable('xbuild')
        let cmd = cmd . ' --cs-completer'
    endif

    if executable('go')
        let cmd = cmd . ' --go-completer'
    endif

    if executable('node') && executable('npm')
        let cmd = cmd . ' --js-completer'
    endif

    if executable('rustc') && executable('cargo')
        let cmd = cmd . ' --rust-completer'
    endif

    silent execute cmd
endfunction

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
Plug 'valloric/youcompleteme', {'do': function('BuildYCM')}

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
