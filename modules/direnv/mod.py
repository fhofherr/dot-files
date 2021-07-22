import os
import shutil

from dotfiles import download, fs, module


class Direnv(module.Definition):
    hostnames = ["fhhc", "wintermute"]
    _repo_id = "direnv/direnv"

    @property
    def _asset_name(self):
        return "direnv.linux-amd64"

    @property
    def direnv_cmd(self):
        return os.path.join(self.bin_dir, "direnv")

    @property
    def _direnvrc_src(self):
        return os.path.join(self.mod_dir, "direnvrc")

    @property
    def _direnvrc_dest(self):
        return os.path.join(self.home_dir, ".config", "direnv", "direnvrc")

    @property
    def _zsh_hook(self):
        p = self.run_cmd(self.direnv_cmd, "hook", "zsh", capture_output=True)
        return p.stdout.decode("utf-8").strip()

    @module.update
    @module.install
    def install(self):
        self.download()
        fs.safe_link_file(self._direnvrc_src, self._direnvrc_dest)
        self.state.setenv("PATH", self.bin_dir)
        self.state.zsh.after_compinit_script = self._zsh_hook

    def download(self):
        self.log.info("Downloading direnv")
        paths, did_download = download.github_asset(self._repo_id,
                                                    self._asset_name,
                                                    self.download_dir,
                                                    log=self.log)
        if did_download:
            self.log.info(f"Copying {paths[0]} to {self.direnv_cmd}")
            os.makedirs(os.path.dirname(self.direnv_cmd), exist_ok=True)
            shutil.copyfile(paths[0], self.direnv_cmd)
            os.chmod(self.direnv_cmd, 0o755)
            return True
        return os.path.exists(self.direnv_cmd)


if __name__ == "__main__":
    module.run(Direnv)
