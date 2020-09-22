from dotfiles import module

PKG_NAMES = [
    "mycli",
    "pgcli",
]


class DBCLI(module.Definition):
    required = ["pipx"]

    @module.install
    def install(self):
        for pkg_name in PKG_NAMES:
            self.pipx.install(pkg_name)

    @module.update
    def update(self):
        for pkg_name in PKG_NAMES:
            self.pipx.update(pkg_name)
