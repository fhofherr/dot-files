" ---------------------------------------------------------------------------
"
" ALE
"
" ---------------------------------------------------------------------------

" Disable ALE completion, we use deoplete for that
let g:ale_completion_enabled = 0
let g:ale_sign_column_always = 1

let g:ale_pattern_options = {'\.git/index$': {'ale_enabled': 0}}
