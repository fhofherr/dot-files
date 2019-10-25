if !dotfiles#plugin#selected('dracula') || exists('g:did_cfg_dracula')
    finish
endif
let g:did_cfg_dracula = 1

" The dracula colorscheme works best with a matching terminal color scheme.
" See: https://draculatheme.com/

set background=dark
colorscheme dracula
