if !dotfiles#plugin#selected('vim-lsp') || exists('g:did_cfg_vim_lsp')
    finish
endif
let g:did_cfg_vim_lsp = 1

let g:lsp_diagnostics_enabled = 0
let g:lsp_virtual_text_enabled = 0

function! s:lsp_buffer_settings() abort
    setlocal omnifunc+=lsp#complete
    if exists('+tagfunc')
        setlocal tagfunc=lsp#tagfunc
    endif

    nmap <buffer> <silent> K <Plug>(lsp-hover)
    nmap <buffer> <silent> <c-k> <Plug>(lsp-signature-help)
    nmap <buffer> <silent> gd <Plug>(lsp-definition)
    nmap <buffer> <silent> 1gD <Plug>(lsp-type-definition)
    nmap <buffer> <silent> gr <Plug>(lsp-references)
    nmap <buffer> <silent> <F2> <Plug>(lsp-rename)
endfunction

augroup dotfiles_vim_lsp
    autocmd!
    autocmd User lsp_buffer_enabled call <SID>lsp_buffer_settings()
augroup END
