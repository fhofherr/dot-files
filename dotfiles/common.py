import os

from dotfiles import fs

HOME_DIR = os.path.expanduser("~")
ROOT_DIR = fs.find_dotfiles_dir(HOME_DIR)

HTTP_USER_AGENT = "fhofherr-dotfiles-installer"


def xdg_config_home(home_dir):
    return os.path.join(home_dir, ".config")


def bin_dir(home_dir, mkdir=False):
    bin_dir = os.path.join(home_dir, ".local", "dotfiles", "tools", "bin")
    if mkdir:
        os.makedirs(bin_dir, exist_ok=True)
    return bin_dir
