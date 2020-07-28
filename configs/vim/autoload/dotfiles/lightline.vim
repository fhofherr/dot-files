function dotfiles#lightline#gitbranch() abort
    if !dotfiles#plugin#selected('vim-fugitive')
        return ''
    endif
    return call('fugitive#Head', [])
endfunction

function! dotfiles#lightline#gutentags_status()
    if !dotfiles#plugin#selected('vim-gutentags')
        return ''
    endif
    if !exists('b:gutentags_files')
        return ''
    endif
    return call('gutentags#statusline', [])
endfunction

function! dotfiles#lightline#lsp_status()
    return luaeval('require("dotfiles/lightline/lsp").status()')
endfunction
