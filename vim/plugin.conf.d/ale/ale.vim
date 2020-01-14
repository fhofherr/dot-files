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
let g:ale_pattern_options = {
            \   '\.git/index$': {
            \     'ale_enabled': 0
            \   },
            \   '\.go': {
            \     'ale_fix_on_save': 1
            \   },
            \   '\.py': {
            \     'ale_enabled': 1,
            \     'ale_fix_on_save': 1
            \   }
            \ }

let g:ale_linters = {
            \   'go': [ 'golangci-lint', 'golint' ],
            \   'python': [ 'flake8' ]
            \ }

let g:ale_fixers = {
            \   'go': [ 'goimports' ],
            \   'python': [ 'yapf' ]
            \ }

" ---------------------------------------------------------------------------
"
" Ansible specific settings
"
" ---------------------------------------------------------------------------
let g:ale_ansible_ansible_lint_executable = g:python3_bin_dir.'/ansible-lint'

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
let g:ale_gitcommit_gitlint_executable = g:python3_bin_dir.'/gitlint'
let g:ale_gitcommit_gitlint_use_global = 1

" ---------------------------------------------------------------------------
"
" Go specific settings
"
" ---------------------------------------------------------------------------

let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = ''

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
let g:ale_yaml_yamllint_executable = g:python3_bin_dir.'/yamllint'
let g:ale_yaml_yamllint_use_global = 1
