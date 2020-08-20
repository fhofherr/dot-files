if !dotfiles#plugin#selected('completion-nvim') || !dotfiles#plugin#selected('nvim-lsp') || exists('g:did_cfg_completion_nvim')
    finish
endif
let g:did_cfg_completion_nvim = 1

let g:completion_auto_change_source = 1
let g:completion_enable_auto_popup = 0
let g:completion_timer_cycle = 100
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'fuzzy']
let g:completion_chain_complete_list = {
            \   'default': {
            \       'comment': [],
            \       'default': [
            \           {'complete_items': ['snippet']},
            \           {'mode': '<c-p>'},
            \           {'mode': '<c-n>'}
            \       ]
            \   },
            \   'go': {
            \       'default': [
            \           {'complete_items': ['lsp']},
            \           {'mode': '<c-p>'},
            \           {'mode': '<c-n>'}
            \       ]
            \   },
            \   'python': {
            \       'default': [
            \           {'complete_items': ['lsp', 'ts']},
            \           {'mode': '<c-p>'},
            \           {'mode': '<c-n>'}
            \       ]
            \   },
            \   'lua': {
            \       'default': [
            \           {'complete_items': ['ts']},
            \           {'mode': '<c-p>'},
            \           {'mode': '<c-n>'}
            \      ]
            \   }
            \}

function s:attach()
    inoremap <silent><buffer><expr> <C-n> pumvisible() ? "\<C-n>" : completion#trigger_completion()
    inoremap <silent><buffer><expr> <C-p> pumvisible() ? "\<C-p>" : completion#trigger_completion()
endfunction

augroup dotfiles_completion_nvim
    autocmd!
    autocmd BufEnter,BufNewFile * call <SID>attach()
augroup END
