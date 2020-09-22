import os
import re

from dotfiles import module

REPO_URL = "https://github.com/asdf-vm/asdf.git"


class ASDF(module.Definition):
    required = ["git"]

    @property
    def asdf_dir(self):
        return os.path.join(self.home_dir, ".asdf")

    @property
    def asdf_bin_dir(self):
        return os.path.join(self.asdf_dir, "bin")

    @property
    def asdf_cmd(self):
        return os.path.join(self.asdf_bin_dir, "asdf")

    @module.install
    def install_asdf(self):
        self.git.clone_or_update(REPO_URL, self.asdf_dir)
        self.state.setenv("PATH", self.asdf_bin_dir)
        self._add_zsh_completions()

    @module.update
    def update_asdf(self):
        self("update")

    def _add_zsh_completions(self):
        init_file = os.path.join(self.asdf_dir, "asdf.sh")
        if not os.path.exists(init_file):
            self.log.warn(f"{init_file} does not exist")
            return

        with open(init_file) as f:
            script = f.read()
            script = re.sub(
                r"^ASDF_DIR=.+$",
                f'\nASDF_DIR="{self.asdf_dir}"\n',
                script,
                flags=re.MULTILINE,
            )
            self.state.zsh.after_compinit_script = script

    @module.export
    def __call__(self, *args, **kwargs):
        return self.run_cmd(self.asdf_cmd, *args, **kwargs)

    @module.export
    def install(self,
                asdf_plugin,
                version,
                asdf_plugin_url=None,
                add_global=False):
        """
        Install a tool managed by the asdf_plugin.

        Install the required plugin if it is not yet installed. See
        install_plugin for details.

        If add_global is True the passed version is added to the .tool-versions
        file in self.home_dir.
        """
        raise NotImplementedError

    @module.export
    def install_plugin(self, asdf_plugin, asdf_plugin_url=None):
        """
        Install the asdf_plugin.

        If asdf_plugin_url is not None the plugin will be obtained from that
        url. Otherwise it needs to be listed by `asdf plugin list all`.
        """
        raise NotImplementedError


if __name__ == "__main__":
    module.run(ASDF)
