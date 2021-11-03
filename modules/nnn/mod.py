import os
import shutil

from dotfiles import module


class NNN(module.Definition):
    @property
    def _nnn_cmd(self):
        return shutil.which("nnn")

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
        if shutil.which("gio"):
            self.state.setenv("NNN_TRASH", 2)
        elif shutil.which("trash"):
            self.state.setenv("NNN_TRASH", 1)
        else:
            self.log.info("No trash utility found. Delete will really delete")
        self.state.setenv("NNN_COMMAND", self._nnn_cmd)
        self.state.setenv("NNN_OPTS", "eoERx")
        self.state.zsh.after_compinit_script = self._zsh_hook
        self.state.add_alias("n", "_nnn")


if __name__ == "__main__":
    module.run(NNN)
