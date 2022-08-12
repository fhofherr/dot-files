import os
import shutil

from dotfiles import module

RUSTUP_URL = "https://sh.rustup.rs"
CRATES = [
    "stylua",
    "zoxide",
]


class Rust(module.Definition):

    @property
    def _cargo_bin(self):
        return os.path.join(self.home_dir, ".cargo", "bin")

    @property
    def _rustup(self):
        return shutil.which("rustup")

    def _install_rustup(self):
        if self._rustup:
            self.run_cmd(self._rustup, "self", "update")
            return
        os.makedirs(self.cache_dir, exist_ok=True)
        installer = os.path.join(self.cache_dir, "rustup.sh")
        self.run_cmd("curl", "-fsSL", "-o", installer, RUSTUP_URL)
        os.chmod(installer, 0o755)
        self.run_cmd(installer, "--no-modify-path", "-y", "-q")

    def _install_crates(self):
        self.run_cmd(
            os.path.join(self._cargo_bin, "cargo"),
            "install", *CRATES,
        )

    @module.install
    @module.update
    def install(self):
        self._install_rustup()
        self._install_crates()
        self.state.setenv("PATH", self._cargo_bin)


if __name__ == "__main__":
    module.run(Rust)
