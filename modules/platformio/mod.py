from dotfiles import module

PKG_NAME = "platformio"


class PlatformIO(module.Definition):
    hostnames = ["wintermute", "pi400-1"]
    required = ["pipx"]

    @module.install
    def install(self):
        self.pipx.install(PKG_NAME)

    @module.update
    def update(self):
        self.pipx.update(PKG_NAME)
