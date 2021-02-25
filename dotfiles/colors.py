import os

DEFAULT_COLOR_SCHEME = "gruvbox-dark"
ENV_VAR = "DOTFILES_COLOR_SCHEME"


def color_scheme():
    name = os.getenv(ENV_VAR)
    if not name:
        return DEFAULT_COLOR_SCHEME
    return name
