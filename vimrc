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
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

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
  " Tell vim that the terminal background is dark
  set background=light
  " Choose a colorscheme
  "colorscheme default
  "colorscheme fhlord
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

  " Read some templates when new files of this type are created
  autocmd BufNewFile *.py 0r ~/.vim/templates/template.py
  autocmd BufNewFile *.rst 0r ~/.vim/templates/template.rst

else

  set autoindent		" always set autoindenting on

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

"" Set width of line number bar. As my terminal is set to a width of 85
"" characters and I want exactly room for 80 textcharacters I set it to 5.
"set numberwidth=5

"" Higlight column 79
highlight column79 ctermbg=blue guibg=blue
match column79 /\%<80v.\%>79v/

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

