" ---------------------------------------------------------------------------
"
" ALE common options
"
" ---------------------------------------------------------------------------
if !has_key(g:plugs, 'ale')
    finish
endif

" Disable ALE completion, we use deoplete for that
" See: https://github.com/dense-analysis/ale#2iii-completion
let g:ale_completion_enabled = 0
let g:ale_sign_column_always = 1

" Don't lint on text changes ...
let g:ale_lint_on_text_changed = 0
" ... lint when leaving insert mode instead
let g:ale_lint_on_insert_leave = 1
let g:ale_pattern_options = {
            \   '\.git/index$': {
            \     'ale_enabled': 0
            \   },
            \   'go': {
            \     'ale_fix_on_save': 1
            \   }
            \ }

let g:ale_linters = {
            \   'go': [ 'golangci-lint', 'golint', 'gopls' ]
            \ }

let g:ale_fixers = {
            \   'go': [ 'goimports' ]
            \ }

nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gD <Plug>(ale_go_to_definition_in_tab)
nmap <silent> gy <Plug>(ale_go_to_type_definition)
nmap <silent> gY <Plug>(ale_go_to_type_definition_in_tab)

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
function! s:set_ale_python_config(argstr)
    let b:ale_fix_on_save = 1
    let b:ale_linters = ['flake8', 'pyls']
    let b:ale_fixers = ['yapf']

    if !exists("$DOTFILES_USE_DOTFILES_PYTHON")
        return
    endif
    if !exists("$DOTFILES_PYTHON_BIN")
        return
    endif
    let py_pybin = $DOTFILES_GLOBAL_PYTHON_BIN
    if executable(py_pybin . '/flake8')
        let b:ale_python_flake8_executable = py_pybin . '/flake8'
        let b:ale_python_flake8_use_global = 1
    endif
    if executable(py_pybin . '/yapf')
        let b:ale_python_yapf_executable = py_pybin . '/yapf'
        let b:ale_python_yapf_use_global = 1
    endif
    if executable(py_pybin . '/pyls')
        let b:ale_python_pyls_executable = py_pybin . '/pyls'
        let b:ale_python_pyls_use_global = 1
    endif
endfunction

augroup fh_ale_python
    autocmd!
    au FileType python call s:set_ale_python_config()
augroup END

" ---------------------------------------------------------------------------
"
" YAML specific settings
"
" ---------------------------------------------------------------------------
let g:ale_yaml_yamllint_executable = g:python3_bin_dir.'/yamllint'
let g:ale_yaml_yamllint_use_global = 1
