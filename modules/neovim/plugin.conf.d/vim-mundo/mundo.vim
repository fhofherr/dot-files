if !dotfiles#plugin#selected('vim-mundo') || exists('g:did_cfg_mundo')
    finish
endif
let g:did_cfg_mundo = 1

set undofile
" Default undodir is good for us

augroup dotfiles_mundo
    autocmd!

    autocmd BufWritePre /tmp/* setlocal noundofile
    autocmd FileType gitcommit,gitrebase,gitconfig setlocal noundofile
augroup END
