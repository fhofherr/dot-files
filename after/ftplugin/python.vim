" Enable folding for python
setlocal foldmethod=indent
setlocal foldlevel=0

" Add the virtualenv's site-packages to vim path and activate virtualenv
" See: http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide
" See: http://blog.roseman.org.uk/2010/04/21/vim-autocomplete-django-and-virtualenv/
python << EOF
import os
import sys

if 'VIRTUAL_ENV' in os.environ:
    virtualenv_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(virtualenv_base_dir, 'bin', 'activate_this.py')
    execfile(activate_this, {'__file__': activate_this})
EOF
