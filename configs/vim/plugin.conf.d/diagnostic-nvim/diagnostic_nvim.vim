if !dotfiles#plugin#selected('diagnostic-nvim') || exists('g:did_cfg_diagnostic_nvim')
    finish
endif

let g:did_cfg_diagnostic_nvim = 1

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_insert_delay = 1
