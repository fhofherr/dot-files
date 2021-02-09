if !dotfiles#plugin#selected('vim-tbone') || exists('g:did_cfg_tbone')
    finish
endif
let g:did_cfg_tbone = 1

if executable('lazygit')
    command! Lg :Tmux new-window lazygit
end
