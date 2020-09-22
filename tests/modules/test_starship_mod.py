import os

import pytest


@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("starship", cmd, mock_argv)
    st = module_test_env.load_state("starship")

    assert os.path.exists(mod.starship_cmd)
    assert mod.bin_dir in st.getenv("PATH")
