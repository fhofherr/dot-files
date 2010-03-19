" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

colorscheme colorful256
set background=dark

" set the X11 font to use
" set guifont=-b&h-lucidatypewriter-medium-*-*-*-12-*-*-*-*-*-*-*
" set guifont=Terminus\ 12 
" set guifont=Bitstream\ Vera\ Sans\ Mono\ 10 
set guifont=Monospace\ 10 

set ch=1		" Make command line two lines high
set mousehide		" Hide the mouse when typing text

" The GUI (i.e. the 'g' in 'gvim') is fantastic, but let's not be
" silly about it :)  The GUI is fantastic, but it's fantastic for
" its fonts and its colours, not for its toolbar and its menus -
" those just steal screen real estate
set guioptions=ac

" Start at a more usable size
set columns=120
set lines=50

" Show line numers
set number
set numberwidth=5

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting.
  set hlsearch

  " For Win32 version, have "K" lookup the keyword in a help file
  "if has("win32")
  "  let winhelpfile='windows.hlp'
  "  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  "endif
  
endif
