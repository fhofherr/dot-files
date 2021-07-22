import os

from dotfiles import module

MNML_PKG = "github.com/fhofherr/mnml/cmd/mnml"


class MNML(module.Definition):
    required = ["golang"]
    hostnames = ["wintermute"]

    def _mnml_cmd(self):
        return os.path.join(self.golang.go_bin_dir, "mnml")

    @module.update
    @module.install
    def install(self):
        self.golang.go_get(MNML_PKG)


if __name__ == "__main__":
    module.run(MNML)
