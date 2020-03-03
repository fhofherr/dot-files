import os

from invoke import task

from dotfiles import common, fs


@task
def configure(c, home_dir=common.HOME_DIR):
    editorconfig_src = os.path.join(common.ROOT_DIR, ".editorconfig")
    editorconfig_dest = os.path.join(home_dir, ".editorconfig")
    fs.safe_link_file(editorconfig_src, editorconfig_dest)
