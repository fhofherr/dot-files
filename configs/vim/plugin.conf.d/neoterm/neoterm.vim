if !dotfiles#plugin#selected('neoterm') || exists('g:did_cfg_neoterm')
    finish
endif
let g:did_cfg_neoterm = 1

let g:neoterm_default_mod = ':tab'
let g:neoterm_autoinsert = 1

" split-term.vim compatibility
command Term :botright :Tnew
command STerm :botright :Tnew
command VTerm :vertical :Tnew
command TTerm :tab :Tnew

nnoremap <leader>st :STerm<CR>
nnoremap <leader>vt :VTerm<CR>
nnoremap <leader>tt :TTerm<CR>
