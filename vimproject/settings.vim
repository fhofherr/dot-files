" Default settings for projects without project directory.
" This file may also serve as a template for project specific settings.
"
" Last Change: 2010-03-22
" Author:      Ferdinand Hofherr <ferdinand.hofherr@gmail.com>

" Ensure the settings are not sourced more than once. This also includes
" settings originating from another project's settings file. You should
" use seperate vim instances for that.
if exists("g:vimproject_settings_loaded")
    finish
endif
let g:vimproject_settings_loaded = 1

" Define your project specific settings here. You may put them into
" other files. In this case you can use the
"
"       g:get_vimproject_file(file)
"
" function to get the correct filename. You can then source them using:
"
"       exec source g:get_vimproject_file(<filename>)
"
" There is the even easier way of calling g:source_vimproject_file

" Below I source some scala specific settings, they are just an example.
call g:source_vimproject_file("scalaproject.vim")
