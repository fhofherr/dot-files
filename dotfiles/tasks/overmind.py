import gzip
import os
import platform

from invoke import task

from dotfiles import common, git, logging, state

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install overmind")
    download(c, home_dir)
    configure(c, home_dir)


@task
def download(c, home_dir=common.HOME_DIR):
    overmind_cmd = cmd_path(home_dir, mkdir=True)
    with git.github_release("DarthSim/overmind") as gh_r:
        asset = gh_r.download_asset(f"overmind-*-{_os()}-{_arch()}.gz")
        with gzip.open(asset) as gz_f:
            with open(overmind_cmd, "wb") as bin_f:
                bin_f.write(gz_f.read())
        os.chmod(overmind_cmd, 0o755)


@task
def configure(c, home_dir=common.HOME_DIR):
    overmind_state = state.State(name="overmind")
    overmind_state.put_env("PATH", common.bin_dir(home_dir))
    state.write_state(home_dir, overmind_state)


def cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir), "overmind")


def _os():
    return platform.system().lower()


def _arch():
    arch = platform.machine().lower()
    if arch == "x86_64":
        arch = "amd64"
    return arch
