" ---------------------------------------------------------------------------
"
" Ack
"
" ---------------------------------------------------------------------------
if !has_key(g:plugs, 'ack.vim')
    finish
endif

nmap \a <Esc>:Ack!
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
command! Todo Ack! 'TODO|FIXME|XXX'
