import os

from dotfiles import fs, module


class XRDB(module.Definition):
    hostnames = ["fhhc", "wintermute"]

    @property
    def _cfg_src(self):
        return os.path.join(self.mod_dir, "Xresources")

    @property
    def _cfg_dest(self):
        return os.path.join(self.home_dir, ".Xresources")

    @module.install
    @module.update
    def install(self):
        fs.safe_link_file(self._cfg_src, self._cfg_dest)


if __name__ == "__main__":
    module.run(XRDB)
