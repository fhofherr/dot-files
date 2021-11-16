import shutil
import os

from dotfiles import fs, module

class GH(module.Definition):
    hostnames = ["fhhc", "wintermute"]

    @property
    def _zsh_hook(self):
        p = self.run_cmd("gh", "completion", "-s", "zsh", capture_output=True)
        return p.stdout.decode("utf-8").strip()

    @module.update
    @module.install
    def install(self):
        if not shutil.which("gh"):
            return
        self.state.zsh.after_compinit_script = self._zsh_hook


if __name__ == "__main__":
    module.run(GH)
