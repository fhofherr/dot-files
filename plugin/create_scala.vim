" Adds a package line to newly created scala files.
"
" Author     :   Ferdinand Hofherr <ferdinand.hofherr@gmail.com>

if exists("g:create_scala_loaded") && !exists("g:create_scala_force_reload")
    finish
endif
let g:create_scala_loaded = 1

python << EOF
import re
import vim

SOURCE_FOLDER_RE = re.compile(r".*/(src|source)/")
FILE_NAME_RE = re.compile(r"/[^/]+\.scala$")
PACKAGE_PREFIX_RE = re.compile(r"^.*/(de|com|org)")

def in_subdir_of_source(bufname):
    return SOURCE_FOLDER_RE.match(bufname) is not None

def remove_filename(bufname):
    return FILE_NAME_RE.sub("", bufname)

def remove_path(bufname):
    return PACKAGE_PREFIX_RE.sub(r"\1", bufname)

def replace_delims(bufname):
    return bufname.replace(r"/", r".")

def create_package_line():
    cb = vim.current.buffer
    p = remove_filename(cb.name)
    if not in_subdir_of_source(p):
        return
    p = remove_path(p)
    p = replace_delims(p)
    cb[0:0] = ["package " + p]

EOF

function! MakeScalaFile()
    python create_package_line()
endfunction

au BufNewFile *.scala call MakeScalaFile()
