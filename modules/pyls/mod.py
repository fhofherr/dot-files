from dotfiles import module

PKG_NAME = "python-language-server"
PLUGINS = ["python-language-server[rope]"]


class Pyls(module.Definition):
    required = ["pipx"]

    @module.install
    def install(self):
        self.pipx.install(PKG_NAME)
        for plugin in PLUGINS:
            self.pipx.inject(PKG_NAME, plugin)

    @module.update
    def update(self):
        self.pipx.update(PKG_NAME)
        for plugin in PLUGINS:
            self.pipx.inject(PKG_NAME, plugin, update=True)
