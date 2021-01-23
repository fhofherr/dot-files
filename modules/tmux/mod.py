import os
import shutil

from dotfiles import fs, module

TPM_REMOTE_REPO = "https://github.com/tmux-plugins/tpm"


class Tmux(module.Definition):
    required = ["git"]

    @property
    def tmux_cmd(self):
        return shutil.which("tmux")

    @property
    def _tmux_dir(self):
        return os.path.join(self.home_dir, ".tmux")

    @property
    def _tmux_plugin_dir(self):
        return os.path.join(self._tmux_dir, "plugins")

    @property
    def _tpm_dir(self):
        return os.path.join(self._tmux_plugin_dir, "tpm")

    @property
    def _plugin_installer(self):
        return os.path.join(self._tpm_dir, "bindings", "install_plugins")

    @property
    def _tmux_conf_src(self):
        return os.path.join(self.mod_dir, "tmux.conf")

    @property
    def _tmux_conf_dest(self):
        return os.path.join(self.home_dir, ".tmux.conf")

    @property
    def _tmux_terminfo_src(self):
        return os.path.join(self.mod_dir, "tmux.terminfo")

    @property
    def _tmux_bin_dir(self):
        return os.path.join(self.mod_dir, "bin")

    @module.update
    @module.install
    def install(self):
        if not self.tmux_cmd:
            self.log("Tmux not installed. Skipping")
            return
        fs.safe_link_file(self._tmux_conf_src, self._tmux_conf_dest)
        self.git.clone_or_update(TPM_REMOTE_REPO, self._tpm_dir)
        self._create_terminfo()
        self._install_plugins()

        self.state.setenv("PATH", self._tmux_bin_dir)
        self.state.add_alias("tas", "tmux attach -t")
        self.state.add_alias("tks", "tmux kill-session -t")
        self.state.add_alias("tls", "tmux ls")
        self.state.add_alias("tns", f"{self._tmux_bin_dir}/tmux-new-session")
        self.state.add_alias("tnw", "tmux new-window")
        self.state.add_alias("tss", "tmux switch-client -t")

    def _create_terminfo(self):
        self.log.info("create tmux terminfo")
        p = self.run_cmd("infocmp", "tmux-256color", check=False)
        if p.returncode > 0:
            self.run_cmd("tic", "-x", self._tmux_terminfo_src)

    def _install_plugins(self):
        session_name = "tmux_install"
        self("new-session", "-s", session_name, "-d")
        self("run-shell", self._plugin_installer)
        self("kill-session", "-t", session_name)

    @module.export
    def __call__(self, *args, **kwargs):
        return self.run_cmd(self.tmux_cmd, *args, **kwargs)


if __name__ == "__main__":
    module.run(Tmux)
