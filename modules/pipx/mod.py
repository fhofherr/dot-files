import os
import venv

from dotfiles import module


class PipxError(Exception):
    pass


class Pipx(module.Definition):
    @property
    def _venv_dir(self):
        return os.path.join(self.local_dir, "venv")

    @property
    def _venv_bin_dir(self):
        return os.path.join(self._venv_dir, "bin")

    @property
    def _pipx_home(self):
        return os.path.join(self.local_dir, "home")

    @property
    def pipx_bin_dir(self):
        return os.path.join(self.local_dir, "bin")

    @property
    def _env(self):
        return {
            "PIPX_HOME": self._pipx_home,
            "PIPX_BIN_DIR": self.pipx_bin_dir,
        }

    @property
    def _pipx_python(self):
        return os.path.join(self._venv_bin_dir, "python")

    @module.export
    def __call__(self, *args, **kwargs):
        cmd = os.path.join(self._venv_bin_dir, "pipx")
        p = self.run_cmd(cmd, *args, **kwargs, env=self._env, check=False)
        if p.returncode not in (0, 1):
            raise PipxError(f"'{cmd} {' '.join(args)}' failed")
        return p

    @module.export
    def install(self, pkg, force=False, system_site_packages=False):
        args = ["install"]
        if force:
            args.append("--force")
        if system_site_packages:
            args.append("--system-site-packages")
        args.append(pkg)
        self(*args)

    @module.export
    def update(self, pkg, force=False, system_site_packages=False):
        args = ["upgrade"]
        if force:
            args.append("--force")
        if system_site_packages:
            args.append("--system-site-packages")
        args.append(pkg)
        self(*args)

    @module.export
    def inject(self,
               pkg,
               *deps,
               update=False,
               force=False,
               system_site_packages=False):
        pip_args = []
        if update:
            pip_args.append("--upgrade")

        args = ["inject"]
        if force:
            args.append("--force")
        if system_site_packages:
            args.append("--system-site-packages")
        if pip_args:
            args.append(f"--pip-args=\"{' '.join(pip_args)}\"")
        args.append(pkg)
        args.extend(deps)
        self(*args)

    @module.install
    def install_pipx(self):
        venv.create(self._venv_dir, clear=True, with_pip=True)
        self.update_pipx()
        self.state.setenv("PATH", self.pipx_bin_dir)
        for k, v in self._env.items():
            self.state.setenv(k, v)

    @module.update
    def update_pipx(self):
        self.run_cmd(self._pipx_python, "-m", "pip", "install", "--upgrade",
                     "pip")
        self.run_cmd(self._pipx_python, "-m", "pip", "install", "--upgrade",
                     "pipx")
