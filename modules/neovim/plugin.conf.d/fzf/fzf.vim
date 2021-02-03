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
if has('nvim')
    let g:fzf_layout = { 'window': '10split enew' }
else
    let g:fzf_layout = { 'down': '~40%' }
endif

let g:fzf_buffers_jump = 1

nmap <silent> <F1> :Helptags<CR>
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <c-g><c-f> :Files<cr>
nnoremap <silent> <c-b> :Buffers<cr>
nnoremap <silent> <c-g><c-b> :Buffers<cr>
nnoremap <silent> <c-g><c-t> :Tags<cr>
nnoremap <silent> <c-g><c-m> :Marks<cr>

let s:laststatus = &laststatus
let s:showmode = &showmode
let s:ruler = &ruler
let s:timeoutlen = &timeoutlen

function! s:fzf_disable_settings()
    set laststatus=0
    set noshowmode
    set noruler
    set timeoutlen=0 " ensures that CTRL-V works without delay

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
