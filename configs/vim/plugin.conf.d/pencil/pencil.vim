" ---------------------------------------------------------------------------
"
" Vim Pencil
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('vim-pencil') || !dotfiles#plugin#selected('vim-wordy') || !dotfiles#plugin#selected('vim-lexical') || exists('g:did_cfg_pencil')
    finish
endif
let g:did_cfg_pencil = 1

let g:pencil#textwidth = 72
let g:pencil#conceallevel = 0

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init({'wrap': 'hard', 'autoformat': 0})
                        \ | call lexical#init({
                        \       'spell': 1,
                        \       'spelllang': ['en_us']
                        \   })
  autocmd FileType asciidoc call pencil#init({'wrap': 'soft'})
  autocmd FileType text call pencil#init({'wrap': 'hard', 'autoformat': 0})
  autocmd FileType mail call pencil#init({'wrap': 'hard', 'textwidth': 72})
                        \ | call lexical#init({
                        \       'spell': 1,
                        \       'spelllang': ['de']
                        \   })
augroup END
