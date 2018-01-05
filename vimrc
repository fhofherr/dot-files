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
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Raimondi/delimitMate'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'groenewege/vim-less'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ledger/vim-ledger'
Plug 'mileszs/ack.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nanotech/jellybeans.vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sirver/ultisnips'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-salve'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vividchalk'
Plug 'valloric/youcompleteme'
Plug 'venantius/vim-cljfmt'
"
" All of your Plugins must be added before the following line
call plug#end()            " required

" ---------------------------------------------------------------------------
"
" General settings
"
" ---------------------------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup            " keep a backup file
endif

set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" Indent with spaces only by default.
set expandtab           " Use spaces for indenting only
set shiftwidth=4        " Set default indentation width
"" Set the number of spaces a tab counts while editing. When expandtab is
"" enabled, vim will only insert spaces. Else it will insert a combination
"" of tabs and spaces in order to reduce the size of a file.
set softtabstop=4

" Set the characters that listmode should highlight
set lcs=eol:$,tab:>-,trail:·

" Set a nice statusline
set statusline=%{fugitive#statusline()}\ %f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
set laststatus=2

" When spliting horizontaly always split below the current window,
" when spliting verticaly always open the window on the right.
set splitbelow
set splitright

" Color setup
if $TERM == "xterm-256color"
    set background=dark
    colorscheme solarized
else
    set background=dark
    colorscheme default
endif


if $TERM == "xterm-256color" || has("gui_running")
    " Highlight the 80th colum
    if version >= 703
        set colorcolumn=80
    else
        au BufWinEnter * let w:m2=matchadd('ColorColumn', '\%80v.', -1)
    end

    " Width of line number column
    set numberwidth=5
    set number
end

" Display trailing newlines
set list

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
" Colors
"
" ---------------------------------------------------------------------------
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" ---------------------------------------------------------------------------
"
" Shortcuts
"
" ---------------------------------------------------------------------------

let mapleader = ' '

" Toggle list mode
nnoremap <Leader>ls :set invlist<cr>:set list?<cr>

" Turn off that stupid highlight search
nnoremap <Leader>nh :set invhls<cr>:set hls?<cr>

" Set up retabbing on a source file
nnoremap <Leader>rr :1,$retab<cr>

" cd to the directory containing the file in the buffer
nnoremap <Leader>cd :lcd %:p:h<cr>

" cd to the directory containing the file in the buffer and toggle a NERTTree
nnoremap <Leader>nt :NERDTreeToggle<cr>

" Edit vimrc in a split window
nnoremap <Leader>ev :split $MYVIMRC<cr>
" Source the vimrc
nnoremap <Leader>sv :source $MYVIMRC<cr>


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

" Disable anoying insert mode commands
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
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
      au!

      autocmd FileType html setlocal shiftwidth=2

      " Use smartindet for those file types
      autocmd FileType haskell setlocal smartindent

      " When editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid or when inside an event handler
      " (happens when dropping a file on gvim).
      autocmd BufReadPost *
                  \ if line("'\"") > 0 && line("'\"") <= line("$") |
                  \   exe "normal g`\"" |
                  \ endif
  augroup END
else
  set autoindent                " always set autoindenting on
endif " has("autocmd")

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
  autocmd FileType plaintex,tex call pencil#init({'wrap': 'hard', 'textwidth': 78, 'autoformat': 0})
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
" Youcompleteme
"
" ---------------------------------------------------------------------------
"let g:ycm_server_python_interpreter = '/usr/local/bin/python'

" Disable YCM for ledger files. See vim-ledger help.
if exists('g:ycm_filetype_blacklist')
    call extend(g:ycm_filetype_blacklist, { 'ledger': 1 })
endif

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

" ---------------------------------------------------------------------------
"
" Read .vimrc file in cwd.
"
" ---------------------------------------------------------------------------
set exrc			" enable per-directory .vimrc files
set secure			" disable unsafe commands in local .vimrc files
