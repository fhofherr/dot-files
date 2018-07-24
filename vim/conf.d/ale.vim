" ---------------------------------------------------------------------------
"
" ALE
"
" ---------------------------------------------------------------------------

" Disable ALE completion, we use deoplete for that
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
