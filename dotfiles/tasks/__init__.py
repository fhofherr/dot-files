from invoke import Collection, task

from dotfiles import common
from dotfiles.tasks import (alacritty, antibody, asdf, bat, buf, dbcli, direnv,
                            editorconfig, fzf, git, golang, golangci_lint,
                            httpie, kitty, kubectl, neovim, nerd_fonts,
                            overmind, pipx, platformio, pre_commit, python,
                            tests, zsh)


@task
def install(c, home_dir=common.HOME_DIR):
    antibody.install(c, home_dir=home_dir)
    dbcli.install(c, home_dir=home_dir)
    asdf.install(c, home_dir=home_dir)
    direnv.install(c, home_dir=home_dir)
    git.install(c, home_dir=home_dir)
    buf.install(c, home_dir=home_dir)
    golang.install(c, home_dir=home_dir, install_missing_go=True)
    golangci_lint.install(c, home_dir=home_dir)
    httpie.install(c, home_dir=home_dir)
    overmind.install(c, home_dir=home_dir)
    platformio.install(c, home_dir=home_dir)
    pre_commit.install(c, home_dir=home_dir)
    fzf.install(c, home_dir=home_dir)
    python.install(c, home_dir=home_dir, install_missing_poetry=False)
    neovim.install(c, home_dir=home_dir)
    zsh.install(c, home_dir=home_dir)

    alacritty.configure(c, home_dir)
    bat.configure(c, home_dir=home_dir)
    kubectl.configure(c, home_dir=home_dir)
    editorconfig.configure(c, home_dir)
    kitty.configure(c, home_dir)

    zsh.write_dotfiles_zsh_config(c, home_dir)


@task
def update(c, home_dir=common.HOME_DIR, upgrade=False, reconfigure=False):
    antibody.update(c, home_dir, upgrade=upgrade, reconfigure=reconfigure)
    neovim.update(c, home_dir, reconfigure=reconfigure)
    dbcli.update(c, home_dir=home_dir)
    asdf.update(c, home_dir, reconfigure=reconfigure)
    direnv.update(c, home_dir=home_dir, reconfigure=reconfigure)
    buf.update(c, home_dir=home_dir, reconfigure=reconfigure)
    golang.update_dev_tools(c, home_dir=home_dir)
    golangci_lint.update(c, home_dir=home_dir, reconfigure=reconfigure)
    httpie.update(c, home_dir=home_dir)
    overmind.update(c, home_dir=home_dir, reconfigure=reconfigure)
    platformio.update(c, home_dir=home_dir)
    pre_commit.update(c, home_dir=home_dir)
    fzf.update(c, home_dir=home_dir, reconfigure=reconfigure)

    if reconfigure:
        zsh.write_dotfiles_zsh_config(c, home_dir)


@task
def test(c):
    print("test")


def get_ns():
    ns = Collection()
    ns.add_task(install)
    ns.add_task(update)
    ns.add_task(test)

    ns.add_collection(alacritty)
    ns.add_collection(antibody)
    ns.add_collection(bat)
    ns.add_collection(dbcli)
    ns.add_collection(asdf)
    ns.add_collection(direnv)
    ns.add_collection(editorconfig)
    ns.add_collection(fzf)
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
    ns.add_collection(nerd_fonts)
    ns.add_collection(zsh)

    ns.add_collection(tests)

    return ns
