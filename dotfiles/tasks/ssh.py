import os
import textwrap

from invoke import task

from dotfiles import common, logging, state

_LOG = logging.get_logger(__name__)


@task
def configure(c, home_dir=common.HOME_DIR):
    ssh_cfg_file = os.path.join(home_dir, ".ssh", "config")
    ssh_cfg = ""
    if os.path.exists(ssh_cfg_file):
        with open(ssh_cfg_file, "r") as f:
            ssh_cfg = f.read()

    common_ssh_cfg_file = os.path.join(common.ROOT_DIR, "configs", "ssh",
                                       "ssh_config.common")
    if common_ssh_cfg_file not in ssh_cfg:
        ssh_cfg = f"Include {common_ssh_cfg_file}\n\n{ssh_cfg}"

    with open(ssh_cfg_file, "w") as f:
        f.write(ssh_cfg)

    ssh_utils_bin = os.path.join(common.ROOT_DIR, "configs", "ssh", "bin")
    ssh_state = state.State(name="ssh")
    ssh_state.after_compinit_script = textwrap.dedent(f"""
    # Identities remain added for 12h. This should be enough for the average
    # working day.
    source <({ssh_utils_bin}/ssh_start_agent -t {3600 * 12} -p 2> "$HOME"/.ssh/start_agent.log)
    """)
    ssh_state.put_env("PATH", ssh_utils_bin)

    state.write_state(home_dir, ssh_state)
