colorscheme fhashen

" set the X11 font to use
" set guifont=-b&h-lucidatypewriter-medium-*-*-*-10-*-*-*-*-*-*-*
" set guifont=Terminus\ 12 
set guifont=Bitstream\ Vera\ Sans\ Mono\ 11 
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

" Show line numers
set number
set numberwidth=5

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>

" Stop the blinking cursor
set guicursor=a:blinkon0

" Higlight the 80th column.
" Vim 7.3 has a colorcolumn command. For versions lower than 7.3
" we have to use a different approach.
if has("colorcolumn")
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('LongLine', '\%80v.', -1)
endif
