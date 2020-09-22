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

setlocal foldnestmax=3
setlocal foldmethod=indent

" vim: sw=2 sts=2 et
