if !dotfiles#plugin#selected('vim-grepper') || exists('g:did_cfg_vim_grepper')
    finish
endif
let g:did_cfg_vim_grepper = 1

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

if executable('ag')
    command -nargs=+ Ag GrepperAg <args>
endif

if executable('rg')
    command -nargs=+ Rg GrepperRg <args>
endif
