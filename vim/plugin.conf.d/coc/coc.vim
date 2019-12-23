if !dotfiles#plugin#selected('coc.nvim') || exists('g:did_cfg_coc')
    finish
endif
let g:did_cfg_coc = 1

let g:coc_global_extensions = [
            \ 'coc-json',
            \ 'coc-python',
            \ 'coc-ultisnips'
            \ ]

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<CR>"

nnoremap <silent> gd :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpDefinition', '')<CR>
nnoremap <silent> gD :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpDefinition', 'tabedit')<CR>
nnoremap <silent> gy :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpTypeDefinition', '')<CR>
nnoremap <silent> gY :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpTypeDefinition', 'tabedit')<CR>
nnoremap <silent> gi :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpImplementation', '')<CR>
nnoremap <silent> gI :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpImplementation', 'tabedit')<CR>
nnoremap <silent> gr :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpReferences', '')<CR>
nnoremap <silent> gR :call dotfiles#editor#with_tag_stack('<SID>coc_action', 'jumpReferences', 'tabedit')<CR>

nnoremap <silent> K :call <SID>show_documentation()<CR>

"inoremap <expr> <CR> <SID>select_completion()

" Remap for rename current word
nnoremap <silent> <F2> <Plug>(coc-rename)

augroup dotfiles_coc_vim
    autocmd!

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

    autocmd BufWritePre *.go silent call CocAction('runCommand', 'editor.action.organizeImport')
augroup end

" function! s:select_completion()
"     if complete_info()['selected'] != '-1'
"         return "\<C-g>u\<C-y>"
"     endif
"     return "\<CR>"
" endfunction

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
