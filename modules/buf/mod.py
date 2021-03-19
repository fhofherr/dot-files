import os
from fnmatch import fnmatch

from dotfiles import download, fs, module

REPO_ID = "bufbuild/buf"


class Buf(module.Definition):
    def is_shasum_asset(self, name):
        return name == "sha256.txt"

    def is_archive_asset(self, name):
        return fnmatch(name, "buf-Linux-*.tar.gz")

    def is_asset_selected(self, name):
        return self.is_shasum_asset(name) or self.is_archive_asset(name)

    @property
    def buf_cmd(self):
        return os.path.join(self.bin_dir, "buf")

    @property
    def protoc_gen_buf_breaking_cmd(self):
        return os.path.join(self.bin_dir, "protoc-gen-buf-breaking")

    @property
    def protoc_gen_buf_lint_cmd(self):
        return os.path.join(self.bin_dir, "protoc-gen-buf-lint")

    @module.update
    @module.install
    def install(self):
        self.download()
        self.state.setenv("PATH", self.bin_dir)

    def download(self):
        paths, did_download = download.github_asset(
            REPO_ID,
            self.is_asset_selected,
            self.download_dir,
            checksum_filter=self.is_shasum_asset,
            pre_release_ok=True,
            log=self.log)
        fs.extract_tar_file(paths[0], [
            ("buf/bin/buf", self.buf_cmd),
            ("buf/bin/protoc-gen-buf-breaking",
             self.protoc_gen_buf_breaking_cmd),
            ("buf/bin/protoc-gen-buf-lint", self.protoc_gen_buf_lint_cmd),
        ])
        os.chmod(self.buf_cmd, 0o755)
        os.chmod(self.protoc_gen_buf_breaking_cmd, 0o755)
        os.chmod(self.protoc_gen_buf_lint_cmd, 0o755)


if __name__ == "__main__":
    module.run(Buf)
