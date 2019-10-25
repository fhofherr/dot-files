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

if dotfiles#plugin#selected('dracula')
    let s:colorscheme = 'dracula'
elseif dotfiles#plugin#selected('vim-colors-solarized')
    let s:colorscheme = 'solarized_light'
else
    let s:colorscheme = 'powerline'
endif

let g:lightline = {
      \ 'colorscheme': s:colorscheme,
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              [ 'percent', 'lineinfo' ],
      \              [ 'charvaluehex', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B',
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
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

" Call lightline#enable() **after** we have configured it.
call lightline#enable()
