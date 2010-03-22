"" Vim plugin that allows to load project specific configuration.
"" 
"" Last Change: 2010-03-22
"" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>

if exists("g:vimproject_loaded") && !exists("g:vimproject_force_reload")
    finish
endif
let vimproject_loaded = 1

if !has("unix")
    "" This plugin works under unix/linux only
    finish
endif

if !exists("g:vimproject_dirname")
    let g:vimproject_dirname = ".vimproject"
endif

if !exists("g:vimproject_settings")
    let g:vimproject_settings = "settings.vim"
endif

function! s:abspath(path)
    if match(a:path, "^/", "") == -1
        return getcwd() . "/" . a:path
    endif 
    return a:path
endfunction

"" Search for the project directory.
""
"" Parameter:
""   path: path to search for the project directory.
function! s:find_project_dir(path)
    let l:tmp = finddir(g:vimproject_dirname, a:path) 
    if l:tmp != ""
        return s:abspath(l:tmp)
    endif
    return  $HOME . "/.vim/vimproject"
endfunction

function! g:get_vimproject_file(name)
    return g:current_project_directory . "/" . a:name
endfunction

function! g:source_vimproject_file(name)
    exec "source " . g:get_vimproject_file(a:name)
endfunction

if !exists("g:current_project_directory")
    let g:current_project_directory = s:find_project_dir(getcwd())
endif

if !exists("g:current_project_settings")
    let g:current_project_settings = 
                \ g:get_vimproject_file(g:vimproject_settings)
endif

exec "source " . g:current_project_settings
