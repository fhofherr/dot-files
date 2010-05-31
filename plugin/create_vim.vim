" Adds a default header to newly created vim files.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-05-31

if exists("g:create_vim_loaded")
    finish
endif
let g:create_vim_loaded = 1
 
function CreateVimFile()
    let header = ['" DESCRIBE YOUR SCRIPT HERE','"','" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>','" Last Change: DATE OF LAST SIGNIFICANT CHANGE']
     call append(0, header)
endfunction

au BufNewFile *.vim call CreateVimFile()
