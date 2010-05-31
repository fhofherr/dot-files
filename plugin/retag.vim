" Re-creates the tags file if it exists in the CWD.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-05-31

if exists("g:retag_loaded")
    finish
endif
let g:retag_loaded = 1
let g:retagMinAgeSecs = 300
let g:retagCtagsCommand = "ctags -R"

function RecreateTags()
    let fname = "tags"
    let fage = localtime() - getftime(fname)
    if filereadable(fname) && fage >= g:retagMinAgeSecs
        call system(g:retagCtagsCommand)
    endif
endfunction

au BufNewFile,BufRead,BufWritePost *.* call RecreateTags()
