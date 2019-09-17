" ---------------------------------------------------------------------------
"
" fzf.vim
"
" ---------------------------------------------------------------------------
if !has_key(g:plugs, 'fzf') || !has_key(g:plugs, 'fzf.vim')
    finish
endif

" Default fzf layout
if has('nvim')
    let g:fzf_layout = { 'window': '10split enew' }
else
    let g:fzf_layout = { 'down': '~40%' }
endif

nmap <F1> :Helptags<CR>
nmap <c-p> :Files<cr>

" Customize fzf colors to match your color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
