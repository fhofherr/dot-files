from invoke import task

from dotfiles import common, logging
from dotfiles.tasks import pipx

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install pre-commit")
    pipx.install_pkg(c, "pre-commit", home_dir=home_dir)
