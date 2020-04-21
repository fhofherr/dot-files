from invoke import task

from dotfiles import common, logging
from dotfiles.tasks import pipx

_LOG = logging.get_logger(__name__)

DB_CLI_TOOLS = ["pgcli", "mycli"]


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install dbcli tools")
    for tool in DB_CLI_TOOLS:
        pipx.install_pkg(c, tool, home_dir=home_dir, warn=True)


@task
def update(c, home_dir=common.HOME_DIR):
    _LOG.info("Install dbcli tools")
    for tool in DB_CLI_TOOLS:
        pipx.upgrade_pkg(c, tool, home_dir=home_dir, warn=True)
