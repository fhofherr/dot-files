import os
import shutil

from dotfiles import fs, module


class Alacritty(module.Definition):
    required = ["nerd_fonts"]

    @property
    def _cfg_file_src(self):
        return os.path.join(self.mod_dir, "alacritty.yml")

    @property
    def _cfg_file_dest(self):
        return os.path.join(self.home_dir, ".config", "alacritty",
                            "alacritty.yml")

    @module.update
    @module.install
    def install(self):
        if not shutil.which("alacritty"):
            self.log.info("alacritty not installed. Skipping")
            return
        fs.safe_link_file(self._cfg_file_src, self._cfg_file_dest)


if __name__ == "__main__":
    module.run(Alacritty)
