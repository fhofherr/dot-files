import os
import platform
import shutil

from invoke import task

from dotfiles import common, git, logging

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    download(c, home_dir)


@task
def update(c, home_dir=common.HOME_DIR):
    download(c, home_dir)


@task
def download(c, home_dir=common.HOME_DIR):
    _LOG.info("Install git-bug")

    git_bug_cmd = cmd_path(home_dir, mkdir=True)

    with git.github_release("MichaelMure/git-bug") as gh_r:
        asset_name = f"git-bug_{_os()}_{_arch()}"
        asset = gh_r.download_asset(asset_name)
        shutil.copyfile(asset, git_bug_cmd)
        os.chmod(git_bug_cmd, 0o755)


def cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir), "git-bug")


def _os():
    return platform.system().lower()


def _arch():
    machine = platform.machine()
    if machine == "x86_64":
        return "amd64"
    return machine
