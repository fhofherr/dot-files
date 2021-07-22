import os

from dotfiles import download, module

BUKU_PKG_NAME = "buku"
BUKUSERVER_PKG_NAME = "buku[server]"

ZSH_COMPLETIONS_URL = "https://raw.githubusercontent.com/jarun/buku/master/auto-completion/zsh/_buku"


class Buku(module.Definition):
    required = ["pipx"]
    hostnames = ["fhhc", "wintermute"]

    @property
    def local_dir(self):
        return os.path.join(self.home_dir, ".local", "share", "buku")

    @property
    def _zsh_completions_dir(self):
        return os.path.join(self.local_dir, "completions", "zsh")

    @property
    def _zsh_completions_dest(self):
        return os.path.join(self._zsh_completions_dir, "_buku")

    @module.install
    def install(self):
        self.pipx.install(BUKU_PKG_NAME, force=True)
        self.pipx.inject(BUKU_PKG_NAME, BUKUSERVER_PKG_NAME, force=True)
        os.makedirs(self._zsh_completions_dir, exist_ok=True)
        download.file(ZSH_COMPLETIONS_URL, self._zsh_completions_dest)
        self.state.zsh.after_compinit_script = f"fpath+=({self._zsh_completions_dir})"

        self.state.add_alias("b", "buku --suggest")

    @module.update
    def update(self):
        self.pipx.update(BUKU_PKG_NAME)
        self.pipx.inject(BUKU_PKG_NAME, BUKUSERVER_PKG_NAME, update=True)


if __name__ == "__main__":
    module.run(Buku)
