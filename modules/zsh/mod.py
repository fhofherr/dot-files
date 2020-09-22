import os
import textwrap

from dotfiles import fs, module, zsh

BEFORE_COMPINIT_PLUGINS = [
    zsh.Plugin("https://github.com/yous/vanilli.sh", "vanilli.zsh"),
    zsh.Plugin("https://github.com/agkozak/zsh-z", "zsh-z.plugin.zsh"),
]
AFTER_COMPINIT_PLUGINS = [
    zsh.Plugin("https://github.com/zsh-users/zsh-autosuggestions",
               "zsh-autosuggestions.zsh"),
]


class Zsh(module.Definition):
    required = ["git"]
    tags = ["essential"]

    @property
    def plugin_dir(self):
        return os.path.join(self.local_dir, "plugins")

    @module.update
    @module.install
    def install(self):
        for f in ("zprofile", "zshenv", "zshrc"):
            fs.safe_link_file(os.path.join(self.mod_dir, f),
                              os.path.join(self.home_dir, f".{f}"))

        self.state.zsh.before_compinit_script = self._install_plugins(
            BEFORE_COMPINIT_PLUGINS)

        with open(os.path.join(self.mod_dir, "after_compinit.zsh")) as f:
            self.state.zsh.after_compinit_script = f.read()

        self.state.zsh.after_compinit_script = textwrap.dedent(f"""
        {self.state.zsh.after_compinit_script}
        {self._install_plugins(AFTER_COMPINIT_PLUGINS)}
        """)

    def _install_plugins(self, plugins):
        return "\n".join(self._install_plugin(p) for p in plugins)

    def _install_plugin(self, plugin):
        plugin_name = plugin.url.split("/")[-1]
        plugin_dir = os.path.join(self.plugin_dir, plugin_name)
        self.git.clone_or_update(plugin.url, plugin_dir)
        return plugin.init_script(plugin_dir)
