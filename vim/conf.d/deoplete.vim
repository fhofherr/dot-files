" ---------------------------------------------------------------------------
"
" Deoplete
"
" ---------------------------------------------------------------------------
if $DOTFILES_MINIMAL == 'false'
    " See  https://afnan.io/2018-04-12/my-neovim-development-setup/
    call deoplete#enable()

    " Disable the candidates in Comment/String syntaxes.
    call deoplete#custom#source('_',
                \ 'disabled_syntaxes', ['Comment', 'String'])

    " set sources
    let g:deoplete#sources = {}

    let g:deoplete#sources#clojure = ['LanguageClient']

    let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
    let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
    let g:deoplete#sources#go#package_dot = 1

    let g:deoplete#sources#python = ['LanguageClient']
    let g:deoplete#sources#python3 = ['LanguageClient']

    let g:deoplete#sources#vim = ['vim']

    " Auto-close preview window upon completion
    " See https://github.com/Shougo/deoplete.nvim/issues/115
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " deoplete tab-complete
    " See https://www.gregjs.com/vim/2016/configuring-the-deoplete-asynchronous-keyword-completion-plugin-with-tern-for-vim/
    inoremap <expr><s-tab> pumvisible() ? "\<c-j>" : "\<s-tab>"
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
endif
