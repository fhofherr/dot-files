" ---------------------------------------------------------------------------
"
" fzf.vim
"
" ---------------------------------------------------------------------------
if !dotfiles#plugin#selected('fzf') || !dotfiles#plugin#selected('fzf.vim') || exists('g:did_cfg_fzf')
    finish
endif
let g:did_cfg_fzf = 1

" Default fzf layout
if has('nvim-0.5')
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 }}
elseif has('nvim')
" if has('nvim')
    let g:fzf_layout = { 'window': '10split enew' }
else
    let g:fzf_layout = { 'down': '~40%' }
endif

let g:fzf_buffers_jump = 1

nmap <silent> <F1> :Helptags<cr>
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <leader>ff :Files<cr>

nnoremap <silent> <leader>fb :Buffers<cr>

nnoremap <silent> <leader>ft :Tags<cr>
nnoremap <silent> <leader>fm :Marks<cr>

nmap <silent> // :BLines<cr>
nmap <silent> ?? :Ag<cr>

" Taken from https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BufferDelete call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

let s:laststatus = &laststatus
let s:showmode = &showmode
let s:ruler = &ruler
let s:timeoutlen = &timeoutlen

function! s:fzf_disable_settings()
    set laststatus=0
    set noshowmode
    set noruler
    set timeoutlen=0 " ensures that CTRL-V works without delay

    " Escape inside a FZF terminal window should exit the terminal window
    " rather than going into the terminal's normal mode.
    tnoremap <buffer> <Esc> <Esc>

    " nmap <buffer><tab> <plug>(fzf-maps-n)
    " xmap <buffer><tab> <plug>(fzf-maps-x)
    " omap <buffer><tab> <plug>(fzf-maps-o)
endfunction

function! s:fzf_enable_settings()
    let &laststatus = s:laststatus
    let &showmode = s:showmode
    let &ruler =  s:ruler
    let &timeoutlen = s:timeoutlen
endfunction

augroup dotfiles_fzf
  autocmd!
  autocmd FileType fzf :call <SID>fzf_disable_settings()
              \| autocmd BufLeave <buffer> :call <SID>fzf_enable_settings()
augroup end
