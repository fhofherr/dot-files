import os

import pytest


@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("direnv", cmd, mock_argv)
    st = module_test_env.load_state("direnv")

    assert mod.bin_dir in st.getenv("PATH")
    assert os.path.exists(mod._direnvrc_dest)
    assert os.path.exists(mod.direnv_cmd)
