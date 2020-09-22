import shutil

from dotfiles import module


class ExaLs(module.Definition):
    name = "exa_ls"
    tags = ["essential"]

    @property
    def ls_cmd(self):
        return shutil.which("ls")

    @property
    def exa_cmd(self):
        return shutil.which("exa")

    @module.update
    @module.install
    def configure(self):
        ls = self.ls_cmd
        exa = self.exa_cmd

        self.state.add_alias("ls", f"{ls} --color=auto")
        if exa:
            self.state.add_alias("l", f"{exa} --color=auto")
            self.state.add_alias("ll", f"{exa} --color=auto --long")
            self.state.add_alias("la", f"{exa} --color=auto --long --all")
        else:
            self.state.add_alias("l", f"{ls} --color=auto")
            self.state.add_alias("ll", f"{ls} --color=auto -lh")
            self.state.add_alias("la", f"{ls} --color=auto -alh")
