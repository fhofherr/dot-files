import os

import pytest

from dotfiles import module


@pytest.mark.module_test
@pytest.mark.parametrize("cmd", ["install"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("asdf", cmd, mock_argv)
    st = module_test_env.load_state("asdf")

    assert os.path.exists(mod.asdf_dir)
    assert os.path.dirname(mod.asdf_cmd) in st.getenv("PATH")
    assert st.zsh.after_compinit_script
