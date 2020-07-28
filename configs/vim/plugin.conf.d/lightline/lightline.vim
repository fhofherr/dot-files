" ---------------------------------------------------------------------------
"
" lightline
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('lightline.vim') || exists('g:did_cfg_lightline')
    finish
endif
let g:did_cfg_lightline = 1

" lightline shows the mode for us
set noshowmode

if dotfiles#plugin#selected('ayu-vim')
    let s:colorscheme = 'ayu'
elseif dotfiles#plugin#selected('challenger-deep')
    let s:colorscheme = 'challenger_deep'
elseif dotfiles#plugin#selected('dracula')
    let s:colorscheme = 'dracula'
elseif dotfiles#plugin#selected('falcon')
    let s:colorscheme = 'falcon'
elseif dotfiles#plugin#selected('gruvbox')
    let s:colorscheme = 'gruvbox'
elseif dotfiles#plugin#selected('iceberg.vim')
    let s:colorscheme = 'iceberg'
elseif dotfiles#plugin#selected('palenight.vim')
    let s:colorscheme = 'palenight'
elseif dotfiles#plugin#selected('onehalf')
    let s:colorscheme = 'onehalfdark'
else
    let s:colorscheme = 'powerline'
endif

let g:lightline = {
      \ 'colorscheme': s:colorscheme,
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'gutentags', 'lsp' ],
      \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'percent', 'lineinfo' ],
      \              [ 'charvaluehex', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B',
      \ },
      \ 'component_function': {
      \   'gutentags': 'dotfiles#lightline#gutentags_status',
      \   'gitbranch': 'dotfiles#lightline#gitbranch',
      \   'lsp': 'dotfiles#lightline#lsp_status'
      \ },
      \ 'component_expand': {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ },
      \ 'component_type':{
      \   'linter_checking': 'left',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'left',
      \}}


if dotfiles#plugin#selected('vim-gutentags')
    augroup dotfiles_lightline_gutentags
        autocmd!
        autocmd User GutentagsUpdating call lightline#update()
        autocmd User GutentagsUpdated call lightline#update()
    augroup END
endif

if dotfiles#plugin#selected('lightline-bufferline')
    let g:lightline#bufferline#show_number  = 1
    let g:lightline#bufferline#shorten_path = 0
    let g:lightline#bufferline#unnamed      = '[No Name]'

    let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
    let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
    let g:lightline.component_type   = {'buffers': 'tabsel'}

    set showtabline=2 " always show tabline

    augroup dotfiles_lightline_bufferline
        autocmd!
        autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
        autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
    augroup END
endif



" Call lightline#enable() **after** we have configured it.
call lightline#enable()
