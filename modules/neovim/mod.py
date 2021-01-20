import os
import shutil
import venv

from dotfiles import fs, module

PYTHON_VENV_PACKAGES = ["pynvim"]
PYTHON_TOOLS_AND_LINTERS = [
    "ansible-lint", "gitlint", "neovim-remote", "yamllint"
]


class NeoVim(module.Definition):
    required = ["pipx"]
    optional = ["delta"]

    @property
    def _venv_dir(self):
        return os.path.join(self.local_dir, "venv")

    @property
    def _venv_bin_dir(self):
        return os.path.join(self._venv_dir, "bin")

    @property
    def _nvim_python_host(self):
        return os.path.join(self._venv_bin_dir, "python")

    @property
    def _nvim_cfg_src(self):
        return self.mod_dir

    @property
    def _nvim_cfg_dest(self):
        return os.path.join(self.home_dir, ".config", "nvim")

    @property
    def _init_vim(self):
        return os.path.join(self._nvim_cfg_dest, "init.vim")

    @property
    def _vimplug_home(self):
        return os.path.join(self.local_dir, "vimplug")

    @property
    def _env(self):
        return {
            "DOTFILES_NEOVIM_PYTHON3": self._nvim_python_host,
            "VIMPLUG_HOME": self._vimplug_home,
            "VIMHOME": self._nvim_cfg_dest,
            "EDITOR": self.nvim_cmd,
            "HOME": self.home_dir,
        }

    @property
    def _aliases(self):
        return {
            "vim": self.nvim_cmd,
            "view": f"{self.nvim_cmd} -R",
        }

    @property
    def nvim_cmd(self):
        return shutil.which("nvim")

    @property
    def _after_compinit_script(self):
        return os.path.join(self.mod_dir, "after_compinit.sh")

    @module.install
    def install_neovim_cfg(self):
        if not self.nvim_cmd:
            self.log.info("NeoVim is not installed or not on path")
            return
        venv.create(self._venv_dir, clear=True, with_pip=True)
        for pkg in PYTHON_TOOLS_AND_LINTERS:
            self.pipx.install(pkg)

        self.update_neovim_cfg()

    @module.update
    def update_neovim_cfg(self):
        self.run_cmd(self._nvim_python_host, "-m", "pip", "install",
                     "--upgrade", "pip")
        for pkg in PYTHON_VENV_PACKAGES:
            self.run_cmd(self._nvim_python_host, "-m", "pip", "install",
                         "--upgrade", pkg)
        for pkg in PYTHON_TOOLS_AND_LINTERS:
            self.pipx.update(pkg)

        for k, v in self._env.items():
            self.state.setenv(k, v)
        for k, v in self._aliases.items():
            self.state.add_alias(k, v)

        with open(self._after_compinit_script) as f:
            self.state.zsh.after_compinit_script = f.read()

        fs.safe_link_file(self._nvim_cfg_src, self._nvim_cfg_dest)

        # The last step that remains is to update/install all plugins.
        self.update_plugins()

    def update_plugins(self):
        env = self._env
        env["PATH"] = os.environ["PATH"]
        self("+PlugUpdate", "+qall!", env=env)

    def __call__(self, *args, **kwargs):
        if "env" not in kwargs:
            kwargs["env"] = self._env
        self.run_cmd(self.nvim_cmd, "-u", self._init_vim, "--headless", *args,
                     **kwargs)


if __name__ == "__main__":
    module.run(NeoVim)
