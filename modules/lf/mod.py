import os

from dotfiles import download, fs, module


class LF(module.Definition):
    _repo_id = "gokcehan/lf"

    @property
    def _asset_name(self):
        return "lf-linux-amd64.tar.gz"

    @property
    def lf_cmd(self):
        return os.path.join(self.bin_dir, "lf")

    @property
    def _lfrc_src(self):
        return os.path.join(self.mod_dir, "lfrc")

    @property
    def _lfrc_dest(self):
        return os.path.join(self.home_dir, ".config", "lf", "lfrc")

    @property
    def _lfbin_src(self):
        return os.path.join(self.mod_dir, "bin")

    @property
    def _lfbin_dest(self):
        return os.path.join(self.home_dir, ".config", "lf", "bin")

    @module.update
    @module.install
    def install(self):
        self.download()
        fs.safe_link_file(self._lfrc_src, self._lfrc_dest)
        fs.safe_link_file(self._lfbin_src, self._lfbin_dest)
        self.state.setenv("PATH", self.bin_dir)

    def download(self):
        self.log.info("Downloading lf")
        paths, did_download = download.github_asset(self._repo_id,
                                                    self._asset_name,
                                                    self.download_dir,
                                                    log=self.log)
        if not did_download and os.path.exists(self.lf_cmd):
            return False
        self.log.info(f"Extracting {paths[0]} to {self.lf_cmd}")
        fs.extract_tar_file(paths[0], [("lf", self.lf_cmd)])
        os.chmod(self.lf_cmd, 0o755)
        return True


if __name__ == "__main__":
    module.run(LF)
