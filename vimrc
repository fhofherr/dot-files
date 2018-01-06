" ---------------------------------------------------------------------------
" Set vimhome according to OS
" ---------------------------------------------------------------------------
if has('win32') || has ('win64')
    let $VIMHOME = $VIM."/vimfiles"
else
    let $VIMHOME = $HOME."/.vim"
endif
" ---------------------------------------------------------------------------
"
" vim-plug
"
" ---------------------------------------------------------------------------
if empty(glob($VIMHOME.'/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($VIMHOME."/bundle")

Plug 'junegunn/vim-plug'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'Raimondi/delimitMate'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sirver/ultisnips'
Plug 'tpope/vim-surround'
Plug 'kien/rainbow_parentheses.vim'

" Code completion
Plug 'valloric/youcompleteme', {'do': './install.py --clang-completer --gocode-completer'}

" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" Clojure plugins
Plug 'tpope/vim-classpath', {'for': 'clojure'}
Plug 'tpope/vim-salve', {'for': 'clojure'}
Plug 'tpope/vim-projectionist', {'for': 'clojure'}
Plug 'tpope/vim-dispatch', {'for': 'clojure'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'venantius/vim-cljfmt', {'for': 'clojure'}

" Go plugins
Plug 'fatih/vim-go', {'for': 'go'}

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

" ---------------------------------------------------------------------------
"
" General settings
"
" ---------------------------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nobackup                   " never keep backup files
set history=50                 " keep 50 lines of command line history
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set incsearch                  " do incremental searching
set expandtab                  " Use spaces for indenting only
set shiftwidth=4               " Set default indentation width
"" Set the number of spaces a tab counts while editing. When expandtab is
"" enabled, vim will only insert spaces. Else it will insert a combination
"" of tabs and spaces in order to reduce the size of a file.
set softtabstop=4

" Set the characters that listmode should highlight
set lcs=eol:$,tab:>-,trail:·
set list

" Set a nice statusline
set statusline=%{fugitive#statusline()}\ %f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
set laststatus=2

" When spliting horizontaly always split below the current window,
" when spliting verticaly always open the window on the right.
set splitbelow
set splitright

" 256 Color setup
if &t_Co == 256 || has("gui_running")
    set background=dark
    colorscheme solarized

    " Highlight the 80th colum
    set colorcolumn=80

    " Width of line number column
    set numberwidth=5
    set number
else
    set background=dark
    colorscheme default
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Enhance Tab completion of vim commands.
set wildmenu wildmode=list:longest

" Improve joining of comment lines.
" Found at https://kinbiko.com/vim/my-shiniest-vim-gems/
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

language messages en_US.UTF-8

" ---------------------------------------------------------------------------
"
" Shortcuts
"
" ---------------------------------------------------------------------------

let mapleader = ' '

" Toggle list mode
nnoremap <Leader>ls :set invlist<cr>:set list?<cr>

" Turn off highlight search
nnoremap <Leader>nh :set invhls<cr>:set hls?<cr>

" cd to the directory containing the file in the buffer and toggle a NERTTree
nnoremap <Leader>nt :NERDTreeToggle<cr>

" Identify active highlight group.
" Source: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Move between windows using CTRL+{hjkl}
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l

" Disable insert mode commands
imap <c-a> <Nop>
imap <c-c> <Nop>
imap <c-h> <Nop>
imap <c-u> <Nop>
imap <c-w> <Nop>
" ---------------------------------------------------------------------------
"
" Autocommands
"
" ---------------------------------------------------------------------------
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif
"
" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
" See: http://stackoverflow.com/questions/3105307/how-do-you-automatically-remove-the-preview-window-after-autocompletion-in-vim
" and http://stackoverflow.com/questions/11733388/how-do-i-prevent-my-vim-autocmd-from-running-in-the-command-line-window
autocmd CursorMovedI *  if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif

" ---------------------------------------------------------------------------
"
" Ack
"
" ---------------------------------------------------------------------------
nmap \a <Esc>:Ack!
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
command! Todo Ack! 'TODO|FIXME|XXX'

" ---------------------------------------------------------------------------
"
" Rainbow Parentheses
"
" ---------------------------------------------------------------------------

" Enable rainbow parentheses for all buffers
augroup rainbow_parentheses
  au!
  au VimEnter * RainbowParenthesesActivate
  au BufEnter * RainbowParenthesesLoadRound
  au BufEnter * RainbowParenthesesLoadSquare
  au BufEnter * RainbowParenthesesLoadBraces
augroup END

" ---------------------------------------------------------------------------
"
" NERDTree
"
" ---------------------------------------------------------------------------

let NERDTreeIgnore=['\~$', '__pycache__', '.egg-info']

" ---------------------------------------------------------------------------
"
" UltiSnips
"
" ---------------------------------------------------------------------------
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger="<c-j>"

" ---------------------------------------------------------------------------
"
" HTML
"
" ---------------------------------------------------------------------------

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody,main,section"
autocmd FileType html setlocal shiftwidth=2

" ---------------------------------------------------------------------------
"
" Haskell
"
" ---------------------------------------------------------------------------
autocmd FileType haskell setlocal smartindent

" ---------------------------------------------------------------------------
"
" vim-go
"
" ---------------------------------------------------------------------------
let g:go_fmt_fail_silently = 1

augroup golang
    " Go files are to be indented with tabs only.
    au FileType go setlocal noexpandtab |
                 \ setlocal shiftwidth=4 |
                 \ setlocal tabstop=4 |
                 \ setlocal softtabstop=0 |
                 \ setlocal nolist
augroup END

" ---------------------------------------------------------------------------
"
" Syntastic
"
" ---------------------------------------------------------------------------

" we want to tell the syntastic module when to run
" we want to see code highlighting and checks when  we open a file
" but we don't care so much that it reruns when we close the file
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_go_checkers = ['gometalinter']
" Disable all linters then enable the select few we are interested in.
let g:syntastic_go_gometalinter_args = "--no-config --disable-all --enable=vet --enable=golint --enable=errcheck"

" ---------------------------------------------------------------------------
"
" Vim Pencil
"
" ---------------------------------------------------------------------------

let g:pencil#textwidth = 72
let g:pencil#conceallevel = 0

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init({'wrap': 'hard', 'autoformat': 0})
                            \ | call lexical#init({
                            \       'spell': 1,
                            \       'spelllang': ['en_us']
                            \   })
  autocmd FileType asciidoc call pencil#init({'wrap': 'soft'})
  autocmd FileType text call pencil#init({'wrap': 'hard', 'autoformat': 0})
  autocmd FileType mail call pencil#init({'wrap': 'hard', 'autoformat': 0})
augroup END

" ---------------------------------------------------------------------------
"
" Delimitmate
"
" ---------------------------------------------------------------------------

augroup delimitmate
    au FileType sql let b:delimitMate_expand_cr = 1
    au FileType sql let b:delimitMate_expand_space = 1

    au FileType json let b:delimitMate_expand_cr = 1
    au FileType json let b:delimitMate_expand_space = 1

    au FileType javascript let b:delimitMate_expand_cr = 1
    au FileType javascript let b:delimitMate_expand_space = 1

    au FileType clojure let b:delimitMate_quotes = "\""
    au FileType clojure let b:delimitMate_expand_cr = 1

    au FileType ruby let b:delimitMate_expand_cr = 1
    au FileType ruby let b:delimitMate_expand_space = 1

    au FileType scss let b:delimitMate_expand_cr = 1
    au FileType scss let b:delimitMate_expand_space = 1

    au FileType go let b:delimitMate_expand_cr = 1
    au FileType go let b:delimitMate_expand_space = 1
augroup END

" ---------------------------------------------------------------------------
"
" fzf.vim
"
" ---------------------------------------------------------------------------
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }
"
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
