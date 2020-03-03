import os
import re
import io
import shutil

from invoke import task

from dotfiles import common, git, logging, state

REPO_URL = "https://github.com/asdf-vm/asdf.git"
TOOL_VERSIONS = os.path.join(common.ROOT_DIR, ".tool-versions.default")

_LOG = logging.get_logger(__name__)


@task
def install(c, home_dir=common.HOME_DIR):
    clone_or_update(c, home_dir)
    configure(c, home_dir)


@task
def clone_or_update(c, home_dir=common.HOME_DIR):
    _LOG.info("Clone or update asdf")

    asdf_dir = dest_dir(home_dir)
    asdf_cmd = cmd_path(home_dir)

    cloned = git.clone(c, REPO_URL, asdf_dir)
    if not cloned:
        c.run(f"{asdf_cmd} update")

    plugins = parse_tool_versions(TOOL_VERSIONS)
    for plugin in plugins.keys():
        _LOG.info(f"Install asdf plugin: {plugin}")
        c.run(f"{asdf_cmd} plugin add {plugin}", warn=True)
    with c.cd(home_dir):
        c.run(f"{asdf_cmd} install", warn=True)


@task
def configure(c, home_dir=common.HOME_DIR):
    asdf_cmd = cmd_path(home_dir)
    asdf_dir = dest_dir(home_dir)

    tool_versions = os.path.join(home_dir, ".tool-versions")
    if not os.path.exists(tool_versions):
        # Copy and don't link as we might want to change it
        shutil.copy(TOOL_VERSIONS, tool_versions)

    asdf_state = state.State(name="asdf")
    asdf_state.put_env("PATH", os.path.dirname(asdf_cmd))
    asdf_state.put_env("ASDF_DATA_DIR", asdf_dir)

    asdf_zsh_init_file = os.path.join(asdf_dir, "asdf.sh")
    with open(asdf_zsh_init_file) as f:
        script = f.read()
        script = re.sub(r"^ASDF_DIR=.+$",
                        f'\nASDF_DIR="{asdf_dir}"\n',
                        script,
                        flags=re.MULTILINE)
        asdf_state.after_compinit_script = script

    state.write_state(home_dir, asdf_state)


@task
def install_golang(c, home_dir=common.HOME_DIR, version="latest"):
    asdf_cmd = cmd_path(home_dir)
    if not os.path.exists(asdf_cmd):
        install(c, home_dir)

    asdf_plugins = _list_plugins(c, home_dir)
    if "golang" not in asdf_plugins:
        c.fun(f"{asdf_cmd} plugin add golang")
    if version == "latest":
        version = _latest_go_version(c, home_dir)

    env = _tmp_asdf_env(asdf_cmd)
    c.run(f"{asdf_cmd} install golang {version}", env=env)
    c.run(f"{asdf_cmd} global golang {version}", env=env)


def tool_cmd_path(c, tool, home_dir):
    asdf_cmd = cmd_path(home_dir)
    asdf_which_out = io.StringIO()
    try:
        c.run(f"{asdf_cmd} which {tool}",
              out_stream=asdf_which_out,
              env=_tmp_asdf_env(asdf_cmd))
        go_cmd = asdf_which_out.getvalue().strip()
        if not go_cmd:
            raise ToolNotFound(f"{tool} not found")
        return go_cmd
    finally:
        asdf_which_out.close()


def cmd_path(home_dir):
    return os.path.join(dest_dir(home_dir), "bin", "asdf")


def dest_dir(home_dir):
    return os.path.join(home_dir, ".asdf")


def parse_tool_versions(tool_versions_file):
    ignored_line_re = re.compile(r"^\s*(#.*)?$")
    plugin_line_re = re.compile(r"^(?P<plugin>\S+)\s+(?P<version>\S+).*$")
    plugins = {}
    with open(tool_versions_file) as file:
        for line in file.readlines():
            if ignored_line_re.match(line):
                continue
            m = plugin_line_re.match(line)
            if not m:
                raise ToolVersionsParseError(f"cannot process line: {line}")
            plugins[m.group("plugin")] = {"version": m.group("version")}
    return plugins


class ToolVersionsParseError(Exception):
    pass


class ToolNotFound(Exception):
    pass


def _list_plugins(c, home_dir):
    asdf_cmd = cmd_path(home_dir)
    plugin_list_out = io.StringIO()
    try:
        c.run(f"{asdf_cmd} plugin list", out_stream=plugin_list_out)
        return plugin_list_out.getvalue().splitlines()
    finally:
        plugin_list_out.close()


def _provided_versions(c, plugin, home_dir):
    asdf_cmd = cmd_path(home_dir)
    list_all_out = io.StringIO()
    try:
        c.run(f"{asdf_cmd} list-all {plugin}", out_stream=list_all_out)
        return list_all_out.getvalue().splitlines()
    finally:
        list_all_out.close()


GO_RELEASE_VERSION_RE = re.compile(
    r"(?P<major>[1-9]+)\.(?P<minor>[1-9]+)(\.(?P<patch>[1-9]+))?")


def _latest_go_version(c, home_dir):
    available = _provided_versions(c, "golang", home_dir=home_dir)
    suitable = []
    for v in available:
        m = GO_RELEASE_VERSION_RE.match(v)
        if not m:
            continue
        major = int(m.group("major"))
        minor = int(m.group("minor"))
        patch = int(m.group("patch")) if m.group("patch") else 0
        suitable.append((major, minor, patch))
    suitable.sort()
    major, minor, patch = suitable[-1]
    if patch > 0:
        return f"{major}.{minor}.{patch}"
    return f"{major}.{minor}"


def _tmp_asdf_env(asdf_cmd):
    path_var = os.environ["PATH"]
    return {"PATH": f"{os.path.dirname(asdf_cmd)}:{path_var}"}
