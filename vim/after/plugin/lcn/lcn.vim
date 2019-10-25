if !dotfiles#plugin#selected('lcn') || exists('g:did_cfg_lcn')
    finish
endif
let g:did_cfg_lcn = 1

let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
let g:LanguageClient_settingsPath = $VIMHOME . '/after/plugin/lcn/ls_settings.json'

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ }

" Looks very cool but is distracting
let g:LanguageClient_useVirtualText = 0

" Copied and adapted from ALE function ale#definition#UpdateTagStack().
" See: https://github.com/dense-analysis/ale/blob/v2.6.0/autoload/ale/definition.vim#L23
function! Dotfiles_lc_with_tagstack(func, ...) abort
    if exists('*gettagstack') && exists('*settagstack')
        " Grab the old location (to jump back to) and the word under the
        " cursor (as a label for the tagstack)
        let l:old_location = [bufnr('%'), line('.'), col('.'), 0]
        let l:tagname = expand('<cword>')
        let l:winid = win_getid()
        call settagstack(l:winid, {'items': [{'from': l:old_location, 'tagname': l:tagname}]}, 'a')
        call settagstack(l:winid, {'curidx': len(gettagstack(l:winid)['items']) + 1})
    endif

    return call(a:func, a:000)
endfunction

function! s:lc_buffer_settings()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

    nnoremap <buffer> <F5> :call LanguageClient_contextMenu()<CR>
    " Or map each action separately
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call Dotfiles_lc_with_tagstack('LanguageClient#textDocument_definition')<CR>
    nnoremap <buffer> <silent> gD :call Dotfiles_lc_with_tagstack('LanguageClient#textDocument_definition', {
                \  'gotoCmd': 'tabnew',
                \})<CR>
    nnoremap <buffer> <silent> gy :call Dotfiles_lc_with_tagstack('LanguageClient#textDocument_typeDefinition')<CR>
    nnoremap <buffer> <silent> gY :call Dotfiles_lc_with_tagstack('LanguageClient#textDocument_typeDefinition', {
                \  'gotoCmd': 'tabnew',
                \})<CR>
    nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction

augroup dotfiles_languageclient_neovim
    autocmd!
    autocmd FileType * call s:lc_buffer_settings()
augroup end

command -nargs=0 Impls :call LanguageClient#textDocument_implementation()
command -nargs=0 Refs :call LanguageClient#textDocument_references()
