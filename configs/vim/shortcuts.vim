" ---------------------------------------------------------------------------
"
" Shortcuts
"
" ---------------------------------------------------------------------------

" Somehow neovim seems to freeze when pressing an F key in insert mode.
" We map them to a nop to stop this
inoremap <F1> <nop>
inoremap <F2> <nop>
inoremap <F3> <nop>
inoremap <F4> <nop>
inoremap <F5> <nop>
inoremap <F6> <nop>
inoremap <F7> <nop>
inoremap <F8> <nop>
inoremap <F9> <nop>
inoremap <F10> <nop>
inoremap <F11> <nop>
inoremap <F12> <nop>

let mapleader = ' '
let maplocalleader = ' '

command Cd cd %:p:h
command Lcd lcd %:p:h

" Buffer management
"
" Additional mappings are defined in plugin.conf.d/fzf/fzf.vim
nnoremap <silent> <right> :call dotfiles#buffer#next()<cr>
nnoremap <silent> <left> :call dotfiles#buffer#prev()<cr>
nnoremap <silent> Q :bdelete<cr>

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

if !dotfiles#plugin#selected('vim-tmux-navigator')
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
endif
