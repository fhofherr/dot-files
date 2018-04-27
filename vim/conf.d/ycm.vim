" ---------------------------------------------------------------------------
"
" YouCompleteMe
"
" ---------------------------------------------------------------------------
if !empty(g:python3_host_prog)
    let g:ycm_python_binary_path=g:python3_host_prog
elseif !empty(g:python2_host_prog)
    let g:ycm_python_binary_path=g:python2_host_prog
endif
