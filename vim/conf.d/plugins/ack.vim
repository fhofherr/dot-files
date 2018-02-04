" ---------------------------------------------------------------------------
"
" Ack
"
" ---------------------------------------------------------------------------
nmap \a <Esc>:Ack!
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
command! Todo Ack! 'TODO|FIXME|XXX'
