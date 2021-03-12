import os
import textwrap

from dotfiles import fs, module

NB_REPO_URL = "https://github.com/xwmx/nb"


class Nb(module.Definition):
    required = ["git"]

    @property
    def nb_cmd(self):
        return os.path.join(self.bin_dir, "nb")

    @property
    def _dest_dir(self):
        return os.path.join(self.local_dir, "nb")

    @property
    def _cmd_src(self):
        return os.path.join(self._dest_dir, "nb")

    @property
    def _zsh_fpath(self):
        return os.path.join(self.local_dir, "zsh")

    @property
    def _zsh_completions_src(self):
        return os.path.join(self._dest_dir, "etc", "nb-completion.zsh")

    @property
    def _zsh_completions_dest(self):
        return os.path.join(self._zsh_fpath, "_nb")

    @module.update
    @module.install
    def install(self):
        self.git.clone_or_update(NB_REPO_URL,
                                 self._dest_dir,
                                 branch="latest_tag")
        fs.safe_link_file(self._cmd_src, self.nb_cmd)
        fs.safe_link_file(self._zsh_completions_src,
                          self._zsh_completions_dest)
        self.state.zsh.before_compinit_script = textwrap.dedent(f"""
        fpath+=({self._zsh_fpath})
        """)
        self.state.setenv("PATH", self.bin_dir)


if __name__ == "__main__":
    module.run(Nb)
