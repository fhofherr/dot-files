import os

from dotfiles import download, fs, module

LF_ICONS = {
    "tw": ":",
    "st": ":",
    "ow": ":",
    "dt": ":",
    "di": ":",
    "fi": ":",
    "ln": ":",
    "or": ":",
    "ex": ":",
    "*.c": ":",
    "*.cc": ":",
    "*.clj": ":",
    "*.coffee": ":",
    "*.cpp": ":",
    "*.css": ":",
    "*.d": ":",
    "*.dart": ":",
    "*.erl": ":",
    "*.exs": ":",
    "*.fs": ":",
    "*.go": ":",
    "*.h": ":",
    "*.hh": ":",
    "*.hpp": ":",
    "*.hs": ":",
    "*.html": ":",
    "*.java": ":",
    "*.jl": ":",
    "*.js": ":",
    "*.json": ":",
    "*.lua": ":",
    "*.md": ":",
    "*.php": ":",
    "*.pl": ":",
    "*.pro": ":",
    "*.py": ":",
    "*.rb": ":",
    "*.rs": ":",
    "*.scala": ":",
    "*.ts": ":",
    "*.vim": ":",
    "*.cmd": ":",
    "*.ps1": ":",
    "*.sh": ":",
    "*.bash": ":",
    "*.zsh": ":",
    "*.fish": ":",
    "*.tar": ":",
    "*.tgz": ":",
    "*.arc": ":",
    "*.arj": ":",
    "*.taz": ":",
    "*.lha": ":",
    "*.lz4": ":",
    "*.lzh": ":",
    "*.lzma": ":",
    "*.tlz": ":",
    "*.txz": ":",
    "*.tzo": ":",
    "*.t7z": ":",
    "*.zip": ":",
    "*.z": ":",
    "*.dz": ":",
    "*.gz": ":",
    "*.lrz": ":",
    "*.lz": ":",
    "*.lzo": ":",
    "*.xz": ":",
    "*.zst": ":",
    "*.tzst": ":",
    "*.bz2": ":",
    "*.bz": ":",
    "*.tbz": ":",
    "*.tbz2": ":",
    "*.tz": ":",
    "*.deb": ":",
    "*.rpm": ":",
    "*.jar": ":",
    "*.war": ":",
    "*.ear": ":",
    "*.sar": ":",
    "*.rar": ":",
    "*.alz": ":",
    "*.ace": ":",
    "*.zoo": ":",
    "*.cpio": ":",
    "*.7z": ":",
    "*.rz": ":",
    "*.cab": ":",
    "*.wim": ":",
    "*.swm": ":",
    "*.dwm": ":",
    "*.esd": ":",
    "*.jpg": ":",
    "*.jpeg": ":",
    "*.mjpg": ":",
    "*.mjpeg": ":",
    "*.gif": ":",
    "*.bmp": ":",
    "*.pbm": ":",
    "*.pgm": ":",
    "*.ppm": ":",
    "*.tga": ":",
    "*.xbm": ":",
    "*.xpm": ":",
    "*.tif": ":",
    "*.tiff": ":",
    "*.png": ":",
    "*.svg": ":",
    "*.svgz": ":",
    "*.mng": ":",
    "*.pcx": ":",
    "*.mov": ":",
    "*.mpg": ":",
    "*.mpeg": ":",
    "*.m2v": ":",
    "*.mkv": ":",
    "*.webm": ":",
    "*.ogm": ":",
    "*.mp4": ":",
    "*.m4v": ":",
    "*.mp4v": ":",
    "*.vob": ":",
    "*.qt": ":",
    "*.nuv": ":",
    "*.wmv": ":",
    "*.asf": ":",
    "*.rm": ":",
    "*.rmvb": ":",
    "*.flc": ":",
    "*.avi": ":",
    "*.fli": ":",
    "*.flv": ":",
    "*.gl": ":",
    "*.dl": ":",
    "*.xcf": ":",
    "*.xwd": ":",
    "*.yuv": ":",
    "*.cgm": ":",
    "*.emf": ":",
    "*.ogv": ":",
    "*.ogx": ":",
    "*.aac": ":",
    "*.au": ":",
    "*.flac": ":",
    "*.m4a": ":",
    "*.mid": ":",
    "*.midi": ":",
    "*.mka": ":",
    "*.mp3": ":",
    "*.mpc": ":",
    "*.ogg": ":",
    "*.ra": ":",
    "*.wav": ":",
    "*.oga": ":",
    "*.opus": ":",
    "*.spx": ":",
    "*.xspf": ":",
    "*.pdf": ":",
    "*.nix": ":",
}


class LF(module.Definition):
    hostnames = ["fhhc", "wintermute"]

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

    @property
    def _lf_icons(self):
        return ":".join(f"{k}={v}" for k, v in LF_ICONS.items())

    @module.update
    @module.install
    def install(self):
        self.download()
        fs.safe_link_file(self._lfrc_src, self._lfrc_dest)
        fs.safe_link_file(self._lfbin_src, self._lfbin_dest)
        self.state.setenv("PATH", self.bin_dir)
        self.state.setenv("LF_ICONS", self._lf_icons)

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
