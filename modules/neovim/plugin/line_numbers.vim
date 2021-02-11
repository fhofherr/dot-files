" ---------------------------------------------------------------------------
"
" Line number settigns
"
" ---------------------------------------------------------------------------
if exists('g:did_cfg_line_numbers')
    finish
endif
let g:did_cfg_line_numbers = 1

" Line numbers
set numberwidth=5
set number

" Toggle relative line numbers in addition to absolute line numbers when
" a buffer is selected. Disable them when a buffer is de-selected, or when
" in insert mode.
function! s:toggle_relative_number(state)
    let ignore_list = ['help', 'qf']
    if &ft == '' || index(ignore_list, &ft) >= 0
        return
    endif
    if a:state && &number
        setlocal relativenumber
    else
        setlocal norelativenumber
    endif
endfunction

augroup dotfiles_numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * :call <SID>toggle_relative_number(v:true)
    autocmd BufLeave,FocusLost,InsertEnter * :call <SID>toggle_relative_number(v:false)
augroup END
