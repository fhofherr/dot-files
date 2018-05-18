" ---------------------------------------------------------------------------
"
" YouCompleteMe
"
" ---------------------------------------------------------------------------
if !empty(g:python3_host_prog)
    let g:ycm_python_binary_path=g:python3_host_prog
    let g:ycm_server_python_interpreter=g:python3_host_prog
elseif !empty(g:python2_host_prog)
    let g:ycm_python_binary_path=g:python2_host_prog
    let g:ycm_server_python_interpreter=g:python2_host_prog
endif

augroup load_ycm
  autocmd!
  autocmd InsertEnter * call plug#load('youcompleteme')
                     \| autocmd! load_ycm
augroup END
