from invoke import task

from dotfiles import common, logging
from dotfiles.tasks import pipx

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install httpie")
    pipx.install_pkg(c, "httpie", home_dir=home_dir)


@task
def update(c, home_dir=common.HOME_DIR):
    _LOG.info("Install httpie")
    pipx.upgrade_pkg(c, "httpie", home_dir=home_dir)
