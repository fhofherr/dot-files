from dotfiles import module

PKG_NAME = "python-lsp-server"
PLUGINS = ["python-lsp-server[rope]"]


class Pylsp(module.Definition):
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


if __name__ == "__main__":
    module.run(Pylsp)
