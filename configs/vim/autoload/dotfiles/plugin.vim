function dotfiles#plugin#selected(name)
    return exists('g:plugs') && has_key(g:plugs, a:name)
endfunction

function dotfiles#plugin#load_config(cfgdir)
    let l:cfg_files = globpath(a:cfgdir, '**/*.vim', 0, 1)
    for cfg_file in cfg_files
        execute 'source ' . cfg_file
    endfor
endfunction
