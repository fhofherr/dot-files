" Provides a function to insert a pair of characters into the buffer and
" a mapping (<C-j>) to jump after the second inserted character.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-08-01
" Version:     0.1

if exists("g:vim_autoclose_loaded")
    finish
endif 
let g:vim_autoclose_loaded = 1

" Inserts a:open and a:close into the buffer.
" Sets b:jumpAfterCharacter as a side effect
function InsertPair(open, close)
    let b:jumpAfterCharacter = a:close
    exec "normal! a" . a:open . a:close
endfunction

imap <C-j> <ESC>:exec "normal f" . b:jumpAfterCharacter<CR>a
