from dotfiles import module

PKG_NAME = "lookatme"


class Lookatme(module.Definition):
    required = ["pipx"]
    hostnames = ["fhhc", "wintermute"]

    @module.install
    def install(self):
        self.pipx.install(PKG_NAME)

    @module.update
    def update(self):
        self.pipx.update(PKG_NAME)


if __name__ == "__main__":
    module.run(Lookatme)
