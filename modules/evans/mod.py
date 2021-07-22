import os

from dotfiles import download, fs, module

REPO_ID = "ktr0731/evans"


class Evans(module.Definition):
    hostnames = ["fhhc"]

    def is_checksum_asset(self, name):
        return name == "checksums.txt"

    def is_asset_selected(self, name):
        return name == "evans_linux_amd64.tar.gz" or self.is_checksum_asset(
            name)

    @property
    def evans_cmd(self):
        return os.path.join(self.bin_dir, "evans")

    @module.update
    @module.install
    def install(self):
        if not self.download():
            self.log.info("Evans not downloaded")
        self.state.setenv("PATH", self.bin_dir)

    def download(self):
        paths, did_download = download.github_asset(
            REPO_ID,
            self.is_asset_selected,
            dest_dir=self.download_dir,
            checksum_filter=self.is_checksum_asset,
            log=self.log)
        if not did_download and os.path.exists(self.evans_cmd):
            return False
        fs.extract_tar_file(paths[0], [("evans", self.evans_cmd)])
        os.chmod(self.evans_cmd, 0o755)
        return True


if __name__ == "__main__":
    module.run(Evans)
