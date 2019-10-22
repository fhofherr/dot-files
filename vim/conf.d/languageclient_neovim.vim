if !has_key(g:plugs, 'LanguageClient-neovim')
    finish
endif

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ }

function s:lc_maps()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
    " Or map each action separately
    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction

augroup dotfiles_languageclient_neovim
    autocmd!
    autocmd FileType * call s:lc_maps()
augroup end
