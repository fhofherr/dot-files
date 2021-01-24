import json
import os
from collections import OrderedDict
from copy import deepcopy
from dataclasses import dataclass


@dataclass
class _ZSH:
    before_compinit_script: str
    after_compinit_script: str


class State:
    def __init__(self, mod_name):
        self.mod_name = mod_name
        self.clear()

    def clear(self):
        self._values = {}
        self._env = {}
        self._aliases = {}
        self.zsh = _ZSH("", "")

    def put(self, key, value):
        self._values[key] = value

    def get(self, key, default=None):
        return self._values.get(key, default)

    def delete(self, key):
        if key in self._values:
            del self._values[key]

    def setenv(self, varname, value):
        if varname == "PATH":
            self.set_path(value)
            return
        self._env[varname] = value

    def getenv(self, varname, default=None):
        if varname == "PATH":
            return self.get_path()
        return self._env.get(varname, default)

    def delenv(self, varname):
        if varname in self._env:
            del self._env[varname]

    def set_path(self, value):
        path = self._env.get("PATH", [])
        if value in path:
            return
        path.append(value)
        self._env["PATH"] = path

    def get_path(self):
        path = self._env.get("PATH", [])
        return deepcopy(path)

    def add_alias(self, name, value):
        self._aliases[name] = value

    def get_alias(self, name):
        return self._aliases[name]

    def marshal_json(self):
        d = {"mod_name": self.mod_name}
        if self._values:
            d["values"] = deepcopy(self._values)
        if self._env:
            d["env"] = deepcopy(self._env)
        if self._aliases:
            d["aliases"] = deepcopy(self._aliases)

        zsh = {}
        if self.zsh.before_compinit_script:
            zsh["before_compinit_script"] = self.zsh.before_compinit_script
        if self.zsh.after_compinit_script:
            zsh["after_compinit_script"] = self.zsh.after_compinit_script

        if zsh:
            d["zsh"] = zsh

        return d


class Aggregate:
    def __init__(self):
        self._env = OrderedDict()
        self._aliases = OrderedDict()
        self._zsh_before_compinit_scripts = []
        self._zsh_after_compinit_scripts = []

    @property
    def env_vars(self):
        return list(self._env.items())

    @property
    def aliases(self):
        return list(self._aliases.items())

    @property
    def zsh_before_compinit_script(self):
        return "\n\n\n".join(self._zsh_before_compinit_scripts)

    @property
    def zsh_after_compinit_script(self):
        return "\n\n\n".join(self._zsh_after_compinit_scripts)

    def add_state(self, st: State):
        self._add_env(st)
        self._add_aliases(st)
        self._add_zsh_compinit_scripts(st)

    def _add_env(self, st: State):
        for k, v in st._env.items():
            if k == "PATH":
                self._append_path(v)
                continue
            if k in self._env:
                raise ValueError(
                    f"state '{st.mod_name}' redefines environment variable '{k}'"
                )
            self._env[k] = v

    def _append_path(self, vs):
        path = self._env.get("PATH", [])
        for v in vs:
            if v in path:
                continue
            path.append(v)
        self._env["PATH"] = path

    def _add_aliases(self, st: State):
        for k, v in st._aliases.items():
            if k in self._aliases:
                raise ValueError(
                    f"state '{st.mod_name}' redefines alias '{k}'")
            self._aliases[k] = v

    def _add_zsh_compinit_scripts(self, st: State):
        if st.zsh.before_compinit_script != "":
            self._zsh_before_compinit_scripts.append(
                st.zsh.before_compinit_script)
        if st.zsh.after_compinit_script != "":
            self._zsh_after_compinit_scripts.append(
                st.zsh.after_compinit_script)


def save_state(state_dir, st):
    st_path = os.path.join(state_dir, f"{st.mod_name}.json")
    os.makedirs(os.path.dirname(st_path), exist_ok=True)
    with open(st_path, "w") as f:
        json.dump(st.marshal_json(), f)


def load_state(state_dir, mod_name):
    st_path = os.path.join(state_dir, f"{mod_name}.json")
    if not os.path.exists(st_path):
        return State(mod_name)

    with open(st_path, "r") as f:
        data = json.load(f)
    st = State(data["mod_name"])
    st._values = data.get("values", {})
    st._env = data.get("env", {})
    st._aliases = data.get("aliases", {})
    zsh = data.get("zsh", {})
    st.zsh.before_compinit_script = zsh.get("before_compinit_script", "")
    st.zsh.after_compinit_script = zsh.get("after_compinit_script", "")
    return st
