if !dotfiles#plugin#selected('neoterm') || exists('g:did_cfg_neoterm')
    finish
endif
let g:did_cfg_neoterm = 1

let g:neoterm_default_mod = ':tab'

" split-term.vim compatibility
command Term :Tnew
command VTerm :vertical :Tnew
command TTerm :tab :Tnew
