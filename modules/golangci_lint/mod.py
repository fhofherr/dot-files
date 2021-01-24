import os
import tarfile
from fnmatch import fnmatch

from dotfiles import chksum, download, fs, module

REPO_ID = "golangci/golangci-lint"


class GolangCILint(module.Definition):
    name = "golangci_lint"

    @property
    def golangci_lint_cmd(self):
        return os.path.join(self.bin_dir, "golangci-lint")

    def is_asset_selected(self, name):
        return self.is_checksum_asset(name) or self.is_archive_asset(name)

    def is_checksum_asset(self, name):
        return fnmatch(name, "golangci-lint-*-checksums.txt")

    def is_archive_asset(self, name):
        return fnmatch(name, "golangci-lint-*-linux-amd64.tar.gz")

    def is_binary_member(self, ti: tarfile.TarInfo) -> bool:
        return fnmatch(ti.name, "golangci-lint-*-linux-amd64/golangci-lint")

    @module.update
    @module.install
    def install(self):
        self.download()
        self.state.setenv("PATH", self.bin_dir)

    def download(self):
        self.log.info("Downloading golangci-lint")
        paths, did_download = download.github_asset(REPO_ID,
                                                    self.is_asset_selected,
                                                    self.download_dir,
                                                    log=self.log)
        if not did_download:
            self.log.info("golangci-lint was not downloaded")
            return False
        chksum_file = next(p for p in paths
                           if self.is_checksum_asset(os.path.basename(p)))
        archive_file = next(p for p in paths
                            if self.is_archive_asset(os.path.basename(p)))
        if not chksum.verify_sha256_file(archive_file, chksum_file, self.log):
            raise ValueError("Checksum mismatch")
        fs.extract_tar_file(archive_file,
                            [(self.is_binary_member, self.golangci_lint_cmd)])
        os.chmod(self.golangci_lint_cmd, 0o755)
        return True


if __name__ == "__main__":
    module.run(GolangCILint)
