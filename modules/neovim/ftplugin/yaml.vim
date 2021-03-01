if exists('g:dotfiles_did_yaml')
    finish
endif
let g:dotfiles_did_yaml = 1

augroup dotfiles_yaml
    autocmd!
    autocmd BufEnter *.{yaml,yml} setlocal indentkeys-=<:> cursorcolumn
augroup END
