from dotfiles import module

PKG_NAME = "pre-commit"


class PreCommit(module.Definition):
    required = ["pipx"]

    @module.install
    def install(self):
        self.pipx.install(PKG_NAME)

    @module.update
    def update(self):
        self.pipx.update(PKG_NAME)
