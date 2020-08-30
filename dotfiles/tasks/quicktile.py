import os

from invoke import task

from dotfiles import common, fs, logging
from dotfiles.tasks import pipx

_LOG = logging.get_logger(__name__)

QUICKTILE_URL = "https://github.com/ssokolow/quicktile/archive/master.zip"
QUICKTIILE_DESKTOP_ENTRY_TMPL = """[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=Quicktile
Comment=
Exec=sh -c "sleep 1 && {quicktile_cmd} --daemonize"
StartupNotify=false
Terminal=false
Hidden=false
"""

# Note: needs python-gobject library.
#       Install with pacman -S python-gobject on arch/manjaro


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install quicktile")
    pipx.install_pkg(c,
                     QUICKTILE_URL,
                     home_dir=home_dir,
                     system_site_packages=True)

    cfg_src = os.path.join(common.ROOT_DIR, "configs", "quicktile",
                           "quicktile.cfg")
    cfg_dest = os.path.join(common.xdg_config_home(home_dir), "quicktile.cfg")
    fs.safe_link_file(cfg_src, cfg_dest)

    quicktile_cmd = os.path.join(pipx.bin_dir_path(home_dir, mkdir=False),
                                 "quicktile")
    desktop_file_path = os.path.join(common.xdg_config_home(home_dir),
                                     "autostart", "quicktile.desktop")
    desktop_file_data = QUICKTIILE_DESKTOP_ENTRY_TMPL.format(
        quicktile_cmd=quicktile_cmd)
    with open(desktop_file_path, "w") as f:
        f.write(desktop_file_data)


@task
def update(c, home_dir=common.HOME_DIR):
    pipx.upgrade_pkg(c, "QuickTile", home_dir=home_dir)
