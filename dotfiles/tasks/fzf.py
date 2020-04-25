import os
import textwrap

from invoke import task

from dotfiles import common, git, logging, state

REPO_URL = "https://github.com/junegunn/fzf"

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    download(c, home_dir=home_dir)
    configure(c, home_dir=home_dir)


@task
def update(c, home_dir=common.HOME_DIR, reconfigure=False):
    install(c, home_dir=common.HOME_DIR)
    if reconfigure:
        configure(c, home_dir=home_dir)


@task
def configure(c, home_dir=common.HOME_DIR):
    fzf_state = state.State(name="fzf")

    fzf_state.put_env(
        "FZF_CTRL_T_OPTS",
        "--preview 'bat --style=numbers,changes  --line-range=:15 --color always {} 2> /dev/null'"
    )

    zsh_init_file = os.path.join(home_dir, ".fzf.zsh")
    if os.path.exists(zsh_init_file):
        with open(zsh_init_file) as f:
            fzf_state.after_compinit_script = f.read()

    fzf_state.after_compinit_script = textwrap.dedent(f"""
    {fzf_state.after_compinit_script}

    bindkey '^P' fzf-file-widget
    """)

    state.write_state(home_dir, fzf_state)


def download(c, home_dir=common.HOME_DIR):
    clone_or_update(c, home_dir=home_dir)

    fzf_repo_dir = dest_dir(home_dir)
    with c.cd(fzf_repo_dir):
        c.run(f"./install --all --no-update-rc")


def clone_or_update(c, home_dir=common.HOME_DIR):
    _LOG.info("Clone or update fzf")

    fzf_repo_dir = dest_dir(home_dir)

    cloned = git.clone(c, REPO_URL, fzf_repo_dir)
    if not cloned:
        with c.cd(fzf_repo_dir):
            c.run(f"git pull --prune")


def dest_dir(home_dir):
    return os.path.join(home_dir, "Projects", "github.com", "junegunn", "fzf")
