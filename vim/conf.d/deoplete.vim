" ---------------------------------------------------------------------------
"
" Deoplete
"
" ---------------------------------------------------------------------------
" See  https://afnan.io/2018-04-12/my-neovim-development-setup/
let g:deoplete#enable_at_startup = 1
let b:deoplete_disable_auto_complete=1
let g:deoplete_disable_auto_complete=1
let g:deoplete#sources = {}
" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment', 'String'])

" set sources
let g:deoplete#sources = {}

let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#package_dot = 1

let g:deoplete#sources.python = ['LanguageClient']
let g:deoplete#sources.python3 = ['LanguageClient']
let g:deoplete#sources.vim = ['vim']
