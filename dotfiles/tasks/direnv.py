import io
import os
import platform
import shutil

from invoke import task

from dotfiles import common, fs, git, logging, state

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install direnv")

    download(c, home_dir)
    configure(c, home_dir)


@task
def download(c, home_dir=common.HOME_DIR):
    direnv_cmd = cmd_path(home_dir, mkdir=True)
    with git.github_release("direnv/direnv") as gh_r:
        asset = gh_r.download_asset(f"direnv.{_os()}-{_arch()}")
        shutil.copyfile(asset, direnv_cmd)
        os.chmod(direnv_cmd, 0o755)


@task
def configure(c, home_dir=common.HOME_DIR):
    direnv_cmd = cmd_path(home_dir)
    direnvrc_src = os.path.join(common.ROOT_DIR, "configs", "direnv",
                                "direnvrc")
    direnvrc_dest = os.path.join(config_dir_path(home_dir), "direnvrc")
    fs.safe_link_file(direnvrc_src, direnvrc_dest)

    direnv_state = state.State(name="direnv")
    direnv_state.put_env("PATH", common.bin_dir(home_dir))

    direnv_zsh_hook = io.StringIO()
    c.run(f"{direnv_cmd} hook zsh", out_stream=direnv_zsh_hook)
    direnv_state.after_compinit_script = direnv_zsh_hook.getvalue()
    direnv_zsh_hook.close()

    state.write_state(home_dir, direnv_state)


def _os():
    return platform.system().lower()


def _arch():
    arch = platform.machine().lower()
    if arch == "x86_64":
        arch = "amd64"
    return arch


def cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir), "direnv")


def config_dir_path(home_dir):
    return os.path.join(common.xdg_config_home(home_dir), "direnv")
