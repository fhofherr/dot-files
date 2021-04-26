import os
import textwrap

from dotfiles import module


class SSH(module.Definition):
    tags = ["essential"]

    @property
    def ssh_config_txt(self):
        return textwrap.dedent(f"""
        Include {os.path.join(self.mod_dir, "ssh_config.common")}
        """)

    @property
    def ssh_bin_dir(self):
        return os.path.join(self.mod_dir, "bin")

    @property
    def ssh_config_dir(self):
        return os.path.join(self.home_dir, ".ssh")

    @property
    def ssh_config(self):
        return os.path.join(self.ssh_config_dir, "config")

    @property
    def after_compinit_script(self):
        return textwrap.dedent(f"""
        source <({self.ssh_bin_dir}/ssh_start_agent -t {3600 * 12} -p 2> "$HOME"/.ssh/start_agent.log)
        """)

    @module.update
    @module.install
    def install(self):
        os.makedirs(self.ssh_config_dir, mode=0o700, exist_ok=True)
        with open(self.ssh_config, "w") as f:
            f.write(self.ssh_config_txt)

        self.state.setenv("PATH", self.ssh_bin_dir)
        self.state.zsh.after_compinit_script = self.after_compinit_script


if __name__ == "__main__":
    module.run(SSH)
