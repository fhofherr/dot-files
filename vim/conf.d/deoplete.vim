" ---------------------------------------------------------------------------
"
" Deoplete
"
" ---------------------------------------------------------------------------
" See  https://afnan.io/2018-04-12/my-neovim-development-setup/
let deoplete#enable_at_startup = 1

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
call deoplete#custom#source('ale', 'rank', 999)

call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" Auto-close preview window upon completion
" See https://github.com/Shougo/deoplete.nvim/issues/115
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
