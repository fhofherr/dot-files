" ---------------------------------------------------------------------------
"
" Buffer management mappings
"
" ---------------------------------------------------------------------------

" Additional mappings are defined in plugin.conf.d/fzf/fzf.vim
nnoremap <silent> <right> :call dotfiles#buffer#next()<cr>
nnoremap <silent> <left> :call dotfiles#buffer#prev()<cr>
nnoremap <silent> Q :bdelete<cr>
