import os
import shutil
import tempfile

from invoke import task

from dotfiles import common, logging, state
from dotfiles.tasks import asdf

_LOG = logging.get_logger(__name__)

# Go develpment tools available under golang.org only
OFFICIAL_DEV_TOOLS = [
    "golang.org/x/lint/golint@latest",
    "golang.org/x/tools/cmd/godoc@latest",
    "golang.org/x/tools/cmd/goimports@latest",
    "golang.org/x/tools/cmd/stringer@latest",
    "golang.org/x/tools/gopls@latest",
]

THIRD_PARTY_DEV_TOOLS = [
    "github.com/go-delve/delve/cmd/dlv@latest",
    "github.com/aarzilli/gdlv@latest",
    "github.com/psampaz/go-mod-outdated@latest",
    "github.com/fatih/gomodifytags@latest",
    "github.com/goreleaser/goreleaser"
]


@task
def install(c, home_dir=common.HOME_DIR, install_missing_go=False):
    go_cmd = shutil.which("go")
    if not go_cmd:
        if not install_missing_go:
            _LOG.warn("go not installed and --install-missing-go=False")
            return
        asdf.install_golang(c, home_dir)
        go_cmd = asdf.tool_cmd_path(c, "go", home_dir)
    _LOG.info("Install golang development tools")
    install_dev_tools(c, home_dir, go_cmd)
    configure(c, home_dir)


@task
def install_dev_tools(c, home_dir=common.HOME_DIR, go_cmd="go"):
    go_bin = _go_bin_dir(home_dir, mkdir=True)
    for repo in OFFICIAL_DEV_TOOLS:
        _go_get(c, repo, go_bin=go_bin, go_cmd=go_cmd)
    for repo in THIRD_PARTY_DEV_TOOLS:
        _go_get(c, repo, go_bin=go_bin, go_cmd=go_cmd)


@task
def update_dev_tools(c, home_dir=common.HOME_DIR, go_cmd="go"):
    install_dev_tools(c, home_dir=home_dir, go_cmd=go_cmd)


@task
def configure(c, home_dir=common.HOME_DIR):
    go_tools_state = state.State(name="go_tools")
    go_tools_state.put_env("PATH", _go_bin_dir(home_dir))

    golang_after_compinit = os.path.join(common.ROOT_DIR, "configs", "golang",
                                         "after_compinit.zsh")
    with open(golang_after_compinit) as f:
        go_tools_state.after_compinit_script = f.read()

    state.write_state(home_dir, go_tools_state)


def _go_bin_dir(home_dir, mkdir=False):
    return common.bin_dir(home_dir, mkdir=mkdir)


def _go_get(c, repo, go_mod=True, go_bin=None, go_cmd="go"):
    env = {}
    if go_mod:
        env["GO111MODULE"] = "on"
    if go_bin:
        env["GOBIN"] = go_bin
    with tempfile.TemporaryDirectory(prefix="dotfiles-go-get-") as tmpdir:
        with c.cd(tmpdir):
            c.run(f"{go_cmd} get {repo}", env=env)
