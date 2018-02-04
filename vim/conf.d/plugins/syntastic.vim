" ---------------------------------------------------------------------------
"
" Syntastic
"
" ---------------------------------------------------------------------------

" we want to tell the syntastic module when to run
" we want to see code highlighting and checks when  we open a file
" but we don't care so much that it reruns when we close the file
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_go_checkers = ['gometalinter']
" Disable all linters then enable the select few we are interested in.
let g:syntastic_go_gometalinter_args = "--no-config --disable-all --enable=vet --enable=golint"
