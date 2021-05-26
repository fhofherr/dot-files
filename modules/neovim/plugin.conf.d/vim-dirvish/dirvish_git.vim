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


augroup dotfiles_dirvish_git_config
    autocmd!
    autocmd FileType dirvish nmap <silent><buffer><C-n> <Plug>(dirvish_git_next_file)
    autocmd FileType dirvish nmap <silent><buffer><C-p> <Plug>(dirvish_git_prev_file)
augroup END
