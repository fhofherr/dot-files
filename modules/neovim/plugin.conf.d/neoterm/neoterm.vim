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
command Term :botright :Topen
command STerm :belowright :Topen
command VTerm :vertical :Topen
command TTerm :tab :Topen
