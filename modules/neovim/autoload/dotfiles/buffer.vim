function! dotfiles#buffer#next() abort
    let l:buf = s:cycle_buf('forward')
    if l:buf == bufnr()
        return
    endif
    execute ':buffer' l:buf
endfunction

function! dotfiles#buffer#prev() abort
    let l:buf = s:cycle_buf('backwards')
    if l:buf == bufnr()
        return
    endif
    execute ':buffer' l:buf
endfunction

" Cylcles through vim's list of buffers and returns the number of the
" next buffer in direction which is not yet displayed in a window.
function! s:cycle_buf(direction) abort
    let l:bufs = nvim_list_bufs()
    let l:cur_buf = bufnr()

    if len(l:bufs) == 1
        return l:cur_buf
    endif

    let l:cur_idx = index(l:bufs, l:cur_buf)
    let l:idx = s:next_index(l:cur_idx, len(l:bufs), a:direction)
    while l:idx != l:cur_idx
        let l:buf = l:bufs[l:idx]
        " Immediatly advance to next index. This way we can use continue below
        " without forgetting.
        let l:idx = s:next_index(l:idx, len(l:bufs), a:direction)
        if !getbufvar(l:buf, '&buflisted')
            continue
        endif
        if !nvim_buf_is_loaded(l:buf) || bufwinnr(l:buf) == -1
            return l:buf
        endif
    endwhile

    return l:cur_buf
endfunction

function! s:next_index(cur_idx, n_bufs, direction)
    if a:direction == "forward"
        let l:idx = a:cur_idx + 1
    else
        let l:idx = a:cur_idx - 1
    endif

    if l:idx < 0
        let l:idx = a:n_bufs - 1
    endif
    if l:idx >= a:n_bufs
        let l:idx = 0
    endif

    return l:idx
endfunction
