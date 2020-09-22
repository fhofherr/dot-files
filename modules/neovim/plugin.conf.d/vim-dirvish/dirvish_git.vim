if !dotfiles#plugin#selected('vim-dirvish-git') || exists('g:did_cfg_vim_dirvish_git')
    finish
endif
let g:did_cfg_vim_dirvish_git = 1

let g:dirvish_git_indicators = {
            \ 'Modified'  : '✹',
            \ 'Staged'    : '✚',
            \ 'Untracked' : '✭',
            \ 'Renamed'   : '➜',
            \ 'Unmerged'  : '═',
            \ 'Ignored'   : '☒',
            \ 'Unknown'   : '?'
            \ }
