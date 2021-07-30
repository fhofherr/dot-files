import os

from dotfiles import fs, module

LAZY_GIT_PKG = "github.com/jesseduffield/lazygit"


class LazyGit(module.Definition):
    hostnames = ["fhhc", "wintermute"]
    required = ["git", "golang"]

    @property
    def _cfg_src(self):
        return os.path.join(self.mod_dir, "config.yml")

    @property
    def _cfg_dest(self):
        return os.path.join(self.home_dir, ".config", "lazygit", "config.yml")

    @property
    def lazygit_cmd(self):
        return os.path.join(self.golang.go_bin_dir, "lazygit")

    @module.update
    @module.install
    def install(self):
        self.golang.go_get(LAZY_GIT_PKG)
        fs.safe_link_file(self._cfg_src, self._cfg_dest)
        self.state.add_alias("lg", self.lazygit_cmd)


if __name__ == "__main__":
    module.run(LazyGit)
