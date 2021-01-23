import os
from dotfiles import module

LAZY_GIT_PKG = "github.com/jesseduffield/lazygit"

class LazyGit(module.Definition):
    required = ["git", "golang"]

    @property
    def lazygit_cmd(self):
        return os.path.join(self.golang.go_bin_dir, "lazygit")

    @module.update
    @module.install
    def install(self):
        self.golang.go_get(LAZY_GIT_PKG)
        self.state.add_alias("lg", self.lazygit_cmd)


if __name__ == "__main__":
    module.run(LazyGit)
