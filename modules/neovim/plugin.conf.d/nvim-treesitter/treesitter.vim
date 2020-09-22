if !dotfiles#plugin#selected('nvim-treesitter') || exists('g:did_cfg_nvim_treesitter')
    finish
endif
let g:did_cfg_nvim_treesitter = 1

lua <<EOF
require("dotfiles/treesitter").setup()
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
