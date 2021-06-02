if !dotfiles#plugin#selected('vimade') || exists('g:did_cfg_vimade')
    finish
endif
let g:did_cfg_vimade = 1

let g:vimade_running = 0
let g:vimade = {
            \ "fadelevel": 0.6,
            \ "enablefocusfading": 1,
            \ "enabletreesitter": 1,
            \}

" See: https://github.com/TaDaa/vimade/issues/38
"
" We use g:vimade_running instead of relying on vimplug to lazy load the
" plugin.
augroup dotfiles_vimade
    autocmd WinNew,BufNew * ++once if g:vimade_running != 1 |
                \execute 'VimadeEnable' | endif
    autocmd FocusLost * ++once if g:vimade_running != 1 |
                \execute 'VimadeEnable' |
                \call vimade#FocusLost() | endif
augroup end
