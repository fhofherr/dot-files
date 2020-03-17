import os
import io
import platform
import tempfile
import tarfile

from invoke import task

from dotfiles import common, git, logging, state, chksum

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    _LOG.info("Install antibody")

    download(c, home_dir)
    configure(c, home_dir)


@task
def download(c, home_dir=common.HOME_DIR):
    antibody_cmd = cmd_path(home_dir, mkdir=True)
    with git.github_release("getantibody/antibody") as gh_r:
        asset_name = f"antibody_{_os()}_{_arch()}.tar.gz"
        asset = gh_r.download_asset(asset_name)

        sha_sums = gh_r.download_asset("antibody_*_checksums.txt")
        chksum.verify_sha256_file(asset, asset_name, sha_sums)

        prefix = "dotfiles-install-antibody-"
        with tempfile.TemporaryDirectory(prefix=prefix) as tmpdir, \
                c.cd(tmpdir), \
                tarfile.open(asset) as tf:

            with tf.extractfile("antibody") as src, \
                    open(antibody_cmd, "wb") as dest:
                dest.write(src.read())
            os.chmod(antibody_cmd, 0o755)


@task
def configure(c, home_dir=common.HOME_DIR):
    zsh_plugins_txt = os.path.join(common.ROOT_DIR, "configs", "antibody",
                                   "zsh_plugins.txt")
    antibody_cmd = cmd_path(home_dir)

    antibody_state = state.State("antibody")
    init_out = io.StringIO()
    try:
        with open(zsh_plugins_txt) as f:
            c.run(f"{antibody_cmd} bundle", in_stream=f, out_stream=init_out)
        antibody_state.after_compinit_script = init_out.getvalue()
    finally:
        init_out.close()

    state.write_state(home_dir, antibody_state)


def _os():
    return platform.system()


def _arch():
    return platform.machine()


def cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir), "antibody")
