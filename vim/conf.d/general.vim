" ---------------------------------------------------------------------------
"
" General settings
"
" ---------------------------------------------------------------------------
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nobackup                   " never keep backup files
set history=50                 " keep 50 lines of command line history
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set incsearch                  " do incremental searching
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

" Enhance Tab completion of vim commands.
set wildmenu wildmode=list:longest

" Improve joining of comment lines.
" Found at https://kinbiko.com/vim/my-shiniest-vim-gems/
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

language messages en_US.UTF-8

set diffopt=filler,vertical

" ---------------------------------------------------------------------------
"
" Shortcuts
"
" ---------------------------------------------------------------------------

let mapleader = ' '

" Toggle list mode
nnoremap <Leader>ls :set invlist<cr>:set list?<cr>

" Turn off highlight search
nnoremap <Leader>nh :set invhls<cr>:set hls?<cr>

" cd to the directory containing the file in the buffer and toggle a NERTTree
nnoremap <Leader>nt :NERDTreeToggle<cr>

" Identify active highlight group.
" Source: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Disable insert mode commands
imap <c-a> <Nop>
imap <c-c> <Nop>
imap <c-h> <Nop>
imap <c-u> <Nop>
imap <c-w> <Nop>
" ---------------------------------------------------------------------------
"
" Autocommands
"
" ---------------------------------------------------------------------------
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif
"
" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
" See: http://stackoverflow.com/questions/3105307/how-do-you-automatically-remove-the-preview-window-after-autocompletion-in-vim
" and http://stackoverflow.com/questions/11733388/how-do-i-prevent-my-vim-autocmd-from-running-in-the-command-line-window
autocmd CursorMovedI *  if pumvisible() == 0|silent! pclose|endif
autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
