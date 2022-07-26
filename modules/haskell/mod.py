import os
import shutil

from dotfiles import module

GHCUP_BASE_URL = "https://downloads.haskell.org/~ghcup"
GHCUP_VERSION = "0.1.17.8"
GHCUP_USE_XDG_DIRS = False
GHCUP_SIGN_KEYS = [
    "7784930957807690A66EBDBE3786C5262ECB4A3F",
    "FE5AB6C91FEA597C3B31180B73EDE9E8CFBAEF01",
]


class Haskell(module.Definition):
    hostnames = ["fhhc", "wintermute"]

    @property
    def ghcup_bin_dir(self):
        if GHCUP_USE_XDG_DIRS:
            return os.path.join(self.home_dir, ".local", "bin")
        else:
            return os.path.join(self.home_dir, ".ghcup", "bin")

    @property
    def ghcup_bin(self):
        return os.path.join(self.ghcup_bin_dir, "ghcup")

    @property
    def _ghcup_env(self):
        env = {}
        if GHCUP_USE_XDG_DIRS:
            env["GHCUP_USE_XDG_DIRS"] = "1"
        return env

    @property
    def cabal_bin_dir(self):
        return os.path.join(self.home_dir, ".cabal", "bin")

    def _download_ghcup(self):
        if os.path.exists(self.ghcup_bin):
            return

        download_dir = os.path.join(self.cache_dir, "ghcup", GHCUP_VERSION)
        os.makedirs(download_dir, exist_ok=True)

        bin_name = "x86_64-linux-ghcup-0.1.17.8"
        bin_dest = os.path.join(download_dir, bin_name)
        bin_url = f"{GHCUP_BASE_URL}/{GHCUP_VERSION}/{bin_name}"
        self.run_cmd("curl", "-fsSL", "-o", bin_dest, bin_url)

        if shutil.which("gpg"):
            for k in GHCUP_SIGN_KEYS:
                self.run_cmd("gpg", "--keyserver", "keys.openpgp.org", "--recv", k, check=False)

            sig_name = "x86_64-linux-ghcup-0.1.17.8.sig"
            sig_dest = os.path.join(download_dir, sig_name)
            sig_url = f"{GHCUP_BASE_URL}/{GHCUP_VERSION}/{sig_name}"
            self.run_cmd("curl", "-fsSL", "-o", sig_dest, sig_url)
            self.run_cmd("gpg", "--verify", sig_dest, bin_dest)

        os.makedirs(self.ghcup_bin_dir, exist_ok=True)
        shutil.copy(bin_dest, self.ghcup_bin)
        os.chmod(self.ghcup_bin, 0o755)

    def _ghcup(self, *args, **kwargs):
        env = os.environ.copy()
        for k, v in self._ghcup_env.items():
            env[k] = v
        self.run_cmd(self.ghcup_bin, *args, **kwargs, env=self._ghcup_env)

    def _install_ghcpup(self):
        self._download_ghcup()
        self.state.setenv("PATH", self.ghcup_bin_dir)
        for k, v in self._ghcup_env.items():
            self.state.setenv(k, v)

    @module.install
    def install(self):
        self._install_ghcpup()
        self.state.setenv("PATH", self.cabal_bin_dir)

    @module.update
    def update(self):
        self._ghcup("upgrade", "--inplace")



if __name__ == "__main__":
    module.run(Haskell)
