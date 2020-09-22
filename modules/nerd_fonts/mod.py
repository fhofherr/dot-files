import os

from dotfiles import module

# Note: you will still need to install an emoji font, e.g. noto-emoji

NERD_FONTS_REPO_URL = "https://github.com/ryanoasis/nerd-fonts.git"
NERD_FONTS_VERSION = "v2.1.0"
FONTS = ["Iosevka", "FiraCode"]


class NerdFonts(module.Definition):
    name = "nerd_fonts"
    required = ["git"]

    @property
    def _dest_dir(self):
        return os.path.join(self.local_dir, "nerd-fonts")

    def install_font(self, font_name):
        self.run_cmd("./install.sh", font_name, cwd=self._dest_dir)

    @module.update
    @module.install
    def install(self):
        self.git.clone_or_update(NERD_FONTS_REPO_URL,
                                 self._dest_dir,
                                 depth=1,
                                 branch=NERD_FONTS_VERSION)
        for font_name in FONTS:
            self.install_font(font_name)
