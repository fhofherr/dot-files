if !dotfiles#plugin#selected('neoterm') || exists('g:did_cfg_neoterm')
    finish
endif
let g:did_cfg_neoterm = 1
let g:neoterm_autoinsert = 0
let g:neoterm_autojump = 1

let g:neoterm_callbacks = {}
function! g:neoterm_callbacks.before_new()
    if winwidth('.') > 100
        let g:neoterm_default_mod = 'botright vertical'
    else
        let g:neoterm_default_mod = 'botright'
    end
endfunction

" split-term.vim compatibility
command Term :botright :Tnew
command STerm :belowright :Tnew
command VTerm :vertical :Tnew
command TTerm :tab :Tnew

" Disable those mappings. I don't use them that much and they have an
" inconsistent prefix. This way I can create consistent \t* mappings for
" vim-test (which I use a lot).
"
" nnoremap <leader>nt :Tnew<CR>
" nnoremap <leader>st :STerm<CR>
" nnoremap <leader>vt :VTerm<CR>
" nnoremap <leader>tt :TTerm<CR>
