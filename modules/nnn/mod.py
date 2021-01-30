import os
import shutil

from dotfiles import download, module

_GETPLUGS_URL = "https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs"


class NNN(module.Definition):
    @property
    def _nnn_cmd(self):
        return shutil.which("nnn")

    @property
    def _plugin_dir(self):
        return os.path.join(self.home_dir, ".config", "nnn", "plugins")

    @property
    def _getplugs_cmd(self):
        return os.path.join(self._plugin_dir, "getplugs")

    @property
    def _zsh_hook(self):
        path = os.path.join(self.mod_dir, "bin", "after_compinit.sh")
        with open(path) as f:
            return f.read()

    @module.update
    @module.install
    def install(self):
        if not self._nnn_cmd:
            self.log.info("nnn not installed. Skipping")
            return

        self.sync_default_plugins()

        if shutil.which("trash"):
            self.state.setenv("NNN_TRASH", 1)
        elif shutil.which("gio"):
            self.state.setenv("NNN_TRASH", 2)
        else:
            self.log.info("No trash utility found. Delete will really delete")

        self.state.setenv("NNN_COMMAND", self._nnn_cmd)
        self.state.setenv("NNN_OPTS", "eoERx")
        self.state.zsh.after_compinit_script = self._zsh_hook
        self.state.add_alias("n", "_nnn")

    def sync_default_plugins(self):
        if not os.path.exists(self._getplugs_cmd):
            download.file(_GETPLUGS_URL, self._getplugs_cmd)
        os.chmod(self._getplugs_cmd, 0o755)
        os.makedirs(self._plugin_dir, exist_ok=True)
        self.run_cmd(self._getplugs_cmd)


if __name__ == "__main__":
    module.run(NNN)
