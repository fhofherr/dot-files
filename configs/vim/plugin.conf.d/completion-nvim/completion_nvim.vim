if !dotfiles#plugin#selected('completion-nvim') || !dotfiles#plugin#selected('nvim-lspconfig') || exists('g:did_cfg_completion_nvim')
    finish
endif
let g:did_cfg_completion_nvim = 1

" Disable the default completion confirm key. We set it in s:attach below.
let g:completion_confirm_key = ''
let g:completion_auto_change_source = 1
let g:completion_enable_auto_popup = 0
let g:completion_timer_cycle = 100
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'fuzzy']

let g:completion_chain_complete_list = {
            \   'default': {
            \       'comment': [],
            \       'default': [
            \           {'complete_items': ['snippet', 'path']},
            \           {'mode': '<c-p>'},
            \           {'mode': '<c-n>'}
            \       ]
            \   },
            \   'go': {
            \       'default': [
            \           {'complete_items': ['lsp', 'ts']},
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

function s:confirm_completion(key)
    if !pumvisible()
        return a:key
    end
    if complete_info()['selected'] == '-1'
        return "\<C-e>" . a:key
    end
    return "\<Plug>(completion_confirm_completion)"
endfunction

function s:attach()
    inoremap <silent><buffer><expr> <C-n> pumvisible() ? "\<C-n>" : completion#trigger_completion()
    inoremap <silent><buffer><expr> <C-p> pumvisible() ? "\<C-p>" : completion#trigger_completion()

    " Use <CR> as well as <Space> to confirm the completion.
    imap <silent><buffer><expr> <CR> <SID>confirm_completion("\<CR>")
    imap <silent><buffer><expr> <Space> <SID>confirm_completion("\<Space>")
endfunction

augroup dotfiles_completion_nvim
    autocmd!
    autocmd BufEnter,BufNewFile * call <SID>attach()
augroup END
