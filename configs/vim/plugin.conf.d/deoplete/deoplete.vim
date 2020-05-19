" ---------------------------------------------------------------------------
"
" Deoplete
"
" ---------------------------------------------------------------------------
if  !dotfiles#plugin#selected('deoplete.nvim') || exists('g:did_cfg_deoplete')
    finish
endif
let g:did_cfg_deoplete = 1

set completeopt+=noselect

" Use deoplete#enable instead of g:deoplete#enable_at_startup since the latter
" needs to be set before loading deoplete.
call  deoplete#enable()

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" Disable truncating keywords if they exceed a certain width.
call deoplete#custom#source('_', 'max_abbr_width', 0)

" call deoplete#custom#source('ale', 'rank', 999)

call deoplete#custom#option('auto_complete_delay', 200)

call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
" Use tab to cycle through possible completion candidates.
" See: https://github.com/Shougo/deoplete.nvim/blob/dafd92e17b55c001008a7cdb5a339a30fbacf9d5/doc/deoplete.txt#L432
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#manual_complete()

function! s:check_back_space() abort "{{{
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~ '\s'
endfunction"}}}
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Trigger manuall completion using C-<SPACE>
inoremap <expr> <C-SPACE> deoplete#manual_complete()

augroup dotfiles_deoplete
    autocmd!

    " Auto-close preview window upon completion
    " See https://github.com/Shougo/deoplete.nvim/issues/115
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
