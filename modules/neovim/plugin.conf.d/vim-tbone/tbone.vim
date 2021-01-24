if !dotfiles#plugin#selected('vim-tbone') || exists('g:did_cfg_tbone')
    finish
endif
let g:did_cfg_tbone = 1

if executable('nnn')
    command Nnn :Tmux new-window nnn -eER
endif

if executable('lazygit')
    command Lg :Tmux new-window lazygit
endif
