" ---------------------------------------------------------------------------
"
" ALE common options
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('ale') || exists('g:did_cfg_ale')
    finish
endif
let g:did_cfg_ale = 1

let g:ale_disable_lsp = 1

" Disable ALE completion
let g:ale_completion_enabled = 0

let g:ale_sign_column_always = 1

" Don't lint on text changes ...
let g:ale_lint_on_text_changed = 0
" ... lint when leaving insert mode instead
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
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
            \   'c': [ 'ccls', 'clangtidy' ],
            \   'cpp': [ 'ccls', 'clangtidy' ],
            \   'go': [ 'gobuild', 'golangci-lint', 'revive' ],
            \   'python': [ 'flake8', 'mypy' ]
            \ }

" Make sure that only black or yapf are installed in the virtual environment.
" Otherwise they will get into a fight.
let g:ale_fixers = {
            \   'c': [ 'clang-format', 'clangtidy' ],
            \   'cpp': [ 'clang-format', 'clangtidy' ],
            \   'sh': [ 'shfmt' ],
            \   'go': [ 'goimports' ],
            \   'python': [ 'black', 'isort', 'yapf' ]
            \ }

if executable('buf')
    let g:ale_linters['proto'] = ['buf-check-lint']
endif

nmap [W <Plug>(ale_first)
nmap [w <Plug>(ale_previous)
nmap ]w <Plug>(ale_next)
nmap ]W <Plug>(ale_last)

function! s:ale_fix_manual() abort
    if get(g:, 'ale_fix_on_save', 0) || get(b:, 'ale_fix_on_save', 0)
        return
    endif
    lockmarks ALEFix
endfunction

function! s:ale_update_after_manual_fix() abort
    if get(g:, 'ale_fix_on_save', 0) || get(b:, 'ale_fix_on_save', 0)
        return
    endif
    update
    ALELint
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
" YAML specific settings
"
" ---------------------------------------------------------------------------
let g:ale_yaml_yamllint_use_global = 1
