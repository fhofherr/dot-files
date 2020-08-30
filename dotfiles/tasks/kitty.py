import os
import shutil

from invoke import task

from dotfiles import common, fs, logging, state

_LOG = logging.get_logger(__name__)


@task
def configure(c, home_dir=common.HOME_DIR):
    _LOG.info("Configure kitty")

    kitty_cmd = shutil.which("kitty")
    if not kitty_cmd:
        _LOG.warn("kitty not installed")
        return
    kitty_cfg_src = os.path.join(common.ROOT_DIR, "configs", "kitty",
                                 "kitty.conf")
    kitty_cfg_dest = os.path.join(common.xdg_config_home(home_dir), "kitty",
                                  "kitty.conf")
    fs.safe_link_file(kitty_cfg_src, kitty_cfg_dest)

    kitty_state = state.State(name="kitty")
    kitty_state.add_alias("kssh", f"{kitty_cmd} +kitten ssh")
    state.write_state(home_dir, kitty_state)
