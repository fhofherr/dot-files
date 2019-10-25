" ---------------------------------------------------------------------------
"
" Deoplete
"
" ---------------------------------------------------------------------------
if  !dotfiles#plugin#selected('deoplete.nvim') || exists('g:did_cfg_deoplete')
    finish
endif
let g:did_cfg_deoplete = 1

" Use deoplete#enable instead of g:deoplete#enable_at_startup since the latter
" needs to be set before loading deoplete.
call  deoplete#enable()

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
call deoplete#custom#source('ale', 'rank', 999)

call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

augroup dotfiles_deoplete
    autocmd!

    " Auto-close preview window upon completion
    " See https://github.com/Shougo/deoplete.nvim/issues/115
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end
