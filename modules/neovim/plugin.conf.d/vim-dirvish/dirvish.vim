if !dotfiles#plugin#selected('vim-dirvish') || exists('g:did_cfg_vim_dirvish')
    finish
endif
let g:did_cfg_vim_dirvish = 1

" Disable netrw
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore belowright vsplit | silent Dirvish <args>

" Use <leader>e instead of - do open dirvish. I always fat-finger - while in
" normal mode.
nmap <leader>e <Plug>(dirvish_up)

nmap <silent> <leader>E :Dirvish %<CR>

augroup dotfiles_dirvish_config
    autocmd!

    " Restore the default behavior of - inside the dirvish buffer
    autocmd FileType dirvish
                \ nmap <buffer> - <Plug>(dirvish_up)

    " Map `t` to open in new tab.
    autocmd FileType dirvish
                \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
                \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

    " Map `gr` to reload.
    autocmd FileType dirvish nnoremap <silent><buffer>
                \ gr :<C-U>Dirvish %<CR>

    " Map `gh` to hide dot-prefixed files.  Press `R` to "toggle" (reload).
    autocmd FileType dirvish nnoremap <silent><buffer>
                \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=3<cr>
augroup END
