import io
import os
import platform
import tarfile
import tempfile

from invoke import task

from dotfiles import chksum, common, fs, git, logging, state

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    install_starship_prompt(c, home_dir)
    configure_starship_prompt(c, home_dir)
    configure(c, home_dir)


@task
def configure(c, home_dir=common.HOME_DIR):
    cfg_files = [("zprofile", ".zprofile"), ("zshenv", ".zshenv"),
                 ("zshrc", ".zshrc")]
    cfg_files = [(os.path.join(common.ROOT_DIR, "configs", "zsh",
                               src), os.path.join(home_dir, dest))
                 for src, dest in cfg_files]
    for src, dest in cfg_files:
        fs.safe_link_file(src, dest)

    zsh_state = state.State(name="zsh")

    zsh_after_compinit_script = os.path.join(common.ROOT_DIR, "configs", "zsh",
                                             "after_compinit.zsh")
    with open(zsh_after_compinit_script) as f:
        zsh_state.after_compinit = f.read()

    state.write_state(home_dir, zsh_state)


@task
def install_starship_prompt(c, home_dir=common.HOME_DIR):
    _LOG.info("Install starship prompt")

    machine = platform.machine()
    if machine != "x86_64":
        _LOG.warn("Starship prompt not available for {machine}")
        return

    system = platform.system().lower()
    if system == "linux":
        libc, _ = platform.libc_ver()
        if libc == "glibc":
            system = "unknown-linux-gnu"
        else:
            system = "unknown-linux-musl"
    elif system == "darwin":
        system = "apple-darwin"
    else:
        _LOG.warn("unsupported system {system}")

    with git.github_release("starship/starship") as gh_r:
        sha_sums = gh_r.download_asset(
            f"starship-{machine}-{system}.tar.gz.sha256")
        asset = gh_r.download_asset(f"starship-{machine}-{system}.tar.gz")

        with open(sha_sums) as f:
            chksum.verify_sha256(asset, f.read().strip())

        starship_cmd = starship_cmd_path(home_dir, mkdir=True)
        with tempfile.TemporaryDirectory(
                prefix="dotfiles-install-starship") as tmpdir, \
                c.cd(tmpdir), \
                tarfile.open(asset) as tf:

            with tf.extractfile(f"starship") as src, \
                    open(starship_cmd, "wb") as dest:
                dest.write(src.read())
            os.chmod(starship_cmd, 0o755)


@task
def configure_starship_prompt(c, home_dir=common.HOME_DIR):
    starship_toml_src = os.path.join(common.ROOT_DIR, "configs", "starship",
                                     "starship.toml")
    starship_toml_dest = os.path.join(common.xdg_config_home(home_dir),
                                      "starship.toml")
    fs.safe_link_file(starship_toml_src, starship_toml_dest)

    starship_cmd = starship_cmd_path(home_dir)
    starship_state = state.State(name="starship")

    starship_zsh_hook = io.StringIO()
    c.run(f"{starship_cmd} init zsh --print-full-init",
          out_stream=starship_zsh_hook)
    starship_state.after_compinit_script = starship_zsh_hook.getvalue()

    starship_state.put_env("PATH", os.path.dirname(starship_cmd))
    state.write_state(home_dir, starship_state)


@task
def write_dotfiles_zsh_config(c, home_dir=common.HOME_DIR):
    zsh_local_settings_dir = local_settings_dir_path(home_dir, mkdir=True)

    zsh_local_env_file = os.path.join(zsh_local_settings_dir, "env.zsh")
    zsh_local_aliases_file = os.path.join(zsh_local_settings_dir,
                                          "aliases.zsh")
    zsh_after_compinit_script = os.path.join(zsh_local_settings_dir,
                                             "after_compinit.zsh")

    complete_state = state.load_all(home_dir)
    complete_state.write_env(zsh_local_env_file)
    complete_state.write_aliases(zsh_local_aliases_file)
    complete_state.write_after_compinit_script(zsh_after_compinit_script)

    zsh_dotfiles_init_file = os.path.join(home_dir, ".zsh_dotfiles_init")
    with open(zsh_dotfiles_init_file, "w") as f:
        f.write("# File auto-generated; DO NOT EDIT\n\n")
        f.write(f"DOTFILES_ZSH_LOCAL_ENV={zsh_local_env_file}\n")
        f.write(f"DOTFILES_ZSH_LOCAL_ALIASES={zsh_local_aliases_file}\n")
        f.write(
            f"DOTFILES_ZSH_AFTER_COMPINIT_SCRIPT={zsh_after_compinit_script}\n"
        )
        f.write(f"export DOTFILES_ZSH_DID_INIT=1")


def starship_cmd_path(home_dir, mkdir=True):
    bin_dir = common.bin_dir(home_dir, mkdir=mkdir)
    return os.path.join(bin_dir, "starship")


def local_settings_dir_path(home_dir, mkdir=False):
    path = os.path.join(home_dir, ".local", "dotfiles", "zsh")
    if mkdir:
        os.makedirs(path, exist_ok=True)
    return path
