if !has_key(g:plugs, 'LanguageClient-neovim')
    finish
endif

let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ }

function s:lc_buffer_settings()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

    nnoremap <buffer> <F5> :call LanguageClient_contextMenu()<CR>
    " Or map each action separately
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction

augroup dotfiles_languageclient_neovim
    autocmd!
    autocmd FileType * call s:lc_buffer_settings()
augroup end
