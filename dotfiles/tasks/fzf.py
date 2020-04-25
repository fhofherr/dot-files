import os

from invoke import task

from dotfiles import common, git, logging

REPO_URL = "https://github.com/junegunn/fzf"

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    clone_or_update(c, home_dir=home_dir)

    fzf_repo_dir = dest_dir(home_dir)
    with c.cd(fzf_repo_dir):
        c.run(f"./install --all --no-update-rc")


@task
def update(c, home_dir=common.HOME_DIR):
    install(c, home_dir=common.HOME_DIR)


@task
def clone_or_update(c, home_dir=common.HOME_DIR):
    _LOG.info("Clone or update fzf")

    fzf_repo_dir = dest_dir(home_dir)

    cloned = git.clone(c, REPO_URL, fzf_repo_dir)
    if not cloned:
        with c.cd(fzf_repo_dir):
            c.run(f"git pull --prune")


def dest_dir(home_dir):
    return os.path.join(home_dir, "Projects", "github.com", "junegunn", "fzf")
