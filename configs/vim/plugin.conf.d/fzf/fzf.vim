" ---------------------------------------------------------------------------
"
" fzf.vim
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('fzf') || !dotfiles#plugin#selected('fzf.vim') || exists('g:did_cfg_fzf')
    finish
endif
let g:did_cfg_fzf = 1

" Default fzf layout
if has('nvim')
    let g:fzf_layout = { 'window': '10split enew' }
else
    let g:fzf_layout = { 'down': '~40%' }
endif

augroup fzf
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup end

nmap <F1> :Helptags<CR>
nnoremap <c-g><c-f> :Files<cr>
nnoremap <c-g><c-b> :Buffers<cr>
nnoremap <c-g><c-t> :Tags<cr>
nnoremap <c-g><c-m> :Marks<cr>

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
