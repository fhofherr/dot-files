import os
import tarfile
from fnmatch import fnmatch

from dotfiles import colors, download, fs, module

REPO_ID = "dandavison/delta"


class GitDelta(module.Definition):
    name = "git_delta"

    @property
    def delta_cmd(self):
        return os.path.join(self.bin_dir, "delta")

    @property
    def syntax_theme(self):
        name = colors.color_scheme()
        if not name:
            return "gruvbox-dark"
        return {
            "dracula": "Dracula",
            "everforest-dark-hard": "gruvbox-dark",
            "everforest-dark-medium": "gruvbox-dark",
            "everforest-dark-soft": "gruvbox-dark",
            "everforest-light-hard": "gruvbox-light",
            "everforest-light-medium": "gruvbox-light",
            "everforest-light-soft": "gruvbox-light",
            "gruvbox-dark": "gruvbox-dark",
            "gruvbox-light": "gruvbox-light",
            "tokyonight-night": "OneHalfDark",
            "tokyonight-storm": "OneHalfDark",
            "tokyonight-day": "OneHalfLight",
            "nightfox": "OneHalfDark",
            "duskfox": "OneHalfDark",
            "nordfox": "OneHalfDark",
            "terafox": "gruvbox-dark",
            "dayfox": "OneHalfLight",
            "dawnfox": "OneHalfLight",
        }.get(name, "gruvbox-dark")

    def is_archive_asset(self, name):
        if self.is_raspberrypi_32bit():
            return fnmatch(name, "delta-*-arm-unknown-linux-gnueabihf.tar.gz")
        return fnmatch(name, "delta-*-x86_64-unknown-linux-gnu.tar.gz")

    def is_binary_member(self, ti: tarfile.TarInfo) -> bool:
        if self.is_raspberrypi_32bit():
            return fnmatch(ti.name, "delta-*-arm-unknown-linux-gnueabihf/delta")
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
