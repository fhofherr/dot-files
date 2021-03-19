import os
import shutil

from dotfiles import colors, module


class Alacritty(module.Definition):
    required = ["nerd_fonts"]

    @property
    def _scheme_file(self):
        scheme_name = colors.color_scheme()
        if scheme_name == "papercolor-dark":
            scheme_name = "base16-papercolor-dark-256"
        if scheme_name == "papercolor-light":
            scheme_name = "base16-papercolor-light-256"
        scheme_file = os.path.join(self.mod_dir, "colors",
                                   scheme_name + ".yml")
        if os.path.exists(scheme_file):
            return scheme_file
        self.log.info(f"Could not find color scheme file {scheme_file}")
        return None

    @property
    def _cfg_srcs(self):
        srcs = [os.path.join(self.mod_dir, "alacritty.common.yml")]
        if self._scheme_file:
            srcs.append(self._scheme_file)
        else:
            self.log.warn(
                f"Could not find alacritty theme: {colors.color_scheme()}")
        return srcs

    @property
    def _cfg_file_dest(self):
        return os.path.join(self.home_dir, ".config", "alacritty",
                            "alacritty.yml")

    @property
    def _alacritty_cfg(self):
        file_list = "\n".join(f"  - {p}" for p in self._cfg_srcs)
        return f"import:\n{file_list}"

    @module.update
    @module.install
    def install(self):
        if not shutil.which("alacritty"):
            self.log.info("alacritty not installed. Skipping")
            return
        with open(self._cfg_file_dest, "w") as f:
            f.write(self._alacritty_cfg)
        if self._scheme_file:
            self.state.setenv(colors.ENV_VAR, colors.color_scheme())


if __name__ == "__main__":
    module.run(Alacritty)
