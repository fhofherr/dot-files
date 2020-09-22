import os
import sys
import tempfile
from dataclasses import dataclass

import pytest

from dotfiles import fs, module, state

TESTS_DIR = os.path.dirname(os.path.abspath(os.path.realpath(__file__)))


@pytest.fixture()
def tmpfile(tmpdir):
    (h, p) = tempfile.mkstemp(dir=tmpdir)
    try:
        yield p
    finally:
        os.close(h)
        os.remove(p)


@pytest.fixture(scope="session")
def dotfiles_dir():
    return fs.find_dotfiles_dir()


@pytest.fixture(scope="session")
def modules_dir(dotfiles_dir):
    return os.path.join(dotfiles_dir, "modules")


@pytest.fixture()
def mock_argv(mocker):
    def do_mock(*args):
        mocker.patch.object(sys, "argv", list(args))

    return do_mock


@dataclass
class _ModuleTestEnv:
    modules_dir: str
    home_dir: str
    state_dir: str

    def argv(self, cmd):
        return [
            f"--modules-dir={self.modules_dir}", f"--home-dir={self.home_dir}",
            f"--state-dir={self.state_dir}", cmd
        ]

    def load_state(self, mod_name):
        return state.load_state(self.state_dir, mod_name)

    def run_module(self, mod_name, cmd, mock_argv) -> module.Definition:
        mock_argv(*self.argv(cmd))
        mods = module.run(only=mod_name)
        assert mods
        for mod in mods:
            if mod.name == mod_name:
                return mod


@pytest.fixture(scope="session")
def module_test_env(request, modules_dir):
    with tempfile.TemporaryDirectory() as tmpdir:
        home_dir = os.path.join(tmpdir, "home")
        os.makedirs(home_dir, exist_ok=True)
        state_dir = os.path.join(tmpdir, "state")
        os.makedirs(state_dir, exist_ok=True)
        yield _ModuleTestEnv(modules_dir, home_dir, state_dir)
