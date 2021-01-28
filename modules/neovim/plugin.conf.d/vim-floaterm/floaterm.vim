if !dotfiles#plugin#selected('vim-floaterm') || exists('g:did_cfg_floaterm')
    finish
endif
let g:did_cfg_floaterm = 1

let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_autoclose = 1

if executable('nnn')
    command! -nargs=? -complete=dir NNN FloatermNew nnn <args>
    noremap <leader>d :NNN<CR>
    noremap <leader>D :NNN %:p:h<CR>
endif

if executable('lazygit')
    command! Lg FloatermNew lazygit
endif
