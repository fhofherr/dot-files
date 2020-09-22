import os

import pytest


@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("zsh", cmd, mock_argv)

    assert os.path.exists(os.path.join(module_test_env.home_dir, ".zprofile"))
    assert os.path.exists(os.path.join(module_test_env.home_dir, ".zshenv"))
    assert os.path.exists(os.path.join(module_test_env.home_dir, ".zshrc"))
    assert os.path.exists(os.path.join(mod.plugin_dir, "vanilli.sh"))
    assert os.path.exists(os.path.join(mod.plugin_dir, "zsh-z"))
    assert os.path.exists(os.path.join(mod.plugin_dir, "zsh-autosuggestions"))
