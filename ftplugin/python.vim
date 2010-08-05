" Some local settings for python files.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-08-03 

" inoremap <buffer> ( <ESC>:call InsertPair('(', ')')<CR>i
" inoremap <buffer> [ <ESC>:call InsertPair('[', ']')<CR>i
" inoremap <buffer> { <ESC>:call InsertPair('{', '}')<CR>i
" inoremap <buffer> " <ESC>:call InsertPair('"', '"')<CR>i
" inoremap <buffer> ' <ESC>:call InsertPair("'", "'")<CR>i

abbreviate <buffer> sefl self
abbreviate <buffer> slef self

" Some custom highlightings
match Todo /\.\. todo::/
