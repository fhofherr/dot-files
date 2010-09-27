" Adds a package line to newly created scala files.
"
" Author:       Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Latst Change: 2010-05-31

if exists("g:scala_loaded") && !exists("g:scala_force_reload")
    finish
endif
let g:scala_loaded = 1

python << EOF
import os
import re
import vim

def in_subdir_of_source(bufname):
    return re.match(r".*/src/", bufname) is not None

def is_scala_file(filename):
    (_, e) = os.path.splitext(filename)
    return e == ".scala"

def create_package_line():
    cb = vim.current.buffer
    (p, f) = os.path.split(cb.name)
    if not in_subdir_of_source(p) or not is_scala_file(f):
        return ""
    p = re.sub(r"^.*/src(/test|/main)?(/scala)?/", "", p)    
    p = p.replace(r"/", r".")
    return p
EOF

function! SnipMateScalaJava_CreatePackageLine()
python <<EOF
vim.command("return '" + create_package_line() + "'")
EOF
endfunction
