import os
import tarfile
from fnmatch import fnmatch

from dotfiles import download, fs, module

REPO_ID = "dandavison/delta"


class GitDelta(module.Definition):
    name = "git_delta"

    @property
    def delta_cmd(self):
        return os.path.join(self.bin_dir, "delta")

    @property
    def syntax_theme(self):
        name = os.getenv("DOTFILES_COLOR_SCHEME")
        if not name:
            return "gruvbox"
        return {
            "dracula": "Dracula",
            "gruvbox-dark": "gruvbox",
            "gruvbox-light": "gruvbox-light",
            "papercolor-dark": "gruvbox",
            "papercolor-light": "gruvbox-light",
        }.get(name, "gruvbox")

    def is_archive_asset(self, name):
        return fnmatch(name, "delta-*-x86_64-unknown-linux-gnu.tar.gz")

    def is_binary_member(self, ti: tarfile.TarInfo) -> bool:
        return fnmatch(ti.name, "delta-*-x86_64-unknown-linux-gnu/delta")

    @module.update
    @module.install
    def install(self):
        self.download()
        self.state.setenv("PATH", self.bin_dir)

    def download(self):
        self.log.info("Downloading delta")
        paths, did_download = download.github_asset(REPO_ID,
                                                    self.is_archive_asset,
                                                    self.download_dir,
                                                    log=self.log)
        if not did_download and os.path.exists(paths[0]):
            return False
        self.log.info(f"Extracting {paths[0]}")
        fs.extract_tar_file(paths[0],
                            [(self.is_binary_member, self.delta_cmd)])
        os.chmod(self.delta_cmd, 0o755)
        return True


if __name__ == "__main__":
    module.run(GitDelta)
