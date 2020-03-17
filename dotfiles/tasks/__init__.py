from invoke import Collection, task

from dotfiles import common
from dotfiles.tasks import (asdf, buf, dbcli, direnv, editorconfig, git,
                            golang, golangci_lint, httpie, kitty, kubectl,
                            neovim, overmind, pipx, platformio, pre_commit,
                            python, tests, zsh)


@task
def install(c, home_dir=common.HOME_DIR):
    dbcli.install(c, home_dir=home_dir)
    asdf.install(c, home_dir=home_dir)
    direnv.install(c, home_dir=home_dir)
    git.install(c, home_dir=home_dir)
    buf.install(c, home_dir=home_dir)
    golang.install(c, home_dir=home_dir, install_missing_go=True)
    golangci_lint.install(c, home_dir=home_dir)
    httpie.install(c, home_dir=home_dir)
    overmind.install(c, home_dir=home_dir)
    pipx.install(c, home_dir=home_dir)
    platformio.install(c, home_dir=home_dir)
    pre_commit.install(c, home_dir=home_dir)
    python.install(c, home_dir=home_dir, install_missing_poetry=False)
    neovim.install(c, home_dir=home_dir)
    zsh.install(c, home_dir=home_dir)

    kubectl.configure(c, home_dir=home_dir)
    editorconfig.configure(c, home_dir)
    kitty.configure(c, home_dir)

    zsh.write_dotfiles_zsh_config(c, home_dir)


@task
def test(c):
    print("test")


def get_ns():
    ns = Collection()
    ns.add_task(install)
    ns.add_task(test)

    ns.add_collection(dbcli)
    ns.add_collection(asdf)
    ns.add_collection(direnv)
    ns.add_collection(editorconfig)
    ns.add_collection(kitty)
    ns.add_collection(git)
    ns.add_collection(buf)
    ns.add_collection(golang)
    ns.add_collection(golangci_lint)
    ns.add_collection(httpie)
    ns.add_collection(kubectl)
    ns.add_collection(overmind)
    ns.add_collection(pipx)
    ns.add_collection(platformio)
    ns.add_collection(pre_commit)
    ns.add_collection(python)
    ns.add_collection(neovim)
    ns.add_collection(zsh)

    ns.add_collection(tests)

    return ns
