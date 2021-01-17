import shutil

from dotfiles import module


class Kubectl(module.Definition):
    @property
    def kubectl_cmd(self):
        return shutil.which("kubectl")

    @property
    def _zsh_hook(self):
        if not self.kubectl_cmd:
            return ""
        p = self.run_cmd(self.kubectl_cmd,
                         "completion",
                         "zsh",
                         capture_output=True)
        return p.stdout.decode("utf-8").strip()

    @module.update
    @module.install
    def install(self):
        if not self.kubectl_cmd:
            self.log.info("kubectl not installed")
            return
        self.state.add_alias("k", self.kubectl_cmd)
        self.state.zsh.after_compinit_script = self._zsh_hook


if __name__ == "__main__":
    module.run(Kubectl)
