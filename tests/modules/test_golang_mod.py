import os

import pytest



@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("golang", cmd, mock_argv)
    st = module_test_env.load_state("golang")

    assert mod.helper_scripts_dir in st.getenv("PATH")
    assert mod.go_bin_dir in st.getenv("PATH")
    assert mod.go_proxy == st.getenv("GOPROXY")
