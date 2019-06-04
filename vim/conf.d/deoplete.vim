" ---------------------------------------------------------------------------
"
" Deoplete
"
" ---------------------------------------------------------------------------
if $DOTFILES_MINIMAL == 'false'
    " See  https://afnan.io/2018-04-12/my-neovim-development-setup/
    let deoplete#enable_at_startup = 1

    " Disable the candidates in Comment/String syntaxes.
    call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
    call deoplete#custom#source('ale', 'rank', 999)

    call deoplete#custom#source('go', 'gocode_binary', $GOPATH.'/bin/gocode')
    call deoplete#custom#source('go', 'sort_class', ['package', 'func', 'type', 'var', 'const'])
    call deoplete#custom#source('go', 'package_dot', 1)

    " Auto-close preview window upon completion
    " See https://github.com/Shougo/deoplete.nvim/issues/115
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " deoplete tab-complete
    " See https://www.gregjs.com/vim/2016/configuring-the-deoplete-asynchronous-keyword-completion-plugin-with-tern-for-vim/
    inoremap <expr><s-tab> pumvisible() ? "\<c-j>" : "\<s-tab>"
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
endif
