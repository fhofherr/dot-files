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
