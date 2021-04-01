import shutil

from dotfiles import module


class Luarocks(module.Definition):
    @property
    def _luarocks_cmd(self):
        return shutil.which("luarocks")

    @property
    def _after_compinit_script(self):
        if not self._luarocks_cmd:
            return ""
        p = self("path", "--bin", capture_output=True)
        return p.stdout.decode("utf-8").strip()

    @module.install
    @module.update
    def install(self):
        if not shutil.which("luarocks"):
            self.log.info("Luarocks not found. Skipping luarocks module")
            return
        self.state.zsh.after_compinit_script = self._after_compinit_script

    def __call__(self, *args, **kwargs):
        return self.run_cmd(self._luarocks_cmd, *args, **kwargs)


if __name__ == "__main__":
    module.run(Luarocks)
