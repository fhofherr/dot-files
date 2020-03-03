import sys
import os
import pytest
import tempfile
import shutil

TESTS_DIR = os.path.dirname(os.path.abspath(os.path.realpath(__file__)))
DOTFILES_DIR = os.path.dirname(TESTS_DIR)
LIB_DIR = os.path.join(DOTFILES_DIR, '_lib')

sys.path.append(LIB_DIR)

import dotfiles.fs as fs
import dotfiles.git as git


@pytest.fixture()
def tmpfile(tmpdir):
    (h, p) = tempfile.mkstemp(dir=tmpdir)
    try:
        yield p
    finally:
        os.close(h)
        os.remove(p)


@pytest.fixture()
def gitrepo(tmpdir):
    repodir = tempfile.mkdtemp(dir=tmpdir)
    with fs.chdir(repodir):
        git._run('git', 'init')
        git._run('git', 'config', 'user.email', 'test@example.com')
        git._run('git', 'config', 'user.name', 'test')
        with open('some_file.txt', 'w') as f:
            f.write('This is just some file\n')
        git._run('git', 'add', 'some_file.txt')
        git._run('git', 'commit', '-m', 'Add some_file.txt')
    try:
        yield repodir
    finally:
        shutil.rmtree(repodir)
