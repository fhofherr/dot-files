" Set some usefull settings for scala editing.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-05-24
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

" Set continuation options for comments. See $VIMRUNTIME/ftplugin/c.vim
setlocal formatoptions-=t formatoptions+=cqroln
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

inoremap <buffer> ( <ESC>:call InsertPair('(', ')')<CR>i
inoremap <buffer> [ <ESC>:call InsertPair('[', ']')<CR>i
inoremap <buffer> { <ESC>:call InsertPair('{', '}')<CR>i
inoremap <buffer> " <ESC>:call InsertPair('"', '"')<CR>i
