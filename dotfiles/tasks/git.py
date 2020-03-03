import os

from invoke import task

from dotfiles import common, state


@task
def install(c, home_dir=common.HOME_DIR):
    # TODO consider using the configparser module for this. The current
    # implementation makes it impossible to test this without affecting the
    # actual git configuration.
    gitignore_global = os.path.join(common.ROOT_DIR, "configs", "git",
                                    "gitignore_global")
    c.run(f"git config --global core.excludesfile {gitignore_global}")

    gitconfig_common = os.path.join(common.ROOT_DIR, "configs", "git",
                                    "gitconfig.common")
    c.run(f"git config --global include.path {gitconfig_common}")

    git_utils_bin = os.path.join(common.ROOT_DIR, "configs", "git", "bin")
    git_state = state.State(name="git")
    git_state.put_env("PATH", git_utils_bin)
    state.write_state(home_dir, git_state)
