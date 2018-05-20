" ---------------------------------------------------------------------------
"
" vim-go
"
" ---------------------------------------------------------------------------
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

augroup golang
    " Go files are to be indented with tabs only.
    au FileType go setlocal noexpandtab |
                 \ setlocal shiftwidth=4 |
                 \ setlocal tabstop=4 |
                 \ setlocal softtabstop=0 |
                 \ setlocal nolist
augroup END
