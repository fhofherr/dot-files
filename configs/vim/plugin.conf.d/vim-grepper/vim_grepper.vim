if !dotfiles#plugin#selected('vim-grepper') || exists('g:did_cfg_vim_grepper')
    finish
endif
let g:did_cfg_vim_grepper = 1

g:grepper = {'operator': {'tools': ['ag']}}

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)
