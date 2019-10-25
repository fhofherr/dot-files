" ---------------------------------------------------------------------------
"
" Ack
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('ack.vim') || exists('g:did_cfg_ack_vim')
    finish
endif
let g:did_cfg_ack_vim = 1

nmap \a <Esc>:Ack!
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
command! Todo Ack! 'TODO|FIXME|XXX'
