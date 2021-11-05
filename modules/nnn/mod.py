import os
import shutil
import requests
import subprocess

from dotfiles import module

GETPLUGS_URL = "https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs"

class NNN(module.Definition):
    @property
    def _nnn_cmd(self):
        return shutil.which("nnn")

    @property
    def _zsh_hook(self):
        path = os.path.join(self.mod_dir, "after_compinit.sh")
        with open(path) as f:
            return f.read()

    @property
    def _cfg_dest(self):
        return os.path.join(self.home_dir, ".config", "nnn")

    @property
    def _plugin_dest(self):
        return os.path.join(self._cfg_dest, "plugins")

    def getplugs(self):
        getplugs = os.path.join(self._plugin_dest, "getplugs")
        if not os.path.exists(getplugs):
            os.makedirs(self._plugin_dest, exist_ok=True)
            r = requests.get(GETPLUGS_URL)
            with open(getplugs, "w") as f:
                f.write(r.text)
            os.chmod(getplugs, 0o744)
        subprocess.run(getplugs, check=True)

    @module.update
    @module.install
    def install(self):
        if not self._nnn_cmd:
            self.log.info("nnn not installed. Skipping")
            return

        self.getplugs()

        if shutil.which("gio"):
            self.state.setenv("NNN_TRASH", 2)
        elif shutil.which("trash"):
            self.state.setenv("NNN_TRASH", 1)
        else:
            self.log.info("No trash utility found. Delete will really delete")

        self.state.setenv("NNN_OPENER", os.path.join(self._plugin_dest, "nuke"))
        self.state.setenv("NNN_COMMAND", self._nnn_cmd)
        self.state.setenv("NNN_OPTS", "codERxa")
        self.state.setenv("NNN_PLUG","p:preview-tui;z:autojump")

        self.state.zsh.after_compinit_script = self._zsh_hook
        self.state.add_alias("nnn", "_nnn")


if __name__ == "__main__":
    module.run(NNN)
