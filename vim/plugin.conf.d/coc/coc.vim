if !dotfiles#plugin#selected('coc.nvim') || exists('g:did_cfg_coc')
    finish
endif
let g:did_cfg_coc = 1

let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-python'
            \ ]

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<CR>"

nnoremap <buffer> <silent> gd :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpDefinition', '')<CR>
nnoremap <buffer> <silent> gD :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpDefinition', 'tabedit')<CR>
nnoremap <buffer> <silent> gy :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpTypeDefinition', '')<CR>
nnoremap <buffer> <silent> gY :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpTypeDefinition', 'tabedit')<CR>
nnoremap <buffer> <silent> gi :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpImplementation', '')<CR>
nnoremap <buffer> <silent> gI :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpImplementation', 'tabedit')<CR>
nnoremap <buffer> <silent> gr :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpReferences', '')<CR>
nnoremap <buffer> <silent> gR :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpReferences', 'tabedit')<CR>

nnoremap <silent> K :call s:show_documentation()<CR>

" Remap for rename current word
nnoremap <buffer> <silent> <F2> <Plug>(coc-rename)

augroup dotfiles_coc_vim
    autocmd!

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

    " Todo: Does not work for some reason :-(
    " autocmd BufWritePre *.go silent call CocAction('runCommand', 'editor.action.organizeImport')
augroup end

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:check_back_space() abort
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~ '\s'
endfunction

function! s:coc_action(action, cmd)
    if a:cmd == ''
        call CocAction(a:action)
    else
        call CocAction(a:action, a:cmd)
    endif
endfunction
