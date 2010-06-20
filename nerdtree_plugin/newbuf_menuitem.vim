" Additional mappings for the NERDTree
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-06-20

if exists("g:loaded_nerdtree_newbuf_menuitem")
    finish
endif
let g:loaded_nerdtree_newbuf_menuitem = 1

call NERDTreeAddMenuItem({
    \ 'text': 'create a (n)ew buffer',
    \ 'shortcut': 'n',
    \ 'callback': 'FH_NERDTreeCreateNewBuffer'})

function! FH_NERDTreeCreateNewBuffer()
    let bufname = input("Create a new buffer\n" .
            \ "==========================================================\n" .
            \ "Enter the name of the new buffer\n", "") 
    if bufname ==# ''
        redraw
        echomsg "NERDTree: " . "creation of new buffer aborted."
        return
    endif
    let path = g:NERDTreeDirNode.GetSelected().path.getDir().str()
    let newbuf =  path . '/' . bufname
    let oldwin = winnr()
    wincmd p
    if oldwin ==# winnr()
        exec "vsplit" newbuf
    elseif &modified
        exec "split" newbuf
    else
        exec "edit" newbuf
    endif
endfunction
