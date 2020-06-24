if exists('b:dotfiles_did_python_ftplugin')
  finish
endif
let b:dotfiles_did_python_ftplugin = 1

setlocal spell spelllang=en_us

let s:spelldir = $VIMHOME . '/spell'
call mkdir(s:spelldir, 'p')

let &l:spellfile = s:spelldir . '/python.en.utf-8.add'


setlocal foldmethod=indent foldnestmax=3
