from dotfiles import module

# https://github.com/bulletmark/edir
PKG_NAME = "edir"


class Edir(module.Definition):
    hostnames = ["fhhc", "wintermute"]
    required = ["pipx"]

    @module.install
    def install(self):
        self.pipx.install(PKG_NAME)

    @module.update
    def update(self):
        self.pipx.update(PKG_NAME)


if __name__ == "__main__":
    module.run(Edir)
