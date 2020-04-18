if !dotfiles#plugin#selected('lcn') || exists('g:did_cfg_lcn')
    finish
endif
let g:did_cfg_lcn = 1

let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
let g:LanguageClient_settingsPath = $VIMHOME . '/after/plugin/lcn/settings.json'

let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'go': ['gopls'],
    \ }

" Looks very cool but is distracting
let g:LanguageClient_useVirtualText = "CodeLens"

" Interfers with other plugins that populate the quickfix list, e.g. ack or
" vim-grepper.
let g:LanguageClient_diagnosticsList = 'Disabled'

" Explicitly  configure diagosticsDisplay to avoid overriding the highlight
" groups of ALE.
"
" This seems to happen if ALE gets loaded after LCN. In this case LCN clears
" the ALE* highlight groups.
"
" See: https://github.com/autozimu/LanguageClient-neovim/issues/569
let g:LanguageClient_diagnosticsDisplay = {
            \        1: {
            \            "name": "Error",
            \            "texthl": "ALEError",
            \            "signText": "✖",
            \            "signTexthl": "Error",
            \            "virtualTexthl": "Error",
            \        },
            \        2: {
            \            "name": "Warning",
            \            "texthl": "ALEWarning",
            \            "signText": "⚠",
            \            "signTexthl": "Todo",
            \            "virtualTexthl": "Todo",
            \        },
            \        3: {
            \            "name": "Information",
            \            "texthl": "ALEInfo",
            \            "signText": "ℹ",
            \            "signTexthl": "Todo",
            \            "virtualTexthl": "Todo",
            \        },
            \        4: {
            \            "name": "Hint",
            \            "texthl": "ALEInfo",
            \            "signText": "➤",
            \            "signTexthl": "Todo",
            \            "virtualTexthl": "Todo",
            \        },
            \    }

function! s:lc_buffer_settings()
    if !has_key(g:LanguageClient_serverCommands, &filetype)
        return
    endif

    setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

    nnoremap <buffer> <F5> :call LanguageClient_contextMenu()<CR>
    " Or map each action separately
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <buffer> <silent> gd :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_definition')<CR>
    nnoremap <buffer> <silent> gdt :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_definition', {
                \  'gotoCmd': 'tabnew',
                \})<CR>
    nnoremap <buffer> <silent> gD :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_implementation')<CR>
    nnoremap <buffer> <silent> gDt :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_implementation', {
                \  'gotoCmd': 'tabnew',
                \})<CR>
    nnoremap <buffer> <silent> 1gD :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_typeDefinition')<CR>
    nnoremap <buffer> <silent> 1gDt :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_typeDefinition', {
                \  'gotoCmd': 'tabnew',
                \})<CR>
    nnoremap <buffer> <silent> gr :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_references')<CR>
    nnoremap <buffer> <silent> g0 :call dotfiles#editor#with_tag_stack('LanguageClient#textDocument_documentSymbol')<CR>
    nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
endfunction

augroup dotfiles_languageclient_neovim
    autocmd!
    autocmd FileType * call s:lc_buffer_settings()
augroup end

command -nargs=0 Impls :call LanguageClient#textDocument_implementation()
command -nargs=0 Refs :call LanguageClient#textDocument_references()
