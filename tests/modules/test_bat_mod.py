import os
import shutil

import pytest


@pytest.mark.module_test
@pytest.mark.skipif(shutil.which("bat") is None, reason="bat not installed")
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_install(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("bat", cmd, mock_argv)
    st = module_test_env.load_state("bat")

    assert os.path.exists(mod.cfg_file_dest)
    assert st.getenv("MANPAGER") == "sh -c 'col -bx | bat -l man -p'"
    assert st.get_alias("cat") == "bat"
