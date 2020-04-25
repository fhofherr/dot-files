" ---------------------------------------------------------------------------
"
" Shortcuts
"
" ---------------------------------------------------------------------------

let mapleader = ' '
let maplocalleader = ' '

command Cd cd %:p:h
command Lcd lcd %:p:h

nnoremap <silent> <tab> :bnext<cr>
nnoremap <silent> <s-tab> :bprev<cr>

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

" Re-map [ to - and ] to _.
" See https://github.com/tpope/vim-unimpaired#faq
nmap - [
nmap _ ]
omap - [
omap _ ]
xmap - [
xmap _ ]
