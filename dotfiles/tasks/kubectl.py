import io
import shutil

from invoke import task

from dotfiles import common, logging, state

_LOG = logging.get_logger(__name__)


@task
def configure(c, home_dir=common.HOME_DIR):
    _LOG.info("Configure kuebctl")

    kubectl_cmd = shutil.which("kubectl")
    if not kubectl_cmd:
        _LOG.warn("kubectl not installed")
        return

    kubectl_state = state.State(name="kubectl")

    kubectl_zsh_hook = io.StringIO()
    c.run(f"{kubectl_cmd} completion zsh", out_stream=kubectl_zsh_hook)

    kubectl_state.after_compinit_script = kubectl_zsh_hook.getvalue()
    kubectl_state.add_alias("k", kubectl_cmd)

    state.write_state(home_dir, kubectl_state)
