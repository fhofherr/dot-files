import os
import io
import shutil

from invoke import task

from dotfiles import common, logging, fs

_LOG = logging.get_logger(__name__)


@task
def configure(c, home_dir=common.HOME_DIR):
    bat_cmd = shutil.which("bat")
    if not bat_cmd:
        _LOG.warn("bat is not installed")
        return

    cfg_dir_path_buf = io.StringIO()
    c.run(f"{bat_cmd} --config-dir", out_stream=cfg_dir_path_buf)
    cfg_dir_path = cfg_dir_path_buf.getvalue().strip()
    cfg_dir_path_buf.close()

    bat_cfg_src = os.path.join(common.ROOT_DIR, "configs", "bat", "config")
    bat_cfg_dest = os.path.join(cfg_dir_path, "config")
    fs.safe_link_file(bat_cfg_src, bat_cfg_dest)
