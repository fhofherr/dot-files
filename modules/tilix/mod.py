import os
import shutil

from dotfiles import fs, module

TILIX_VTE_FIX = """
if [[ -n "$TILIX_ID" ]] || [[ -n "$VTE_VERSION" ]]
then
    [[ -f "/etc/profile.d/vte.sh" ]] && source /etc/profile.d/vte.sh
fi
"""


class Tilix(module.Definition):
    required = ["nerd_fonts"]

    @property
    def tilix_cmd(self):
        return shutil.which("tilix")

    @property
    def _dconf_cmd(self):
        return shutil.which("dconf")

    @property
    def _cfg_dump(self):
        return os.path.join(self.mod_dir, "cfg_dump")

    @property
    def tilix_schemes_src(self):
        return os.path.join(self.mod_dir, "schemes")

    @property
    def tilix_schemes_dest(self):
        return os.path.join(self.home_dir, ".config", "tilix", "schemes")

    @module.update
    @module.install
    def configure(self):
        self.state.zsh.after_compinit_script = TILIX_VTE_FIX
        fs.safe_link_file(self.tilix_schemes_src, self.tilix_schemes_dest)
        self.load_cfg()

    def load_cfg(self):
        if not self._dconf_cmd:
            self.log.warn("dconf not available")
            return
        with open(self._cfg_dump, "r") as f:
            self.run_cmd(self._dconf_cmd,
                         "load",
                         "/com/gexperts/Tilix/",
                         stdin=f)

    def dump_cfg(self):
        # TODO provide a way to execute this method from the CLI
        if not self.dconf_cmd:
            self.log.warn("dconf not available")
            return
        with open(self._cfg_dump, "w") as f:
            self.run_cmd(self._dconf_cmd,
                         "dump",
                         "/com/gexperts/Tilix/",
                         stdout=f)


if __name__ == "__main__":
    module.run(Tilix)
