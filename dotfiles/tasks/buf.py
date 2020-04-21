import os
import platform
import tarfile
import tempfile

from invoke import task

from dotfiles import chksum, common, git, logging, state

_LOG = logging.get_logger(__name__)

# Buf does not have an official "latest" release yet. Therefore we use
# an explicit version number.
VERSION = "v0.7.1"


@task
def install(c, home_dir=common.HOME_DIR):
    download(c, home_dir)
    configure(c, home_dir)


@task
def update(c, home_dir=common.HOME_DIR, reconfigure=False):
    download(c, home_dir)
    if reconfigure:
        configure(c, home_dir)


@task
def download(c, home_dir=common.HOME_DIR):
    _LOG.info("Install buf")

    buf_cmd = cmd_path(home_dir, mkdir=True)
    check_breaking_cmd = check_breaking_cmd_path(home_dir, mkdir=True)
    check_lint_cmd = check_lint_cmd_path(home_dir, mkdir=True)

    with git.github_release("bufbuild/buf", version=VERSION) as gh_r:
        asset_name = f"buf-{_os()}-{_arch()}.tar.gz"

        sha_sums = gh_r.download_asset("sha256.txt")
        asset = gh_r.download_asset(asset_name)
        chksum.verify_sha256_file(asset, asset_name, sha_sums)

        prefix = "dotfiles-install-buf-"
        with tempfile.TemporaryDirectory(prefix=prefix) as tmpdir, \
                c.cd(tmpdir), \
                tarfile.open(asset) as tf:

            with tf.extractfile("buf/bin/buf") as src, \
                    open(buf_cmd, "wb") as dest:
                dest.write(src.read())
            os.chmod(buf_cmd, 0o755)

            with tf.extractfile("buf/bin/protoc-gen-buf-check-breaking") as src, \
                    open(check_breaking_cmd, "wb") as dest:
                dest.write(src.read())
            os.chmod(check_breaking_cmd, 0o755)

            with tf.extractfile("buf/bin/protoc-gen-buf-check-lint") as src, \
                    open(check_lint_cmd, "wb") as dest:
                dest.write(src.read())
            os.chmod(check_lint_cmd, 0o755)


@task
def configure(c, home_dir=common.HOME_DIR):
    buf_state = state.State("buf")

    with git.github_release("bufbuild/buf", version=VERSION) as gh_r:
        asset_name = f"buf-{_os()}-{_arch()}.tar.gz"

        sha_sums = gh_r.download_asset("sha256.txt")
        asset = gh_r.download_asset(asset_name)
        chksum.verify_sha256_file(asset, asset_name, sha_sums)

        prefix = "dotfiles-cgf-buf"
        with tempfile.TemporaryDirectory(prefix=prefix) as tmpdir, \
                c.cd(tmpdir), \
                tarfile.open(asset) as tf:
            with tf.extractfile("buf/etc/zsh/site-functions/_buf") as cmps:
                buf_state.after_compinit_script = cmps.read().decode("utf-8")

        buf_state.put_env("PATH", common.bin_dir(home_dir))
        state.write_state(home_dir, buf_state)


def cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir), "buf")


def check_breaking_cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir),
                        "protoc-gen-buf-check-breaking")


def check_lint_cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir),
                        "protoc-gen-buf-check-lint")


def _os():
    return platform.system()


def _arch():
    return platform.machine()
