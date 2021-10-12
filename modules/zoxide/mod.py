import shutil

from dotfiles import module


class Zoxide(module.Definition):
    @property
    def zoxide_cmd(self):
        return shutil.which("zoxide")

    @property
    def _zsh_hook(self):
        p = self.run_cmd(self.zoxide_cmd, "init", "zsh", capture_output=True)
        return p.stdout.decode("utf-8").strip()

    @module.install
    @module.update
    def install(self):
        if not self.zoxide_cmd:
            return
        self.state.zsh.after_compinit_script = self._zsh_hook


if __name__ == "__main__":
    module.run(Zoxide)
