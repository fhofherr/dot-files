import os

from dotfiles import download, fs, module


class Starship(module.Definition):
    repo_id = "starship/starship"

    @property
    def starship_cmd(self):
        return os.path.join(self.bin_dir, "starship")

    @property
    def asset_names(self):
        return (
            "starship-x86_64-unknown-linux-gnu.tar.gz",
            "starship-x86_64-unknown-linux-gnu.tar.gz.sha256",
        )

    @property
    def asset_paths(self):
        return [os.path.join(self.download_dir, n) for n in self.asset_names]

    @property
    def _cfg_file_src(self):
        return os.path.join(self.mod_dir, "starship.toml")

    @property
    def _cfg_file_dest(self):
        return os.path.join(self.home_dir, ".config", "starship.toml")

    @property
    def _zsh_hook(self):
        if not os.path.exists(self.starship_cmd):
            return ""
        p = self.run_cmd(self.starship_cmd,
                         "init",
                         "zsh",
                         "--print-full-init",
                         capture_output=True)
        return p.stdout.decode("utf-8").strip()

    @module.update
    @module.install
    def install(self):
        if not self.download() and not os.path.exists(self.starship_cmd):
            self.log.error("Failed to install starship")
            return
        fs.safe_link_file(self._cfg_file_src, self._cfg_file_dest)
        self.state.setenv("PATH", self.bin_dir)
        self.state.zsh.after_compinit_script = self._zsh_hook

    def download(self):
        paths, did_download = download.github_asset(
            self.repo_id,
            lambda n: n in self.asset_names,
            self.download_dir,
            log=self.log,
            checksum_filter=self.asset_names[1],
        )
        if not did_download and os.path.exists(self.starship_cmd):
            return False
        fs.extract_tar_file(paths[0], [("starship", self.starship_cmd)])
        os.chmod(self.starship_cmd, 0o755)
        return True


if __name__ == "__main__":
    module.run(Starship)
