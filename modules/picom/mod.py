import os
import shutil

from dotfiles import fs, module


class Picom(module.Definition):
    hostnames = ["fhhc", "wintermute"]

    @property
    def _cfg_src(self):
        return os.path.join(self.mod_dir, "picom.conf")

    @property
    def _cfg_dest(self):
        return os.path.join(self.home_dir, ".config", "picom", "picom.conf")

    @module.install
    @module.update
    def install(self):
        if not shutil.which("picom"):
            self.log.info("picom not installed.")
            return
        fs.safe_link_file(self._cfg_src, self._cfg_dest)


if __name__ == "__main__":
    module.run(Picom)
