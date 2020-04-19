import os
import shutil

from invoke import task

from dotfiles import common, fs, logging, state

_LOG = logging.get_logger(__name__)


@task
def configure(c, home_dir=common.HOME_DIR):
    _LOG.info("Configure alacritty")

    alacritty_cmd = shutil.which("alacritty")
    if not alacritty_cmd:
        _LOG.warn("alacritty not installed")
        return
    alacritty_cfg_src = os.path.join(common.ROOT_DIR, "configs", "alacritty",
                                     "alacritty.yml")
    alacritty_cfg_dest = os.path.join(common.xdg_config_home(home_dir),
                                      "alacritty", "alacritty.yml")
    fs.safe_link_file(alacritty_cfg_src, alacritty_cfg_dest)

    alacritty_state = state.State(name="alacritty")
    alacritty_state.add_alias("ssh", f"TERM=xterm-256color ssh")
    state.write_state(home_dir, alacritty_state)
