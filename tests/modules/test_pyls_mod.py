import os

import pytest


@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("pyls", cmd, mock_argv)
    assert os.path.exists(os.path.join(mod.pipx.pipx_bin_dir, "pyls"))
