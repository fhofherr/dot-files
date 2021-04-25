import os

from dotfiles import fs, module


class Awesome(module.Definition):
    required = ["picom", "xrdb"]

    @property
    def _cfg_src(self):
        return self.mod_dir

    @property
    def _cfg_dest(self):
        return os.path.join(self.home_dir, ".config", "awesome")

    @module.install
    @module.update
    def install(self):
        fs.safe_link_file(self._cfg_src, self._cfg_dest)


if __name__ == "__main__":
    module.run(Awesome)
