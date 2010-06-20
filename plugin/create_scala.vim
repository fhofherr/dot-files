" Adds a package line to newly created scala files.
"
" Author:       Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
" Latst Change: 2010-05-31

if exists("g:create_scala_loaded") && !exists("g:create_scala_force_reload")
    finish
endif
let g:create_scala_loaded = 1

python << EOF
import os
import re
import vim

SOURCE_FOLDER_RE = re.compile(r".*/src/")

def in_subdir_of_source(bufname):
    return SOURCE_FOLDER_RE.match(bufname) is not None

def is_scala_file(filename):
    (r, e) = os.path.splitext(filename)
    return e == ".scala"

def create_package_line():
    cb = vim.current.buffer
    (p, f) = os.path.split(cb.name)
    if not in_subdir_of_source(p) or not is_scala_file(f):
        return
    p = re.sub(r"^.*/src/(test|main)/scala/", "", p)    
    p = p.replace(r"/", r".")
    cb[0:0] = ["package " + p]

EOF

function! CreateScalaFile()
    python create_package_line()
endfunction

au BufNewFile *.scala call CreateScalaFile()
