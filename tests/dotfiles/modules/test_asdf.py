from dotfiles.modules import asdf


def test_parse_tool_versions():
    asdf_plugins = asdf.parse_tool_versions(asdf.TOOL_VERSIONS)

    assert "golang" in asdf_plugins
    assert "python" in asdf_plugins
    assert "nodejs" in asdf_plugins
