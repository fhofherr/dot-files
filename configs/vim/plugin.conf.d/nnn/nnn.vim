if !dotfiles#plugin#selected('nnn.vim') || exists('g:did_cfg_vim_nnn')
    finish
endif
let g:did_cfg_vim_nnn = 1

" Floating window (neovim latest and vim with patch 8.2.191)
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

let g:nnn#action = {
            \ '<c-t>': 'tab split',
            \ '<c-x>': 'split',
            \ '<c-v>': 'vsplit'
            \ }
