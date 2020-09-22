" ---------------------------------------------------------------------------
"
" Function key mappings
"
" ---------------------------------------------------------------------------

" Somehow neovim seems to freeze when pressing an F key in insert mode.
" We map them to a nop to stop this
inoremap <F1> <nop>
inoremap <F2> <nop>
inoremap <F3> <nop>
inoremap <F4> <nop>
inoremap <F5> <nop>
inoremap <F6> <nop>
inoremap <F7> <nop>
inoremap <F8> <nop>
inoremap <F9> <nop>
inoremap <F10> <nop>
inoremap <F11> <nop>
inoremap <F12> <nop>

" Identify active highlight group.
" Source: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


