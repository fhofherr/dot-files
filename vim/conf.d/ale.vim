" ---------------------------------------------------------------------------
"
" ALE
"
" ---------------------------------------------------------------------------

let g:ale_linters = {
            \   'go': [ 'golangci-lint', 'golint', 'gopls' ],
            \   'python': ['flake8']
            \ }

let g:ale_fixers = {
            \   'go': [ 'goimports' ],
            \   'python': ['yapf']
            \}

" Disable ALE completion, we use deoplete for that
" See: https://github.com/dense-analysis/ale#2iii-completion
let g:ale_completion_enabled = 0
let g:ale_sign_column_always = 1

" Don't lint on text changes ...
let g:ale_lint_on_text_changed = 0
" ... lint when leaving insert mode instead
let g:ale_lint_on_insert_leave = 1

let g:ale_pattern_options = {'\.git/index$': {'ale_enabled': 0}}

let g:ale_yaml_yamllint_executable = g:python3_bin_dir.'/yamllint'
let g:ale_yaml_yamllint_use_global = 1

let g:ale_gitcommit_gitlint_executable = g:python3_bin_dir.'/gitlint'
let g:ale_gitcommit_gitlint_use_global = 1

let g:ale_python_flake8_executable = g:python3_bin_dir.'/flake8'
let g:ale_python_flake8_use_global = 1

let g:ale_python_yapf_executable = g:python3_bin_dir.'/yapf'
let g:ale_python_yapf_use_global = 1

let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 1

let g:ale_go_golangci_lint_package = 1

augroup ale
    autocmd!
    au FileType python,go let b:ale_fix_on_save = 1
augroup END
