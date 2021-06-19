setlocal formatoptions+=r spell spelllang=en_us

let s:spelldir = stdpath('config') . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/golang.en.utf-8.add'
