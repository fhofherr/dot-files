import os
import tempfile

from dotfiles import module


class Golang(module.Definition):
    # required = ["asdf"]  # TODO could be an optional dependency

    # Go development tools I install from source.
    _golang_dev_tools = [
        "github.com/aarzilli/gdlv@latest",
        "github.com/fatih/gomodifytags@latest",
        "github.com/go-delve/delve/cmd/dlv@latest",
        "github.com/goreleaser/goreleaser@latest",
        "github.com/mgechev/revive@latest",
        "github.com/psampaz/go-mod-outdated@latest",
        "golang.org/x/lint/golint@latest",
        "golang.org/x/tools/cmd/godoc@latest",
        "golang.org/x/tools/cmd/goimports@latest",
        "golang.org/x/tools/cmd/stringer@latest",
        "golang.org/x/tools/gopls@latest",
    ]

    @property
    def helper_scripts_dir(self):
        return os.path.join(self.mod_dir, "bin")

    @property
    def go_bin_dir(self):
        # TODO: use the go executable to determine it
        return os.path.join(self.home_dir, "go", "bin")

    @property
    def go_proxy(self):
        return "https://proxy.golang.org,direct"

    @module.install
    @module.update
    def install(self):
        # Some distros disable GOPROXY, which leads to awkward bugs.
        # See
        #  * https://github.com/golang/go/issues/37140#issuecomment-583776533
        #  * https://github.com/golang/go/issues/34092
        self.state.setenv("GOPROXY", self.go_proxy)

        # TODO not sure if exporting GOBIN is really a good idea
        self.state.setenv("GOBIN", self.go_bin_dir)
        self.state.setenv("PATH", self.helper_scripts_dir)
        self.state.setenv("PATH", self.go_bin_dir)

        for url in self._golang_dev_tools:
            self.go_get(url)

    @module.export
    def __call__(self, *args, **kwargs):
        # TODO fall back to ASDF shim if go was not found in path
        return self.run_cmd("go", *args, **kwargs)

    @module.export
    def go_get(self, url, go_mod=True, bin_dir=None):
        env = {"GOPROXY": self.go_proxy, "HOME": self.home_dir}
        if go_mod:
            env["GO111MODULE"] = "on"

        if not bin_dir:
            bin_dir = self.go_bin_dir
        env["GOBIN"] = bin_dir

        with tempfile.TemporaryDirectory(prefix="dotfiles-go-get-") as tmpdir:
            return self("get", url, env=env, cwd=tmpdir)


if __name__ == "__main__":
    module.run(Golang)
