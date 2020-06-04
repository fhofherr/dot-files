import os
import json


def state_dir(home_dir):
    return os.path.join(home_dir, ".local", "dotfiles", "state")


def write_state(home_dir, state):
    s_dir = state_dir(home_dir)
    s_file = os.path.join(s_dir, f"{state.name}.json")
    os.makedirs(s_dir, exist_ok=True)
    with open(s_file, "w") as f:
        f.write(state.to_json())


def read_state(home_dir, name):
    s_dir = state_dir(home_dir)
    s_file = os.path.join(s_dir, f"{name}.json")
    return _load_state(s_file)


def _load_state(s_file):
    with open(s_file) as f:
        json_str = f.read()
        return State.from_json(json_str)


class State:
    def __init__(self, name, depends_on=[]):
        self.name = name
        self.depends_on = depends_on
        self.env = {}
        self.aliases = {}
        self.before_compinit_script = None
        self.after_compinit_script = None

    def put_env(self, key, value, guard=None):
        # TODO validate key and value
        # TODO remember to de-duplicate the values of PATH for multiple state
        #     files when creating the shell init file
        self.env[key] = {"value": value}
        if guard:
            self.env[key]["guard"] = guard

    def add_alias(self, key, value):
        self.aliases[key] = value

    @classmethod
    def from_json(cls, json_str):
        data = json.loads(json_str)
        state = cls(name=data["name"], depends_on=data.get("depends_on", []))
        if "env" in data:
            state.env = data["env"]
        if "aliases" in data:
            state.aliases = data["aliases"]
        if "before_compinit_script" in data:
            state.before_compinit_script = data["before_compinit_script"]
        if "after_compinit_script" in data:
            state.after_compinit_script = data["after_compinit_script"]
        return state

    def to_json(self):
        state_dict = {"name": self.name}
        if self.depends_on:
            state_dict["depends_on"] = self.depends_on
        if self.env:
            state_dict["env"] = self.env
        if self.aliases:
            state_dict["aliases"] = self.aliases
        if self.before_compinit_script:
            state_dict["before_compinit_script"] = self.before_compinit_script
        if self.after_compinit_script:
            state_dict["after_compinit_script"] = self.after_compinit_script
        return json.dumps(state_dict)


class AggregatedState:
    def __init__(self, state_files):
        self.state_files = state_files
        self.states = {}

    def _load(self):
        for s_file in self.state_files:
            state = _load_state(s_file)
            self.states[state.name] = state
        # TODO provide order according to depends_on key once this becomes necessary
        # TODO a 'global' state should always be the first in this order, i.e. all others depend implicitly on it

    def write_env(self, dest_file):
        env_vars = {}
        path = set()
        for name, state in self.states.items():
            if not state.env:
                continue
            if "PATH" in state.env:
                value = state.env["PATH"]
                if type(value) is dict:
                    value = value["value"]
                for v in value.split(os.pathsep):
                    path.add(v)
            for k, v in state.env.items():
                if k == "PATH":
                    # Skip PATH as it received special treatment above
                    continue
                if k in env_vars:
                    provider = env_vars[k]["provider"]
                    raise StateError(
                        f"{name} can't set env {k}: {provider} already did")
                # Backwards compatibility with old states
                if type(v) == dict:
                    env_vars[k] = {"provider": name, "value": v["value"]}
                    if "guard" in v:
                        env_vars[k]["guard"] = v["guard"]
                else:
                    env_vars[k] = {"provider": name, "value": v}
        with open(dest_file, "w") as f:
            f.write("# File auto-generated; DO NOT EDIT\n\n\n")
            for k in sorted(env_vars.keys()):
                value = env_vars[k]["value"]
                guard = env_vars[k].get("guard")
                if guard:
                    f.write(
                        f'if {guard}; then\n    export {k}="{value}"\nfi\n')
                else:
                    f.write(f'export {k}="{value}"\n')

            path_str = ":".join(path)
            f.write(f'export PATH="{path_str}:$PATH"\n')

    def write_aliases(self, dest_file):
        aliases = {}
        for name, state in self.states.items():
            if not state.aliases:
                continue
            for k, v in state.aliases.items():
                if k in aliases:
                    provider = aliases[k]["provider"]
                    raise StateError(
                        f"{name} can't set alias {k}: {provider} already does")
                aliases[k] = {"provider": name, "value": v}
        with open(dest_file, "w") as f:
            f.write("# File auto-generated; DO NOT EDIT\n\n\n")
            for k in sorted(aliases.keys()):
                value = aliases[k]["value"]
                f.write(f'alias {k}="{value}"\n')

    def write_before_compinit_script(self, dest_file):
        with open(dest_file, "w") as f:
            f.write("# File auto-generated; DO NOT EDIT\n\n\n")
            for name, state in self.states.items():
                if not state.before_compinit_script:
                    continue
                f.write(f"###\n### {name}\n###\n\n")
                f.write(state.before_compinit_script)

    def write_after_compinit_script(self, dest_file):
        with open(dest_file, "w") as f:
            f.write("# File auto-generated; DO NOT EDIT\n\n\n")
            for name, state in self.states.items():
                if not state.after_compinit_script:
                    continue
                f.write(f"###\n### {name}\n###\n\n")
                f.write(state.after_compinit_script)


def load_all(home_dir):
    state_files = []
    sdir = state_dir(home_dir)
    for e in os.listdir(sdir):
        path = os.path.join(sdir, e)
        if not os.path.isfile(path):
            continue
        state_files.append(path)
    ag_state = AggregatedState(state_files)
    ag_state._load()
    return ag_state


class StateError(Exception):
    pass
