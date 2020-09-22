import os

from dotfiles import fs, module


class Editorconfig(module.Definition):
    tags = ["essential"]

    @property
    def editorconfig_src(self):
        return os.path.join(self.mod_dir, "editorconfig")

    @property
    def editorconfig_dest(self):
        return os.path.join(self.home_dir, ".editorconfig")

    @module.update
    @module.install
    def configure(self):
        fs.safe_link_file(self.editorconfig_src, self.editorconfig_dest)
