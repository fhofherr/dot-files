" vim: set foldmethod=marker:

if empty($VIMPLUG_HOME)
    finish
end

call plug#begin($VIMPLUG_HOME)

Plug 'kassio/neoterm'
if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
endif

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

call plug#end()
