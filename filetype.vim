" Filetype detection for files whose filetype can be detected via the filename
" See help new-filetype part C.

if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.txt      setfiletype text
    au! BufRead,BufNewFile *.tex      setfiletype tex
    au! BufRead,BufNewFile *.memo     setfiletype text
    au! BufRead,BufNewFile *.R        setfiletype r
    au! BufRead,BufNewFile *.txtl     setfiletype textile
    au! BufRead,BufNewFile *.xml      setfiletype xml
augroup END
