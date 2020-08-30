import os
import shutil

from invoke import task

from dotfiles import common, git, logging

_LOG = logging.get_logger(__name__)

NERD_FONTS_REPO_URL = "https://github.com/ryanoasis/nerd-fonts.git"

FONTS = ["Iosevka", "FiraCode"]


# Note: you will still need to install an emoji font, e.g. noto-emoji

@task
def clone_repo(c, home_dir=common.HOME_DIR, update=False):
    nerd_fonts_dir = nerd_fonts_dir_path(home_dir)

    if update and os.path.exists(nerd_fonts_dir):
        shutil.rmtree(nerd_fonts_dir)
    git.clone(c, NERD_FONTS_REPO_URL, nerd_fonts_dir, depth=1, branch="v2.0.0")


@task
def install_font(c, font_name, home_dir=common.HOME_DIR):
    clone_repo(c, home_dir=home_dir)

    nerd_fonts_dir = nerd_fonts_dir_path(home_dir)
    install_script = os.path.join(nerd_fonts_dir, "install.sh")
    c.run(f"{install_script} {font_name}")


@task
def install_fonts(c, home_dir=common.HOME_DIR):
    for font_name in FONTS:
        install_font(c, font_name, home_dir=home_dir)


def nerd_fonts_dir_path(home_dir, mkdir=False):
    path = os.path.join(home_dir, ".local", "dotfiles", "nerd-fonts")
    if mkdir:
        os.makedirs(path, exist_ok=True)
    return path
