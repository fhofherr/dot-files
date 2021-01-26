setlocal formatoptions+=r spell spelllang=en_us

let s:spelldir = $VIMHOME . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/golang.en.utf-8.add'
setlocal foldnestmax=3
setlocal foldmethod=indent

" vim: sw=2 sts=2 et
