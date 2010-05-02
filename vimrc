" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
"map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  set background=dark
  " Choose a colorscheme
  "colorscheme default
  colorscheme fhlord
  "set t_Co=256         " needed for colorful256 to work in terminal
  "colorscheme colorful256
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " For all tex files set 'textwidth' to 78 characters.
  autocmd FileType tex setlocal textwidth=78

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

"" Set default indentation width
set shiftwidth=4

"" Use spaces for indenting only
set expandtab

"" Set the number of spaces a tab counts while editing. When expandtab is 
"" enabled, vim will only insert spaces. Else it will insert a combination 
"" of tabs and spaces in order to reduce the size of a file.
set softtabstop=4

"" Show line numbers
"set number

" Set the characters that listmode should highlight 
set lcs=eol:$,tab:>-,trail:·

"" Set width of line number bar. As my terminal is set to a width of 85
"" characters and I want exactly room for 80 textcharacters I set it to 5.
"set numberwidth=5

" Set a nice statusline
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
set laststatus=2

" When spliting horizontaly always split below the current window,
" when spliting verticaly always open the window on the right.
set splitbelow 
set splitright

" Some usefull shortcuts

" Toggle list mode
nmap <Leader>ls :set invlist<cr>:set list?<cr>

" Toggle paste mode
nmap <Leader>p :set invpaste<cr>:set paste?<cr>

" Turn off that stupid highlight search
nmap <Leader>n :set invhls<cr>:set hls?<cr>

" Set text wrapping toggles
nmap <Leader>w :set invwrap<cr>:set wrap?<cr>

" Set up retabbing on a source file
nmap <Leader>rr :1,$retab<cr>

" cd to the directory containing the file in the buffer
nmap <Leader>cd :lcd %:p:h<cr>

" cd to the directory containing the file in the buffer and toggle a NERTTree
nmap <Leader>nt :lcd %:p:h<cr>:NERDTreeToggle<cr>

" Make the directory that contains the file in the current buffer.
" This is useful when you edit a file in a directory that doesn't
" (yet) exist
nmap <Leader>md :!mkdir -p %:p:h<cr>

"" Higlight LongLines
highlight LongLine ctermbg=blue guibg=blue
command LongLines
      \ :if exists('w:long_line_match') <Bar>
      \   silent! call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ elseif &textwidth > 0 <Bar>
      \   let w:long_line_match = matchadd('LongLine', '\%>'.&tw.'v.\+', -1) <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('LongLine', '\%>80v.\+', -1) <Bar>
      \ endif
"match column79 /\%<80v.\%>79v/
"
" Delete all trailing whitespace in a file
command  Dtws :%s/\s\+$//

"" Automatically close (, [, and {
" imap ( ()<ESC>i
" imap [ []<ESC>i
" imap { {}<ESC>i

" Settings for latex-suite
"
" grep will sometimes skip displaying the file name if you
" search in a single file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" CTAGS
" Search for tagsfile starting in the current directory. Uses the first 
" tags file found, or finishes if / is reached.
set tags=./tags;
