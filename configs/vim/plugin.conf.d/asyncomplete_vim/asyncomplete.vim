if !dotfiles#plugin#selected('asyncomplete.vim') || exists('g:did_cfg_asyncomplete')
    finish
endif
let g:did_cfg_asyncomplete = 1

let g:asyncomplete_popup_delay = 15

" allow modifying the completeopt variable, or it will
" be overridden all the time
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

function! s:check_back_space() abort "{{{
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~ '\s'
endfunction"}}}

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ asyncomplete#force_refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Trigger manual completion using c-space
imap <c-space> <Plug>(asyncomplete_force_refresh)

inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

function s:configure_asyncomplete()
    if dotfiles#plugin#selected('ale') && get(g:, 'ale_disable_lsp', 0) == 0
        call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
                    \ 'name': 'ale',
                    \ 'whitelist': ['*'],
                    \ }))
    endif

    if dotfiles#plugin#selected('asyncomplete-buffer.vim')
        call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                    \ 'name': 'buffer',
                    \ 'whitelist': ['*'],
                    \ 'blacklist': ['go'],
                    \ 'completor': function('asyncomplete#sources#buffer#completor'),
                    \ }))
    endif

    if dotfiles#plugin#selected('asyncomplete-file.vim')
        call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                    \ 'name': 'file',
                    \ 'whitelist': ['*'],
                    \ 'completor': function('asyncomplete#sources#file#completor')
                    \ }))
    endif

    if dotfiles#plugin#selected('asyncomplete-emoji.vim')
        call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                    \ 'name': 'emoji',
                    \ 'whitelist': ['markdown', 'email'],
                    \ 'completor': function('asyncomplete#sources#emoji#completor')
                    \ }))
        command Emoji %s/:\([^:]\+\):/\=asyncomplete#sources#emoji#data#emoji_for(submatch(1), submatch(0))/g
    endif

    if dotfiles#plugin#selected('asyncomplete-necovim.vim')
        call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
                    \ 'name': 'necovim',
                    \ 'whitelist': ['vim'],
                    \ 'completor': function('asyncomplete#sources#necovim#completor'),
                    \ }))
    endif

    if dotfiles#plugin#selected('asyncomplete-omni.vim')
        call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
                    \ 'name': 'omni',
                    \ 'whitelist': ['*'],
                    \ 'blacklist': ['c', 'cpp', 'go', 'html'],
                    \ 'completor': function('asyncomplete#sources#omni#completor')
                    \  }))
    endif

    if dotfiles#plugin#selected('asyncomplete-tags.vim')
        call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                    \ 'name': 'tags',
                    \ 'whitelist': ['c'],
                    \ 'completor': function('asyncomplete#sources#tags#completor'),
                    \ }))
    endif

    if dotfiles#plugin#selected('asyncomplete-ultisnips.vim')
        call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
                    \ 'name': 'ultisnips',
                    \ 'whitelist': ['*'],
                    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
                    \ }))
    endif
endfunction

augroup dotfiles_asyncomplete
    autocmd!

    " Auto-close preview window after completion
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    autocmd User asyncomplete_setup call <SID>configure_asyncomplete()
augroup END
