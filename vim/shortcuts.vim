" ---------------------------------------------------------------------------
"
" Shortcuts
"
" ---------------------------------------------------------------------------

let mapleader = ' '
let maplocalleader = ' '

" Toggle NERDTree
nnoremap <Leader>nt :NERDTreeToggle<cr>

" Identify active highlight group.
" Source: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Disable insert mode commands
imap <c-a> <Nop>
imap <c-c> <Nop>
imap <c-h> <Nop>
imap <c-u> <Nop>
imap <c-w> <Nop>

" Re-map [ to - and ] to _.
" See https://github.com/tpope/vim-unimpaired#faq
nmap - [
nmap _ ]
omap - [
omap _ ]
xmap - [
xmap _ ]
