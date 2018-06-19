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
" Configure Python2 / Python 3 for nvim
" ---------------------------------------------------------------------------
function! s:find_executable(paths)
    for path in a:paths
        if executable(path)
            return path
        endif
    endfor
    return ''
endfunction

let s:python3 = s:find_executable([
    \'/usr/local/bin/python3',
    \'/home/linuxbrew/.linuxbrew/bin/python3',
    \'~/.linuxbrew/bin/python3'
\])

let s:python2 = s:find_executable([
    \'/usr/local/bin/python2',
    \'/home/linuxbrew/.linuxbrew/bin/python2',
    \'~/.linuxbrew/bin/python2'
\])

if has('nvim') && !empty(s:python3)
    let g:python3_host_prog=s:python3
endif

if has('nvim') && !empty(s:python2)
    let g:python_host_prog=s:python2
endif

let s:neovim_ruby_host=s:find_executable([
    \'/usr/local/bin/neovim-ruby-host'
\])

if has('nvim') && !empty(s:neovim_ruby_host)
    let g:ruby_host_prog=s:neovim_ruby_host
endif

let s:neovim_node_host=s:find_executable([
    \'/usr/local/bin/neovim-node-host'
\])

if has('nvim') && !empty(s:neovim_node_host)
    let g:node_host_prog=s:neovim_node_host
endif

" ---------------------------------------------------------------------------
"
" General settings
"
" ---------------------------------------------------------------------------
set fileencoding=utf-8
set nobackup                   " never keep backup files
set showcmd                    " display incomplete commands
set expandtab                  " Use spaces for indenting only
set shiftwidth=4               " Set default indentation width
"" Set the number of spaces a tab counts while editing. When expandtab is
"" enabled, vim will only insert spaces. Else it will insert a combination
"" of tabs and spaces in order to reduce the size of a file.
set softtabstop=4

" Set the characters that listmode should highlight
set lcs=eol:$,tab:>-,trail:·
set list

" When spliting horizontaly always split below the current window,
" when spliting verticaly always open the window on the right.
set splitbelow
set splitright
language messages en_US.UTF-8
set diffopt=filler,vertical

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

if filereadable($VIMHOME . '/local.vim')
    source $VIMHOME/local.vim
endif

source $VIMHOME/shortcuts.vim
source $VIMHOME/vimplug.vim

let s:cfg_files = globpath($VIMHOME . '/conf.d/', '*.vim', 0, 1)
for plugincfg in s:cfg_files
    execute 'source ' . plugincfg
endfor
