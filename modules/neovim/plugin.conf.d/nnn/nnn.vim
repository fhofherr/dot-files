if !dotfiles#plugin#selected('nnn.vim') || exists('g:did_cfg_nnn')
    finish
endif
let g:did_cfg_nnn = 1

let g:nnn#set_default_mappings = 0
let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit',
      \}

if has('nvim')
    let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.9} }
end

noremap <leader>d :NnnPicker<CR>
noremap <leader>D :NnnPicker %:p:h<CR>
