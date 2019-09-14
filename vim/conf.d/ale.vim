" ---------------------------------------------------------------------------
"
" ALE common options
"
" ---------------------------------------------------------------------------
let g:ale_linters = {
            \   'python': ['flake8', 'pyls']
            \ }

let g:ale_fixers = {
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
" Go specific settings
"
" ---------------------------------------------------------------------------
function! s:do_go(argstr)
    if exists("g:ale_go_go_executable")
        let go_executable=g:ale_go_go_executable
    else
        let go_executable='go'
    endif
    return system(go_executable . ' ' . a:argstr)
endfunction

function! s:set_ale_go_config()
    let gopath = s:do_go('env GOPATH')
    if gopath == ''
        let gopath = $HOME . '/go'
    endif
    let gopath = trim(gopath)
    let gobin = gopath . '/bin'

    let b:ale_fix_on_save = 1
    let b:ale_linters = []
    let b:ale_fixers = []

    " Configure linters
    if executable(gobin . '/golangci-lint')
        let b:ale_go_golangci_lint_executable = gobin . '/golangci-lint'
        let b:ale_go_golangci_lint_package = 1
        let b:ale_linters = b:ale_linters + ['golangci-lint']
    endif
    if executable(gobin . '/golint')
        let b:ale_go_golint_executable = gobin . '/golint'
        let b:ale_linters = b:ale_linters + ['golint']
    endif
    if executable(gobin . '/gopls')
        let b:ale_go_gopls_executable = gobin . '/gopls'
        let b:ale_linters = b:ale_linters + ['gopls']
    endif

    " Configure fixers
    if executable(gobin . '/goimports')
        let b:ale_go_goimports_executable = gobin . '/goimports'
        let b:ale_fixers = b:ale_fixers + ['goimports']
    endif
endfunction

augroup fh_ale_go
    autocmd!
    au FileType go call s:set_ale_go_config()
augroup END

" ---------------------------------------------------------------------------
"
" Git specific settings
"
" ---------------------------------------------------------------------------
let g:ale_gitcommit_gitlint_executable = g:python3_bin_dir.'/gitlint'
let g:ale_gitcommit_gitlint_use_global = 1

" ---------------------------------------------------------------------------
"
" Python specific settings
"
" ---------------------------------------------------------------------------
let g:ale_python_flake8_executable = g:python3_bin_dir.'/flake8'
let g:ale_python_flake8_use_global = 1

let g:ale_python_pyls_executable = g:python3_bin_dir.'/pyls'
let g:ale_python_pyls_use_global = 1
let g:ale_python_yapf_executable = g:python3_bin_dir.'/yapf'
let g:ale_python_yapf_use_global = 1

augroup fh_ale_python
    autocmd!
    au FileType python let b:ale_fix_on_save = 1
augroup END

" ---------------------------------------------------------------------------
"
" YAML specific settings
"
" ---------------------------------------------------------------------------
let g:ale_yaml_yamllint_executable = g:python3_bin_dir.'/yamllint'
let g:ale_yaml_yamllint_use_global = 1
