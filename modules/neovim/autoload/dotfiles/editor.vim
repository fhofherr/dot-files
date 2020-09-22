" Copied and adapted from ALE function ale#definition#UpdateTagStack().
" See: https://github.com/dense-analysis/ale/blob/v2.6.0/autoload/ale/definition.vim#L23
function dotfiles#editor#push_tag_stack() abort
    if exists('*gettagstack') && exists('*settagstack')
        " Grab the old location (to jump back to) and the word under the
        " cursor (as a label for the tagstack)
        let l:old_location = [bufnr('%'), line('.'), col('.'), 0]
        let l:tagname = expand('<cword>')
        let l:winid = win_getid()
        call settagstack(l:winid, {'items': [{'from': l:old_location, 'tagname': l:tagname}]}, 'a')
        call settagstack(l:winid, {'curidx': len(gettagstack(l:winid)['items']) + 1})
    endif
endfunction

function dotfiles#editor#with_tag_stack(func, ...)
    call dotfiles#editor#push_tag_stack()
    return call(a:func, a:000)
endfunction
