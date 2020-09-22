import os

import pytest


@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("fzf", cmd, mock_argv)
    st = module_test_env.load_state("fzf")

    assert os.path.exists(mod._repo_dir)
    assert mod._fzf_bin_dir in st.getenv("PATH")
