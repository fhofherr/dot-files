function dotfiles#plugin#selected(name)
    return exists('g:plugs') && has_key(g:plugs, a:name)
endfunction
