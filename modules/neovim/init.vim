" ---------------------------------------------------------------------------
" Set vimhome
" ---------------------------------------------------------------------------
if empty($VIMHOME)
    if has('win32') || has('win64')
        let $VIMHOME = $VIM."/vimfiles"
    elseif has('nvim') && exists("$XDG_CONFIG_HOME")
        let $VIMHOME = $XDG_CONFIG_HOME . '/nvim'
    elseif has('nvim') && !exists("$XDG_CONFIG_HOME")
        let $VIMHOME = $HOME . '/.config/nvim'
    else
        let $VIMHOME = $HOME . "/.vim"
    endif
endif

" ---------------------------------------------------------------------------
" Configure Providers for nvim
" ---------------------------------------------------------------------------

if has('nvim') && !empty($DOTFILES_NEOVIM_PYTHON3)
    let g:python3_host_prog=$DOTFILES_NEOVIM_PYTHON3
    let g:python3_bin_dir=fnamemodify(g:python3_host_prog, ':h')
endif

" ---------------------------------------------------------------------------
" Load vimplug configuration
" ---------------------------------------------------------------------------
let mapleader = ' '
let maplocalleader = ' '

source $VIMHOME/vimplug.vim

" ---------------------------------------------------------------------------
" General settings
" ---------------------------------------------------------------------------
" Editorconfig will override those settings. We keep them around
" nevertheless, in case ~/.editorconfig does not exist.
set fileencoding=utf-8
set nobackup                   " never keep backup files
set nowritebackup              " don't create backup files before writing
set showcmd                    " display incomplete commands
set expandtab                  " Use spaces for indenting only
set shiftwidth=4               " Set default indentation width

" Set the number of spaces a tab counts while editing. When expandtab is
" enabled, vim will only insert spaces. Else it will insert a combination
" of tabs and spaces in order to reduce the size of a file.
set softtabstop=4

" Hide buffers when abandoning them. This makes the use of language server
" rename operations possible. The downside is that changes may be lost when
" :qa or :q! is used carelessly.
set hidden

set cmdheight=2
set signcolumn=yes:2

" default updatetime 4000ms is not good for async update
set updatetime=100

" Set the characters that listmode should highlight
set lcs=eol:$,tab:>-,trail:·
set nolist

" When spliting horizontaly always split below the current window,
" when spliting verticaly always open the window on the right.
set splitbelow
set splitright
language messages en_US.UTF-8
set diffopt=filler,vertical

" ---------------------------------------------------------------------------
" Color settings
" ---------------------------------------------------------------------------
if has('nvim') || has('termguicolors')
    set termguicolors
endif

set colorcolumn=80,120

" ---------------------------------------------------------------------------
" Folding
" ---------------------------------------------------------------------------

" Disable folding by default. Toggle it with the zi command.
set nofoldenable

" set foldlevelstart=3 " Initial foldlevel; all folds with higher level are closed
"                      " Initially we keep all folds open.

" set foldnestmax=3    " Three fold levels should be enough for most of our needs
"                      " we can always add more on a filetype specific level.

" augroup dotfiles_nvim_terminal
"     autocmd!
"     " enter insert mode whenever we're in a terminal
" 	autocmd TermOpen,BufWinEnter,BufEnter term://* startinsert
" augroup END

" ---------------------------------------------------------------------------
" Lua configuration
" ---------------------------------------------------------------------------
" Call the parts of my neovim configuration that have been already ported to
" lua.
lua <<EOF
require("dotfiles.settings").setup()
EOF
