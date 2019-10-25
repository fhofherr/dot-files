" ---------------------------------------------------------------------------
" Set vimhome
" ---------------------------------------------------------------------------
if has('win32') || has('win64')
    let $VIMHOME = $VIM."/vimfiles"
elseif has('nvim') && exists("$XDG_CONFIG_HOME")
    let $VIMHOME = $XDG_CONFIG_HOME . '/nvim'
elseif has('nvim') && !exists("$XDG_CONFIG_HOME")
    let $VIMHOME = $HOME . '/.config/nvim'
else
    let $VIMHOME = $HOME . "/.vim"
endif

" ---------------------------------------------------------------------------
" Configure Providers for nvim
" ---------------------------------------------------------------------------

if has('nvim') && exists("$NEOVIM_PYTHON3")
    let g:python3_host_prog=$NEOVIM_PYTHON3
    let g:python3_bin_dir=fnamemodify(g:python3_host_prog, ':h')
endif

if has('nvim') && exists("$NEOVIM_RUBY_HOST")
    let g:ruby_host_prog=$NEOVIM_RUBY_HOST
endif

" ---------------------------------------------------------------------------
"
" General settings
"
" ---------------------------------------------------------------------------
" Editorconfig will override those settings. We keep them around
" nevertheless, in case ~/.editorconfig does not exist.
set fileencoding=utf-8
set nobackup                   " never keep backup files
set showcmd                    " display incomplete commands
set expandtab                  " Use spaces for indenting only
set shiftwidth=4               " Set default indentation width

"" Set the number of spaces a tab counts while editing. When expandtab is
"" enabled, vim will only insert spaces. Else it will insert a combination
"" of tabs and spaces in order to reduce the size of a file.
set softtabstop=4

set numberwidth=5
set number
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

augroup dotfiles_vim_init
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
augroup end

source $VIMHOME/shortcuts.vim
source $VIMHOME/vimplug.vim

" ---------------------------------------------------------------------------
"
" Color settings
"
" ---------------------------------------------------------------------------
set termguicolors
set colorcolumn=80,120
