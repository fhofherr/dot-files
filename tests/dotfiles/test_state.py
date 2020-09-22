import json
import os
import textwrap

import pytest

from dotfiles import state


class TestState:
    def test_values(self):
        st = state.State("test")
        assert "default" == st.get("key", "default")

        st.put("key", "something")
        assert "something" == st.get("key")

        st.delete("key")
        assert not st.get("key")

        st.delete("key")

    def test_environment_variables(self):
        st = state.State("test")
        varname = "SOME_VAR"

        assert "default" == st.getenv(varname, "default")

        st.setenv(varname, "value")
        assert "value" == st.getenv(varname)

        st.setenv(varname, 12345)
        assert 12345 == st.getenv(varname)

        st.delenv(varname)
        assert not st.getenv(varname)

        st.delenv(varname)

    def test_environment_variables_path_treatment(self):
        st = state.State("test")

        assert [] == st.getenv("PATH")
        assert [] == st.getenv("PATH", default="ignored")

        st.setenv("PATH", "./some/dir")
        assert ["./some/dir"] == st.getenv("PATH")

        st.setenv("PATH", "./another/dir")
        assert ["./some/dir", "./another/dir"] == st.getenv("PATH")

        # Deduplication
        st.setenv("PATH", "./another/dir")
        assert ["./some/dir", "./another/dir"] == st.getenv("PATH")

        path = st.getenv("PATH")
        path.append("./yet/another/dir")
        assert ["./some/dir", "./another/dir"] == st.getenv("PATH")

    def test_add_alias(self):
        st = state.State("test")

        st.add_alias("l", "ls --color=auto")
        assert st.get_alias("l") == "ls --color=auto"

        st.add_alias("l", "exa --color=auto")
        assert st.get_alias("l") == "exa --color=auto"

    def test_marshall_json(self):
        st = state.State("test")

        st.put("key", "some_value")
        st.setenv("PATH", "./some/dir")
        st.setenv("PATH", "./another/dir")
        st.add_alias("ls", "ls --color=auto")

        st.zsh.before_compinit_script = textwrap.dedent("""
        echo "Pre-compinit"
        """)

        st.zsh.after_compinit_script = textwrap.dedent("""
        echo "Post-compinit"
        """)

        expected = {
            "mod_name": st.mod_name,
            "values": {
                "key": "some_value",
            },
            "env": {
                "PATH": ["./some/dir", "./another/dir"]
            },
            "aliases": {
                "ls": "ls --color=auto"
            },
            "zsh": {
                "before_compinit_script": st.zsh.before_compinit_script,
                "after_compinit_script": st.zsh.after_compinit_script
            }
        }

        assert expected == st.marshal_json()


class TestAggregate:
    def test_cannot_overwrite_environment_variables(self):
        a = state.State("a")
        a.setenv("VAR", "val")

        agg = state.Aggregate()
        agg.add_state(a)
        assert agg._env["VAR"] == "val"

        with pytest.raises(ValueError):
            agg.add_state(a)

    def test_merge_and_depuplicate_path(self):
        a = state.State("a")
        a.setenv("PATH", "./just/once")
        a.setenv("PATH", "./something/else")
        b = state.State("b")
        b.setenv("PATH", "./just/once")
        b.setenv("PATH", "./totally/different")

        agg = state.Aggregate()
        agg.add_state(a)
        assert agg._env["PATH"] == ["./just/once", "./something/else"]

        agg.add_state(b)
        assert agg._env["PATH"] == [
            "./just/once", "./something/else", "./totally/different"
        ]

    def test_cannot_redefine_alias(self):
        a = state.State("a")
        a.add_alias("ls", "ls --color")

        agg = state.Aggregate()
        agg.add_state(a)
        agg._aliases["ls"] == "ls --color"

        with pytest.raises(ValueError):
            agg.add_state(a)

    def test_add_compinit_scripts(self):
        a = state.State("a")
        a.zsh.before_compinit_script = "before compinit a"
        a.zsh.after_compinit_script = "after compinit a"

        b = state.State("b")
        b.zsh.before_compinit_script = "before compinit b"
        b.zsh.after_compinit_script = "after compinit b"

        agg = state.Aggregate()
        agg.add_state(a)
        agg.add_state(b)

        assert agg._zsh_before_compinit_scripts == [
            "before compinit a", "before compinit b"
        ]
        assert agg._zsh_after_compinit_scripts == [
            "after compinit a", "after compinit b"
        ]


def test_save_state(tmpdir):
    st = state.State("test")

    st.put("key", "value")
    st.setenv("ENVVAR", "envvar value")

    state.save_state(tmpdir, st)

    st_path = os.path.join(tmpdir, f"{st.mod_name}.json")
    assert os.path.exists(st_path)

    with open(st_path) as f:
        actual = json.load(f)
    assert st.marshal_json() == actual


def test_load_missing_state(tmpdir):
    expected = state.State("test")
    actual = state.load_state(tmpdir, "test")
    assert expected.marshal_json() == actual.marshal_json()


def test_load_saved_state(tmpdir):
    expected = state.State("test")
    expected.put("key", "value")
    expected.setenv("PATH", "./some/dir")
    expected.add_alias("ls", "ls --color=auto")
    expected.zsh.before_compinit_script = textwrap.dedent("""
    echo "Before compinit"
    """)
    expected.zsh.after_compinit_script = textwrap.dedent("""
    echo "After compinit"
    """)
    state.save_state(tmpdir, expected)

    actual = state.load_state(tmpdir, "test")
    assert expected.marshal_json() == actual.marshal_json()
