" colorscheme fhashen
colorscheme fhlord
set background=dark

" set the X11 font to use
" set guifont=-b&h-lucidatypewriter-medium-*-*-*-10-*-*-*-*-*-*-*
if has("win32") || has("win64")
    set guifont=consolas:h10
else
    set guifont=Terminus\ 12
endif
" set guifont=Bitstream\ Vera\ Sans\ Mono\ 11 
" set guifont=Monospace\ 11 

set ch=1                " Make command line two lines high
set mousehide           " Hide the mouse when typing text

" The GUI (i.e. the 'g' in 'gvim') is fantastic, but let's not be
" silly about it :)  The GUI is fantastic, but it's fantastic for
" its fonts and its colours, not for its toolbar and its menus -
" those just steal screen real estate
set guioptions=ac

" Start at a more usable size
set columns=120
set lines=50

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>

" Stop the blinking cursor
set guicursor=a:blinkon0

" Width of line number column
set numberwidth=5
if version >= 703
    set colorcolumn=80
    " Show relative line numers
    set relativenumber
else
    au BufWinEnter * let w:m2=matchadd('ColorColumn', '\%80v.', -1)

    " Show line numers
    set number
endif
