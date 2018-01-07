#!/usr/bin/env python3

import shutil
import os
import os.path as osp
import datetime
import subprocess

class InstallError(Exception):
    pass


def print_color(color, *args):
    color = color.upper()
    colors = {
        'GREEN': '''\033[32m''',
        'RED': '''\033[31m''',
        'END': '''\033[0m''',
    }
    print(colors[color] + ' '.join(args) + colors['END'])


def is_same_file(p1, p2):
    """Check whether p1 and p2 point to the same file."""
    if not osp.exists(p1) or not osp.exists(p2):
        return False
    if osp.samefile(p1, p2):
        return True
    return False

def create_backup(path):
    timestamp = datetime.date.today().strftime("%Y%m%d")
    backup_path = path + '.' + timestamp
    n = 1
    while osp.exists(backup_path):
        if n > 1:
            l = len('.' + str(n))
            backup_path = backup_path[:-l]
        n += 1
        backup_path = backup_path + '.' + str(n)
    print_color('GREEN', 'Backing up', path, 'to', backup_path)
    shutil.move(path, backup_path)


def create_link(src, dest):
    if osp.exists(dest) and not is_same_file(src, dest):
        create_backup(dest)
    if not osp.exists(dest):
        print_color('GREEN', 'Linking', src, 'to', dest)
        os.symlink(src, dest)


def get_editor():
    supported_vims = ('vim', 'nvim', 'mvim')
    editor = os.environ.get('EDITOR', 'vim').strip()
    editor = editor.split(' ')[0]
    if osp.basename(editor) not in supported_vims:
        msg = "Unsuported editor '{editor}'! Supported: [{vims}].".format(
                editor=editor, vims=', '.join(supported_vims))
        raise InstallError(msg)
    return editor


def install_vim_plugins():
    editor = get_editor()
    print_color('GREEN', 'Installing plugins for:', editor)
    subprocess.call([editor, '-E', '-c', 'PlugInstall', '-c', 'qall!'])


def install_nvim_providers():
    # Python 2 and 3
    pip_args = ['install', '--user', '--upgrade', 'neovim']
    pip2 = shutil.which('pip2')
    pip3 = shutil.which('pip3')
    pip = shutil.which('pip')
    if pip2:
        print_color('GREEN', 'Installing Python 2 provider for NeoVim')
        subprocess.call([pip2] + pip_args )
    if pip3:
        print_color('GREEN', 'Installing Python 3 provider for NeoVim')
        subprocess.call([pip3] + pip_args )
    if pip and not pip2 and not pip3:
        print_color('GREEN','Installing Python provider for NeoVim')
        subprocess.call([pip] + pip_args )
    # Ruby
    gem = shutil.which('gem')
    if gem:
        print_color('GREEN','Installing Ruby provider for NeoVim')
        subprocess.call([gem, 'install', 'neovim'])
    npm = shutil.which('npm')
    # NodeJS
    if npm:
        print_color('GREEN','Installing NodeJS provider for NeoVim')
        subprocess.call([npm, 'install', '-g', 'neovim'])


HOME_DIR = os.environ['HOME']
CONFIG_HOME = os.environ.get('XDG_CONFIG_HOME', osp.join(HOME_DIR, '.config'))
CFG_DIR = osp.dirname(osp.realpath(__file__))

if __name__ == "__main__":
    create_link(osp.join(CFG_DIR, 'vimrc'), osp.join(HOME_DIR, '.vimrc'))
    create_link(osp.join(CFG_DIR, 'gvimrc'), osp.join(HOME_DIR, '.gvimrc'))
    create_link(osp.join(CFG_DIR, 'nvim'), osp.join(CONFIG_HOME, 'nvim'))
    install_vim_plugins()
    if get_editor() == 'nvim':
        install_nvim_providers()
