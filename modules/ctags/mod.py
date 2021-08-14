import os
import shutil

from dotfiles import fs, module


class Ctags(module.Definition):
    # Actually this is always for universal-ctags

    @property
    def ctags_default_config_src(self):
        return os.path.join(self.mod_dir, "defaults.ctags")

    @property
    def ctags_default_config_dest(self):
        return os.path.join(self.home_dir, ".config", "ctags",
                            "defaults.ctags")

    @module.install
    @module.update
    def install(self):
        if not shutil.which("ctags"):
            return
        fs.safe_link_file(self.ctags_default_config_src,
                          self.ctags_default_config_dest)


if __name__ == "__main__":
    module.run(Ctags)
