" Adds a default header to newly created python files.
"
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Last Change: 2010-05-29

if exists("g:create_python_loaded")
    finish
endif
let g:create_python_loaded = 1
 
function CreatePythonFile()
     call append(0, '# vim: fileencoding=utf-8')
endfunction

au BufNewFile *.py call CreatePythonFile()
