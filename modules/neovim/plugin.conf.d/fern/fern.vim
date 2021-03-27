if !dotfiles#plugin#selected('fern.vim') || exists('g:did_cfg_fern_vim')
    finish
endif
let g:did_cfg_fern_vim = 1

let g:fern#disable_default_mappings = 1

noremap <silent> <Leader>e :Fern . -drawer -toggle -reveal=% -width=40<CR><C-w>=

nnoremap <Plug>(fern-my-close-drawer) :<C-u>FernDo close -drawer -stay<CR>

function! s:fern_init() abort
  " Open selection and close Fern project drawer.
  nmap <buffer><silent> <Plug>(fern-action-open-and-close:select)
      \ <Plug>(fern-action-open:select)
      \ <Plug>(fern-my-close-drawer)

  " Open file or expand/collapse a directory
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-and-close-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open-and-close:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer><expr>
        \ <Plug>(fern-my-open-or-enter)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-enter)",
        \ )

  nmap <buffer> <CR> <Plug>(fern-my-open-and-close-expand-collapse)
  nmap <buffer> <C-CR> <Plug>(fern-my-open-expand-collapse)

  nmap <buffer> m <Plug>(fern-action-mark:toggle)j
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> D <Plug>(fern-action-remove)
  nmap <buffer> V <Plug>(fern-action-move)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> x <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
  nmap <buffer> <nowait> l <Plug>(fern-my-open-or-enter)
  nmap <buffer> <nowait> h <Plug>(fern-action-leave)
endfunction

augroup dotfiles_fern
  autocmd!
  autocmd FileType fern call <SID>fern_init()
augroup END
