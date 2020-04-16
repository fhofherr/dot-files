if !dotfiles#plugin#selected('nvim-lsp') || exists('g:did_cfg_nvim_lsp')
    finish
endif
let g:did_cfg_nvim_lsp = 1

" Gopls
lua <<EOF
require'nvim_lsp'.gopls.setup{}
EOF
