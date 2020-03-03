import re
import os
import hashlib
import shutil
import datetime


def find_dotfiles_dir(home_dir):
    file_path = os.path.abspath(os.path.realpath(__file__))
    cur_dir = os.path.dirname(file_path)
    git_dir = os.path.join(cur_dir, ".git")
    while cur_dir != home_dir and not os.path.exists(git_dir):
        cur_dir = os.path.dirname(cur_dir)
        git_dir = os.path.join(cur_dir, ".git")
    if cur_dir == home_dir:
        raise DotfilesDirNotFoundError
    return cur_dir


class DotfilesDirNotFoundError(Exception):
    pass


def safe_link_file(src, dest):
    """Creates symbolic link from the configuration files source to its
    destination.

    If the destination already exists and the destination's contents are
    equal to the source it replaces the destination with a symbolic link.
    Should the destination's contents differ install creates a backup copy
    of the destination before replacing it with a symbolic link. If the
    destination already is a symbolic link to the source file the install
    method does nothing.
    """
    parent_dir = os.path.dirname(dest)
    if not os.path.exists(parent_dir):
        os.makedirs(parent_dir)
    if os.path.exists(dest):
        if os.path.samefile(src, dest):
            return
        elif _files_identical(src, dest):
            os.remove(dest)
        else:
            _backup(dest)
            os.remove(dest)
    os.symlink(src, dest)


def safe_remove_link(src, dest):
    """Removes the symbolic link from src to dest.

    If there exists a backup of a previous file the most recent backup is
    restored.

    If safe_link_file created intermediate directories which are empty after
    the symbolic link is removed those directories are deleted as well.
    """
    if not os.path.samefile(src, dest):
        return
    bkpfile = _find_latest_backup(dest)
    os.remove(dest)
    if bkpfile is not None:
        shutil.copy(bkpfile, dest)
        os.remove(bkpfile)
    basedir = os.path.dirname(dest)
    if _dir_empty(basedir):
        os.removedirs(basedir)


def _files_identical(file1, file2):
    return _sha256(file1) == _sha256(file2)


def _sha256(file_path):
    with open(file_path, 'rb') as f:
        bs = f.read()
        return hashlib.sha256(bs).digest()


def _backup(file_path):
    bkpfile = _backup_file_name(file_path)
    if not bkpfile:
        return
    shutil.copy(file_path, bkpfile)
    return bkpfile


def _backup_file_name(file_path):
    fmt = '{file_path}.{bkpdate}.{version}'
    bkpdate = datetime.datetime.now().strftime('%Y%m%d')
    version = 1
    bkpfile = fmt.format(file_path=file_path, bkpdate=bkpdate, version=version)
    while os.path.exists(bkpfile):
        version += 1
        bkpfile = fmt.format(file_path=file_path,
                             bkpdate=bkpdate,
                             version=version)
    return bkpfile


def _find_latest_backup(file_path):
    dir_path = os.path.dirname(file_path)
    file_name = os.path.basename(file_path)
    bkpfiles = _find_all_backups(dir_path, file_name)
    if len(bkpfiles) == 0:
        return None
    bkpfiles.sort(key=lambda i: i[0:2])
    bkpfile = bkpfiles[-1][2]
    return os.path.join(dir_path, bkpfile)


def _find_all_backups(dir_path, file_name):
    bkpfile_re = re.escape(
        file_name) + r'\.(?P<bkpdate>\d{8})\.(?P<version>\d+)'
    bkpfile_re = re.compile(bkpfile_re)
    bkpfiles = []
    for p in os.listdir(dir_path):
        m = bkpfile_re.match(p)
        if m is None:
            continue
        file_info = (m.group('bkpdate'), int(m.group('version')), p)
        bkpfiles.append(file_info)
    return bkpfiles


def _dir_empty(dir_path):
    if not os.path.isdir(dir_path):
        return False
    xs = os.listdir(dir_path)
    return len(xs) == 0
