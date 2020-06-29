" ---------------------------------------------------------------------------
"
" Directory management mappings
"
" ---------------------------------------------------------------------------

command Cd cd %:p:h
command Lcd lcd %:p:h

nnoremap <silent> <leader>d :10Lexplore<CR>
nnoremap <silent> <leader>D :10Lexplore %:p:h<CR>
