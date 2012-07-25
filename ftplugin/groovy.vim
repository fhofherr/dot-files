" Set some usefull settings for groovy editing.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2012-07-25
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

setlocal smartindent
"
" Set continuation options for comments. See $VIMRUNTIME/ftplugin/c.vim
setlocal formatoptions-=t formatoptions+=cqroln
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
