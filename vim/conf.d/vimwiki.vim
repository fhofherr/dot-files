" ---------------------------------------------------------------------------
"
" vimwiki
"
" ---------------------------------------------------------------------------

let g:vimwiki_list = [{'path': '~/Dropbox/wiki', 'syntax': 'markdown', 'ext': '.md'}]

augroup custom_vimwiki
    autocmd!
    autocmd FileType vimwiki set syntax=markdown
augroup END
