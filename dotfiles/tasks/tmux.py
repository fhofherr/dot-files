import os
import shutil

from invoke import task

from dotfiles import common, git, fs, logging, state

TPM_REMOTE_REPO = "https://github.com/tmux-plugins/tpm"

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    tmux_cmd = shutil.which("tmux")
    if not tmux_cmd:
        _LOG.warn("tmux is not installed")
        return

    tpm_dir = _install_tpm(c, home_dir)
    _link_tmux_conf(c, home_dir)
    _create_terminfo(c, home_dir)

    plugin_installer = os.path.join(tpm_dir, "bindings", "install_plugins")
    with c.cd(home_dir):
        c.run("tmux new-session -s tmux-install -d")
        c.run(f"tmux run-shell {plugin_installer}")
        c.run("tmux kill-session -t tmux-install")

    tmux_state = state.State(name="tmux")

    tmux_state.add_alias("tls", "tmux ls")
    tmux_state.add_alias("tns", "_tmux_new_session")
    tmux_state.add_alias("tks", "tmux kill-session -t")
    tmux_state.add_alias("tnsp", "_tmux_new_project_session")
    tmux_state.add_alias("tnsd", "tmux new-session -d -s")
    tmux_state.add_alias("tnw", "tmux new-window")
    tmux_state.add_alias("tss", "tmux switch-client -t")
    tmux_state.add_alias("tas", "tmux attach -t")

    after_compinit = os.path.join(common.ROOT_DIR, "configs", "tmux",
                                  "after_compinit.zsh")
    with open(after_compinit) as f:
        tmux_state.after_compinit_script = f.read()

    state.write_state(home_dir, tmux_state)


def _create_terminfo(c, home_dir=common.HOME_DIR):
    _LOG.info("create tmux terminfo")
    terminfo = os.path.join(common.ROOT_DIR, "configs", "tmux",
                            "tmux.terminfo")
    result = c.run("infocmp tmux-256color", hide="both")
    if result.exited > 0:
        c.run(f"tic -x ${terminfo}")


def _install_tpm(c, home_dir=common.HOME_DIR):
    _LOG.info("install tpm")
    plugin_dir = _tmux_plugin_dir(home_dir, create=True)
    tpm_dir = os.path.join(plugin_dir, "tpm")
    cloned = git.clone(c, TPM_REMOTE_REPO, tpm_dir)
    if not cloned:
        with c.cd(tpm_dir):
            c.run("git pull")
    return tpm_dir


def _link_tmux_conf(c, home_dir=common.HOME_DIR):
    _LOG.info("link tmux.conf")
    tmux_conf_src = os.path.join(common.ROOT_DIR, "configs", "tmux",
                                 "tmux.conf")
    tmux_conf_dest = os.path.join(home_dir, ".tmux.conf")
    fs.safe_link_file(tmux_conf_src, tmux_conf_dest)


def _tmux_dir(home_dir, create=False):
    tmux_dir = os.path.join(home_dir, ".tmux")
    if create:
        os.makedirs(tmux_dir, exist_ok=True)
    return tmux_dir


def _tmux_plugin_dir(home_dir, create=False):
    tmux_dir = _tmux_dir(home_dir, create=create)
    plugin_dir = os.path.join(tmux_dir, "plugins")
    if create:
        os.makedirs(plugin_dir, exist_ok=True)
    return plugin_dir
