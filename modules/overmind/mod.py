import os
from fnmatch import fnmatch

import gzip
from dotfiles import download, module


class Overmind(module.Definition):
    hostnames = ["fhhc", "wintermute"]
    _repo_id = "DarthSim/overmind"

    def is_asset_selected(self, name):
        return fnmatch(name, "overmind-*-linux-amd64.gz")

    @property
    def overmind_cmd(self):
        return os.path.join(self.bin_dir, "overmind")

    @module.update
    @module.install
    def install(self):
        if not self.download():
            return
        self.state.setenv("PATH", self.bin_dir)

    def download(self):
        self.log.info("Downloading overmind")
        paths, did_download = download.github_asset(self._repo_id,
                                                    self.is_asset_selected,
                                                    self.download_dir,
                                                    log=self.log)
        if not did_download and os.path.exists(self.overmind_cmd):
            return False
        self.log.info(f"Copying {paths[0]} to {self.overmind_cmd}")
        with gzip.open(paths[0]) as gz_f,\
	 open(self.overmind_cmd, "wb") as bin_f:
            bin_f.write(gz_f.read())
        os.chmod(self.overmind_cmd, 0o755)
        return True


if __name__ == "__main__":
    module.run(Overmind)
