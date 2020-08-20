if !dotfiles#plugin#selected('nvim-lsp') || exists('g:did_cfg_nvim_lsp')
    finish
endif

let g:did_cfg_nvim_lsp = 1

" Gopls
lua <<EOF
require("dotfiles/lsp").setup()
EOF

function! s:lsp_buffer_settings() abort
    " Always attach to the first client for now. Later we might want to try
    " to find the correct client based on the buffer's file type.
    lua vim.lsp.buf_attach_client(0, 1)

    setlocal omnifunc=v:lua.vim.lsp.omnifunc

    nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> <c-s> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <buffer> <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <buffer> <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <buffer> <silent> <F2>  <cmd>lua vim.lsp.buf.rename()<CR>
endfunction

augroup dotfiles_nvim_lsp
    autocmd!
    autocmd FileType go,python call <SID>lsp_buffer_settings()
augroup END
