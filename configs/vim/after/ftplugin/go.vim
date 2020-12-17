if exists('b:dotfiles_did_go_ftplugin')
  finish
endif
let b:dotfiles_did_go_ftplugin = 1

let g:go_highlight_trailing_whitespace_error = 0

setlocal formatoptions+=r spell spelllang=en_us

let s:spelldir = $VIMHOME . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/golang.en.utf-8.add'

if dotfiles#plugin#selected('gopher.vim')
  " Unset the equalprg set by gopher.vim
  setlocal equalprg=
endif

" if dotfiles#plugin#selected('vim-lsp')
"   " setlocal foldmethod=expr
"   "       \ foldexpr=lsp#ui#vim#folding#foldexpr()
"   "       \ foldtext=lsp#ui#vim#folding#foldtext()
"   "       \ foldnestmax=3
"   setlocal foldmethod=indent foldnestmax=3
"   let b:asyncomplete_min_chars = 3
" else
"   setlocal foldmethod=indent foldnestmax=3
" endif

" vim: sw=2 sts=2 et
