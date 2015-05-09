set background=dark
colorscheme jellybeans
 
" set the gui font to use
"
" The following helps to select a new font:
"
"   set guifont=*   " Brings up a selection dialog
"   set guifont?    " Displays the selected font's name
"
" Then add the displayed name below. Note that blanks have to be escaped using
" \.
if has("win32") || has("win64")
    set guifont=consolas:h10
elseif has("gui_macvim")
    set guifont=Monaco:h12
else
    set guifont=DejaVu\ Sans\ Mono\ 10
    " set guifont=Source\ Code\ Pro\ Light\ 11
    " set guifont=Terminus\ 10
endif
 
set ch=1                " Make command line two lines high
set mousehide           " Hide the mouse when typing text
 
" The GUI (i.e. the 'g' in 'gvim') is fantastic, but let's not be
" silly about it :)  The GUI is fantastic, but it's fantastic for
" its fonts and its colours, not for its toolbar and its menus -
" those just steal screen real estate
set guioptions=ac

" Start at a more usable size
set columns=125
set lines=50

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
 
" Stop the blinking cursor
set guicursor=a:blinkon0

" Display trailing newlines
set list

" Width of line number column
set numberwidth=5

" Highlight the 80th colum
if version >= 703
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ColorColumn', '\%80v.', -1)
end

" Very slow for some file types. Therefore only show line numbers.
" if version >= 703
"     " Show relative line numers
"     set relativenumber
" else
"     " Show line numers
"     set number
" endif
set number
