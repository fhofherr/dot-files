import os

from invoke import task

from dotfiles import common, logging, state
from dotfiles.tasks import pipx

_LOG = logging.get_logger(__name__)

DEV_TOOLS = ["python-language-server", "python-language-server[rope]"]


@task
def install(c, home_dir=common.HOME_DIR, install_missing_poetry=False):
    poetry_cmd = poetry_cmd_path(home_dir)
    if not os.path.exists(poetry_cmd):
        if not install_missing_poetry:
            _LOG.info("Poetry not found and --install-missing-poetry=False")
            return
        install_poetry(c, home_dir)
    configure_poetry(c, home_dir)
    install_dev_tools(c, home_dir)


@task
def install_poetry(c, home_dir=common.HOME_DIR):
    raise NotImplementedError


@task
def configure_poetry(c, home_dir=common.HOME_DIR):
    poetry_state = state.State("python_poetry")
    poetry_state.put_env("PATH", poetry_bin_dir_path(home_dir))
    state.write_state(home_dir, poetry_state)


@task
def install_dev_tools(c, home_dir=common.HOME_DIR):
    _LOG.info("Install python development tools")
    for tool in DEV_TOOLS:
        pipx.install_pkg(c, tool, home_dir=home_dir)


def poetry_bin_dir_path(home_dir, mkdir=False):
    poetry_bin_dir = os.path.join(home_dir, ".poetry", "bin")
    if mkdir:
        os.makedirs(poetry_bin_dir, exist_ok=True)
    return poetry_bin_dir


def poetry_cmd_path(home_dir, mkdir=False):
    return os.path.join(poetry_bin_dir_path(home_dir, mkdir=mkdir), "poetry")
