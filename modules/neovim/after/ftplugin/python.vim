setlocal spell spelllang=en_us

let s:spelldir = $VIMHOME . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/python.en.utf-8.add'
setlocal foldmethod=indent foldnestmax=3
