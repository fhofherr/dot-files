function! s:find_executable(paths)
    for path in a:paths
        if executable(path)
            return path
        endif
    endfor
    return ''
endfunction

let s:python3 = s:find_executable(['/usr/local/bin/python3', '/home/linuxbrew/.linuxbrew/bin/python3', '~/.linuxbrew/bin/python3'])

let s:python2 = s:find_executable(['/usr/local/bin/python2', '/home/linuxbrew/.linuxbrew/bin/python2', '~/.linuxbrew/bin/python2'])

if !empty(s:python3)
    let g:python3_host_prog=s:python3
endif

if !empty(s:python2)
    let g:python_host_prog=s:python2
endif
