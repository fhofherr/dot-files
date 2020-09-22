if !dotfiles#plugin#selected('nvim-lspconfig') || exists('g:did_cfg_nvim_lsp')
    finish
endif
let g:did_cfg_nvim_lsp = 1

lua <<EOF
require("dotfiles/lsp").setup()
EOF
