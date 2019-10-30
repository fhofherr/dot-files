function dotfiles#lightline#gitbranch() abort
    if !dotfiles#plugin#selected('vim-fugitive')
        return ''
    endif
    return call('fugitive#Head', [])
endfunction
