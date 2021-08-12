import os
import shutil

from dotfiles import module


class Rust(module.Definition):
    @module.install
    @module.update
    def install(self):
        # I'm not really into rust currently. But I do install some rust tools
        # using cargo. As such I want the cargo bin dir on my path.
        if not shutil.which("cargo"):
            return
        self.state.setenv("PATH", os.path.join(self.home_dir, ".cargo", "bin"))

if __name__ == "__main__":
    module.run(Rust)
