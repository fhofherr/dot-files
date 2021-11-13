setlocal formatoptions+=r spelllang=en_us " spell

let s:spelldir = stdpath('config') . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/proto.en.utf-8.add'
setlocal foldmethod=indent
setlocal cindent
