setlocal formatoptions+=r spell spelllang=en_us

let s:spelldir = $VIMHOME . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/proto.en.utf-8.add'
setlocal foldnestmax=3
setlocal foldmethod=indent
setlocal cindent

" vim: sw=2 sts=2 et
