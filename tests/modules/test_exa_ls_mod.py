import os
import shutil

import pytest


@pytest.mark.module_test
@pytest.mark.skipif(shutil.which("exa") is None, reason="exa not installed")
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_configure_exa(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("exa_ls", cmd, mock_argv)
    st = module_test_env.load_state("exa_ls")

    assert st.get_alias("ls") == f"{mod.ls_cmd} --color=auto"
    assert st.get_alias("l") == f"{mod.exa_cmd} --color=auto"
    assert st.get_alias("ll") == f"{mod.exa_cmd} --color=auto --long"
    assert st.get_alias("la") == f"{mod.exa_cmd} --color=auto --long --all"


@pytest.mark.module_test
@pytest.mark.skipif(shutil.which("exa") is not None, reason="exa installed")
@pytest.mark.parametrize("cmd", ["install", "update"])
def test_configure_ls(module_test_env, mock_argv, cmd):
    mod = module_test_env.run_module("exa_ls", cmd, mock_argv)
    st = module_test_env.load_state("exa_ls")

    assert st.get_alias("ls") == f"{mod.ls_cmd} --color=auto"
    assert st.get_alias("l") == f"{mod.ls_cmd} --color=auto"
    assert st.get_alias("ll") == f"{mod.ls_cmd} --color=auto -lh"
    assert st.get_alias("la") == f"{mod.ls_cmd} --color=auto -alh"
