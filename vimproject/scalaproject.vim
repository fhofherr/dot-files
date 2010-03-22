"" Example configuration of scala-projects.
""
"" Last Change: 2010-03-22
"" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>
if exists("g:scalaproject_loaded")
    let g:scalaproject_loaded = 1
endif

" Tries to infer the name of the package from the file's name and path.
" 
" This function uses code shamelessly stolen from Stepan Koltsov's (Stepan
" Koltsov <yozh@mx1.ru>) '31-create-scala.vim', which can be found at
" https://lampsvn.epfl.ch/svn-repos/scala/scala-tool-support/trunk/src/vim/plugin/31-create-scala.vim
"
" Parameter:
"
" filename: the scala file's name including its path. If this
" function is used from an autocommand it is easiest obtained by
" 'expand("<afile>:p")'.
function! s:scala_package_name(filename)
    let x = substitute(a:filename, "\.scala$", "", "")
    
    let l:pkgname = substitute(x, "/[^/]*$", "", "")
    let l:pkgname = substitute(l:pkgname, "/", ".", "g")
    let l:pkgname = substitute(l:pkgname, ".*\.src$", "@", "") " unnamed package
    let l:pkgname = substitute(l:pkgname, ".*\.src\.", "!", "")  
    let l:pkgname = substitute(l:pkgname, "^!main\.scala\.", "!", "")
    let l:pkgname = substitute(l:pkgname, "^!.*\.ru\.", "!ru.", "")
    let l:pkgname = substitute(l:pkgname, "^!.*\.de\.", "!de.", "")
    let l:pkgname = substitute(l:pkgname, "^!.*\.org\.", "!org.", "")
    let l:pkgname = substitute(l:pkgname, "^!.*\.com\.", "!com.", "")
    
    " ! marks that we found package name.
    if match(l:pkgname, "^!") == 0
        let l:pkgname = "package " . substitute(l:pkgname, "^!", "", "")
    else
        let l:pkgname = ""
    endif
    return l:pkgname 
endfunction

" Creates a new scala file.
function! s:create_scala_file()
     let filename = expand("<afile>:p")
     let pkgname = s:scala_package_name(filename)
     if pkgname != ""
         call append("0", pkgname)
     endif
endfunction

autocmd BufNewFile *.scala call s:create_scala_file()
