import os
import platform
import tarfile
import tempfile

from invoke import task

from dotfiles import chksum, common, git, logging, state

_LOG = logging.get_logger(__name__)


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
    _LOG.info("Install golangci-lint")

    with git.github_release("golangci/golangci-lint") as gh_r:
        sha_sums = gh_r.download_asset("golangci-lint-*-checksums.txt")
        asset = gh_r.download_asset(
            f"golangci-lint-*-{_os()}-{_arch()}.tar.gz")
        asset_name = os.path.basename(asset)
        chksum.verify_sha256_file(asset, asset_name, sha_sums)

        golangci_lint_cmd = cmd_path(home_dir)
        with tempfile.TemporaryDirectory(
                prefix="dotfiles-install-golangci-lint") as tmpdir, \
                c.cd(tmpdir), \
                tarfile.open(asset) as tf:

            tar_dir = asset_name.replace(".tar.gz", "")
            with tf.extractfile(f"{tar_dir}/golangci-lint") as src, \
                    open(golangci_lint_cmd, "wb") as dest:
                dest.write(src.read())
            os.chmod(golangci_lint_cmd, 0o755)


@task
def configure(c, home_dir=common.HOME_DIR):
    golangci_lint_state = state.State(name="golangci_lint")
    golangci_lint_state.put_env("PATH", common.bin_dir(home_dir))

    state.write_state(home_dir, golangci_lint_state)


def cmd_path(home_dir, mkdir=False):
    return os.path.join(common.bin_dir(home_dir, mkdir=mkdir), "golangci-lint")


def _os():
    return platform.system().lower()


def _arch():
    arch = platform.machine().lower()
    if arch == "x86_64":
        arch = "amd64"
    return arch
