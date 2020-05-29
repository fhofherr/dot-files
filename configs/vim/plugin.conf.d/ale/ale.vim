" ---------------------------------------------------------------------------
"
" ALE common options
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('ale') || exists('g:did_cfg_ale')
    finish
endif
let g:did_cfg_ale = 1

" Disable ALE completion, we use deoplete for that
" See: https://github.com/dense-analysis/ale#2iii-completion
if dotfiles#plugin#selected('deoplete')
            \ || dotfiles#plugin#selected('asyncomplete.vim')
            \ || dotfiles#plugin#selected('asyncomplete-lsp.vim')
    let g:ale_completion_enabled = 0
endif

let g:ale_sign_column_always = 1

" Don't lint on text changes ...
let g:ale_lint_on_text_changed = 0
" ... lint when leaving insert mode instead
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
" ... and when saving the file
let g:ale_lint_on_save = 1

let g:ale_pattern_options = {
            \   '\.git/index$': {
            \     'ale_enabled': 0
            \   },
            \   '\.go': {
            \     'ale_enabled': 1,
            \   },
            \   '\.py': {
            \     'ale_enabled': 1,
            \   }
            \ }

let g:ale_linters = {
            \   'go': [ 'gobuild', 'golangci-lint' ],
            \   'python': [ 'flake8' ]
            \ }

let g:ale_fixers = {
            \   'go': [ 'goimports' ],
            \   'python': [ 'yapf' ]
            \ }

if dotfiles#plugin#selected('lcn') || dotfiles#plugin#selected('nvim-lsp') || dotfiles#plugin#selected('vim-lsp')
    let g:ale_disable_lsp = 1
else
    let g:ale_linters.go = g:ale_linters.go + [ 'gopls' ]
    let g:ale_linters.python = g:ale_linters.python + [ 'pyls' ]
endif

if executable('buf')
    let g:ale_linters['proto'] = ['buf-check-lint']
endif

nmap [W <Plug>(ale_first)
nmap [w <Plug>(ale_previous)
nmap ]w <Plug>(ale_next)
nmap ]W <Plug>(ale_last)

function! s:ale_fix_manual() abort
    if get(g:, 'ale_fix_on_save', 0) || get(b:, 'ale_fix_on_save', 0)
        return
    endif
    ALEFix
endfunction

function! s:ale_update_after_manual_fix() abort
    if get(g:, 'ale_fix_on_save', 0) || get(b:, 'ale_fix_on_save', 0)
        return
    endif
    update
    ALELint
endfunction

function! s:ale_lsp_buffer_settings() abort
    if get(g:, 'ale_disable_lsp', 0)
        return
    endif
    " setlocal omnifunc=ale#completion#OmniFunc

    nnoremap <buffer> <silent> K :ALEHover<CR>
    nnoremap <buffer> <silent> gd :ALEGoToDefinition<CR>
    nnoremap <buffer> <silent> 1gD :ALEGoToTypeDefinition<CR>
    nnoremap <buffer> <silent> gr :ALEFindReferences<CR>
    nnoremap <buffer> <silent> <F2> :ALERename<CR>
endfunction

nmap <silent> <F9> :call <SID>ale_fix_manual()<CR>

augroup dotfiles_ale
    autocmd!
    autocmd User ALEFixPost call <SID>ale_update_after_manual_fix()
    autocmd FileType go,python call <SID>ale_lsp_buffer_settings()
augroup END

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
let g:ale_gitcommit_gitlint_use_global = 1

" ---------------------------------------------------------------------------
"
" Go specific settings
"
" ---------------------------------------------------------------------------

let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = '--fast'

" ---------------------------------------------------------------------------
"
" Python specific settings
"
" ---------------------------------------------------------------------------
let g:ale_python_flake8_use_global = 1
let g:ale_python_pyls_use_global = 1
let g:ale_python_yapf_use_global = 1

" ---------------------------------------------------------------------------
"
" YAML specific settings
"
" ---------------------------------------------------------------------------
let g:ale_yaml_yamllint_use_global = 1
