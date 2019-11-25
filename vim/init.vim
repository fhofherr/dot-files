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
" neovim-remote settings
" ---------------------------------------------------------------------------
if has('nvim') && exists('$NEOVIM_NVR')
    let $GIT_EDITOR = $NEOVIM_NVR . ' -cc split --remote-wait'
    augroup dotfiles_nvr
        autocmd FileType gitcommit,gitrebase,gitconfig setlocal bufhidden=delete
    augroup END
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
set signcolumn=yes

" don't give |ins-completion-menu| messages.
set shortmess+=c

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

" Search using / or ? is only case sensitive if there is at least one capital
" letter included.
set ignorecase
set smartcase

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
if has('nvim') || has('termguicolors')
    set termguicolors
endif

if $DOTFILES_COLOR_PROFILE == 'light'
    set background=light
else
    set background=dark
endif

set colorcolumn=80,120
