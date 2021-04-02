import os
import shutil
import venv

from dotfiles import fs, module

NEOVIM_REPO = "https://github.com/neovim/neovim"

PYTHON_VENV_PACKAGES = ["pynvim"]
PYTHON_TOOLS_AND_LINTERS = [
    "ansible-lint", "gitlint", "neovim-remote", "yamllint"
]


class NeoVim(module.Definition):
    required = ["pipx"]
    optional = ["git"]

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
    def _shims_dir(self):
        return os.path.join(self.mod_dir, "shims")

    @property
    def _neovim_master_dir(self):
        return os.path.join(self.projects_dir, "github.com", "neovim",
                            "neovim")

    @property
    def _nvim_master_prefix(self):
        return os.path.join(self.local_dir, "nvim_master")

    @property
    def _nvim_master_cmd(self):
        cmd = os.path.join(self._nvim_master_prefix, "bin", "nvim")
        if os.path.exists(cmd):
            return cmd
        return None

    @property
    def nvim_cmd(self):
        if self._nvim_master_cmd:
            return self._nvim_master_cmd
        return shutil.which("nvim")

    @property
    def nvr_cmd(self):
        cmd = os.path.join(self.pipx.pipx_bin_dir, "nvr")
        if not os.path.exists(cmd):
            return None
        return cmd

    @property
    def _env(self):
        return {
            "DOTFILES_NEOVIM_PYTHON3": self._nvim_python_host,
            "DOTFILES_NEOVIM_COMMAND": self.nvim_cmd,
            "DOTFILES_NVR_COMMAND": self.nvr_cmd,
            "VIMPLUG_HOME": self._vimplug_home,
            "VIMHOME": self._nvim_cfg_dest,
            "EDITOR": self._get_shim("nvim"),
            "GIT_EDITOR": self._get_shim("giteditor"),
            "HOME": self.home_dir,
        }

    @property
    def _aliases(self):
        return {
            "vim": self._get_shim("nvim"),
        }

    def _get_shim(self, name):
        return os.path.join(self._shims_dir, name)

    @module.install
    def install_neovim_cfg(self):
        if not self.nvim_cmd:
            self.log.info("NeoVim is not installed or not on path")
            return
        venv.create(self._venv_dir, clear=True, with_pip=True)
        for pkg in PYTHON_TOOLS_AND_LINTERS:
            self.pipx.install(pkg)

        self.state.setenv("PATH", self._shims_dir)
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

        # Make sure to remove DOTFILES_NEOVIM_COMMAND from state when
        # removing or commenting out this line.
        self._install_neovim_master()

        for k, v in self._env.items():
            self.state.setenv(k, v)
        for k, v in self._aliases.items():
            self.state.add_alias(k, v)

        fs.safe_link_file(self._nvim_cfg_src, self._nvim_cfg_dest)

        # The last step that remains is to update/install all plugins.
        self.update_plugins()

    def _install_neovim_master(self):
        if not self.git:
            self.log.info("Git not available. Cannot install neovim master")
            return

        # Ensure we don't use any lua interpreter that might be installed
        # on the target system.
        if "LUA_PATH" in os.environ:
            del os.environ["LUA_PATH"]
        if "LUA_CPATH" in os.environ:
            del os.environ["LUA_CPATH"]

        self.log.info("Installing neovim from master")
        self.git.clone_or_update(NEOVIM_REPO, self._neovim_master_dir)
        self.run_cmd("make",
                     "-j9",
                     "CMAKE_BUILD_TYPE=Release",
                     f"CMAKE_INSTALL_PREFIX={self._nvim_master_prefix}",
                     "install",
                     cwd=self._neovim_master_dir)

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
