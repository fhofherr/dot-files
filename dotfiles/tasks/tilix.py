import io
import os
import shutil

from invoke import task

from dotfiles import common, fs, logging, state

_LOG = logging.get_logger(__name__)

TILIX_CFG_DUMP = os.path.join(common.ROOT_DIR, "configs", "tilix", "cfg_dump")
TILIX_VTE_FIX = """if [[ -n "$TILIX_ID" ]] || [[ -n "$VTE_VERSION" ]]
then
    [[ -f "/etc/profile.d/vte.sh" ]] && source /etc/profile.d/vte.sh
fi
"""


@task
def configure(c, home_dir=common.HOME_DIR):
    tilix_cmd = shutil.which("tilix")
    if not tilix_cmd:
        _LOG.warn("tilix is not installed")
        return

    tilix_cfg_dest = os.path.join(common.xdg_config_home(home_dir), "tilix")
    os.makedirs(tilix_cfg_dest, exist_ok=True)

    tilix_schemes_src = os.path.join(common.ROOT_DIR, "configs", "tilix",
                                     "schemes")
    tilix_schemes_dest = os.path.join(tilix_cfg_dest, "schemes")
    fs.safe_link_file(tilix_schemes_src, tilix_schemes_dest)

    tilix_state = state.State(name="tilix")
    tilix_state.after_compinit_script = TILIX_VTE_FIX
    state.write_state(home_dir, tilix_state)

    load_cfg(c, home_dir=home_dir)


@task
def load_cfg(c, home_dir=common.HOME_DIR):
    dconf_cmd = shutil.which("dconf")
    if not dconf_cmd:
        _LOG.warn("dconf not available")
        return
    with open(TILIX_CFG_DUMP, "r") as f:
        c.run(f"{dconf_cmd} load /com/gexperts/Tilix/", in_stream=f)


@task
def dump_cfg(c, home_dir=common.HOME_DIR):
    dconf_cmd = shutil.which("dconf")
    if not dconf_cmd:
        _LOG.warn("dconf not available")
        return
    with open(TILIX_CFG_DUMP, "w") as f:
        c.run(f"{dconf_cmd} dump /com/gexperts/Tilix/", out_stream=f)
