import os
import venv

from invoke import task

from dotfiles import common, logging, state

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install pipx")
    install_pipx(c, home_dir)
    configure(c, home_dir)


@task
def install_pipx(c, home_dir=common.HOME_DIR):
    pipx_venv_dir = venv_dir_path(home_dir, mkdir=True, recreate=True)
    pipx_venv_python = venv_python_path(home_dir)
    with c.cd(pipx_venv_dir):
        c.run(f"{pipx_venv_python} -m pip install --upgrade pip",
              hide="stdout")
        c.run(f"{pipx_venv_python} -m pip install pipx")


@task
def configure(c, home_dir=common.HOME_DIR):
    pipx_bin_dir = bin_dir_path(home_dir, mkdir=True)
    pipx_cmd = cmd_path(home_dir)

    pipx_state = state.State(name="pipx")
    pipx_state.env.update(env(home_dir, mkdir=True))
    pipx_state.put_env("PATH", pipx_bin_dir)

    pipx_state.add_alias("pipx", pipx_cmd)

    state.write_state(home_dir, pipx_state)


@task
def install_pkg(c,
                pkg,
                home_dir=common.HOME_DIR,
                warn=False,
                system_site_packages=False):
    pipx_cmd = cmd_path(home_dir)
    if not os.path.exists(pipx_cmd):
        install(c, home_dir=home_dir)

    args = []
    if system_site_packages:
        args.append("--system-site-packages")
    c.run(f"{pipx_cmd} install {' '.join(args)} {pkg}",
          env=env(home_dir),
          warn=warn)


@task
def upgrade_pkg(c, pkg, home_dir=common.HOME_DIR, warn=False):
    pipx_cmd = cmd_path(home_dir)
    if not os.path.exists(pipx_cmd):
        install(c, home_dir=home_dir)
    c.run(f"{pipx_cmd} upgrade {pkg}", env=env(home_dir), warn=warn)


def venv_dir_path(home_dir, mkdir=False, recreate=False):
    venv_dir = os.path.join(home_dir, ".local", "dotfiles", "pipx.venv")
    if mkdir and (not os.path.exists(venv_dir) or recreate):
        venv.create(venv_dir, clear=recreate, with_pip=True)
    return venv_dir


def venv_bin_dir_path(home_dir, mkdir=False, recreate=False):
    venv_dir = venv_dir_path(home_dir, mkdir=mkdir, recreate=recreate)
    return os.path.join(venv_dir, "bin")


def venv_python_path(home_dir, mkdir=False, recreate=False):
    bin_dir = venv_bin_dir_path(home_dir, mkdir=mkdir, recreate=recreate)
    return os.path.join(bin_dir, "python3")


def cmd_path(home_dir, mkdir=False, recreate=False):
    bin_dir = venv_bin_dir_path(home_dir, mkdir=mkdir, recreate=recreate)
    return os.path.join(bin_dir, "pipx")


def bin_dir_path(home_dir, mkdir=False):
    bin_dir = os.path.join(home_dir, ".local", "dotfiles", "tools", "pipx.bin")
    if mkdir:
        os.makedirs(bin_dir, exist_ok=True)
    return bin_dir


def home_dir_path(home_dir, mkdir=False):
    home_dir = os.path.join(home_dir, ".local", "dotfiles", "tools",
                            "pipx.home")
    if mkdir:
        os.makedirs(home_dir, exist_ok=True)
    return home_dir


def env(home_dir, mkdir=False):
    return {
        "PIPX_HOME": home_dir_path(home_dir, mkdir=mkdir),
        "PIPX_BIN_DIR": bin_dir_path(home_dir, mkdir=mkdir)
    }
