" ---------------------------------------------------------------------------
"
" ALE common options
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('ale') || exists('g:did_cfg_ale')
    finish
endif
let g:did_cfg_ale = 1

" Disable ALE completion, we use deoplete for that
" See: https://github.com/dense-analysis/ale#2iii-completion
let g:ale_completion_enabled = 0
let g:ale_sign_column_always = 1

let g:ale_disable_lsp = 1

" Don't lint on text changes ...
let g:ale_lint_on_text_changed = 0
" ... lint when leaving insert mode instead
let g:ale_lint_on_insert_leave = 1
" ... and when saving the file
let g:ale_lint_on_save = 1

let g:ale_pattern_options = {
            \   '\.git/index$': {
            \     'ale_enabled': 0
            \   },
            \   '\.go': {
            \     'ale_enabled': 1,
            \   },
            \   '\.py': {
            \     'ale_enabled': 1,
            \   }
            \ }

let g:ale_linters = {
            \   'go': [ 'golangci-lint' ],
            \   'python': [ 'flake8' ]
            \ }

if executable('buf')
    let g:ale_linters['proto'] = ['buf-check-lint']
endif

let g:ale_fixers = {
            \   'go': [ 'goimports' ],
            \   'python': [ 'yapf' ]
            \ }

nmap [W <Plug>(ale_first)
nmap [w <Plug>(ale_previous)
nmap ]w <Plug>(ale_next)
nmap ]W <Plug>(ale_last)

function! s:ale_fix_manual() abort
    if get(g:, 'ale_fix_on_save', 0) || get(b:, 'ale_fix_on_save', 0)
        return
    endif
    ALEFix
endfunction

function! s:ale_update_after_manual_fix() abort
    if get(g:, 'ale_fix_on_save', 0) || get(b:, 'ale_fix_on_save', 0)
        return
    endif
    update
endfunction

nmap <silent> <F9> :call <SID>ale_fix_manual()<CR>

augroup dotfiles_ale
    autocmd!
    autocmd User ALEFixPost call <SID>ale_update_after_manual_fix()
augroup END

" ---------------------------------------------------------------------------
"
" C specific settings
"
" ---------------------------------------------------------------------------
let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 1

" ---------------------------------------------------------------------------
"
" Git specific settings
"
" ---------------------------------------------------------------------------
let g:ale_gitcommit_gitlint_use_global = 1

" ---------------------------------------------------------------------------
"
" Go specific settings
"
" ---------------------------------------------------------------------------

let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = '--fast'

" ---------------------------------------------------------------------------
"
" Python specific settings
"
" ---------------------------------------------------------------------------
let g:ale_python_flake8_use_global = 1
let g:ale_python_yapf_use_global = 1

" ---------------------------------------------------------------------------
"
" YAML specific settings
"
" ---------------------------------------------------------------------------
let g:ale_yaml_yamllint_use_global = 1
