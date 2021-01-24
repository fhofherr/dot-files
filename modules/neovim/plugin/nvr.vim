" ---------------------------------------------------------------------------
" terminal and neovim-remote settings
" ---------------------------------------------------------------------------
if exists('g:did_cfg_nvr')
    finish
endif
let g:did_cfg_nvr = 1

if !has('nvim') || !executable('nvr')
    finish
endif

augroup dotfiles_nvr
    autocmd!
    autocmd FileType gitcommit,gitrebase,gitconfig setlocal bufhidden=delete
augroup END

