if !dotfiles#plugin#selected('completion-nvim') || !dotfiles#plugin#selected('nvim-lspconfig') || exists('g:did_cfg_completion_nvim')
    finish
endif
let g:did_cfg_completion_nvim = 1

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
