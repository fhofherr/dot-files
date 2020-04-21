from invoke import task

from dotfiles import logging, common
from dotfiles.tasks import pipx

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install platformio")
    pipx.install_pkg(c, "platformio", home_dir=home_dir)


@task
def update(c, home_dir=common.HOME_DIR):
    pipx.upgrade_pkg(c, "platformio", home_dir=home_dir)
