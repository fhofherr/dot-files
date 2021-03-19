import os
import textwrap

from dotfiles import module


class Git(module.Definition):
    tags = ["essential"]
    optional = ["git_delta"]

    @property
    def gitconfig_common_path(self):
        return os.path.join(self.mod_dir, "gitconfig.common")

    @property
    def gitignore_global_path(self):
        return os.path.join(self.mod_dir, "gitignore_global")

    @property
    def git_bin_dir(self):
        return os.path.join(self.mod_dir, "bin")

    @property
    def _git_pager(self):
        if not self.git_delta:
            return ""
        return f"pager = {self.git_delta.delta_cmd} --syntax-theme='{self.git_delta.syntax_theme}'"

    @property
    def _git_diff_filter(self):
        if not self.git_delta:
            return ""
        return f"diffFilter = delta --syntax-theme='{self.git_delta.syntax_theme}' --color-only"

    @property
    def gitconfig_local_text(self):
        return textwrap.dedent("""
        [user]
            name = Ferdinand Hofherr
            email = mail@ferdinandhofherr.de
        """)

    @property
    def gitconfig_text(self):
        return textwrap.dedent(f"""
        [core]
            excludesfile = {self.gitignore_global_path}
            {self._git_pager}
        [interactive]
            {self._git_diff_filter}
        [include]
            path = {self.gitconfig_common_path}
        [include]
            path = {self.gitconfig_local_dest}
        """)

    @property
    def gitconfig_dest(self):
        return os.path.join(self.home_dir, ".gitconfig")

    @property
    def gitconfig_local_dest(self):
        return os.path.join(self.home_dir, ".gitconfig.local")

    @module.update
    @module.install
    def configure_git(self):
        self.state.setenv("PATH", self.git_bin_dir)
        self.state.add_alias("g", "git")
        if not os.path.exists(self.gitconfig_local_dest):
            with open(self.gitconfig_local_dest, "w") as f:
                f.write(self.gitconfig_local_text)
        with open(self.gitconfig_dest, "w") as f:
            f.write(self.gitconfig_text)

    @module.export
    def __call__(self, *args, **kwargs):
        return self.run_cmd("git", *args, **kwargs)

    @module.export
    def clone(self,
              repo_url: str,
              repo_dir: str,
              branch: str = "",
              depth: str = ""):
        if os.path.exists(repo_dir):
            self.log.info(f"cannot clone: {repo_dir} already exists")
            return
        argv = ["clone"]
        if branch:
            argv.append("--branch")
            argv.append(str(branch))
        if depth:
            argv.append("--depth")
            argv.append(str(depth))
        argv.append(repo_url)
        argv.append(repo_dir)
        return self(*argv)

    @module.export
    def update(self, repo_dir, branch: str = ""):
        argv = ["pull", "--prune"]
        if branch == "latest_tag":
            branch = self.latest_tag(repo_dir)
        if branch:
            argv += ["origin", branch]
        self(*argv, cwd=repo_dir)
        if branch:
            self("checkout", branch, cwd=repo_dir)

    @module.export
    def clone_or_update(self,
                        repo_url: str,
                        repo_dir: str,
                        branch: str = "",
                        depth: str = ""):
        """
        Clones the git repository from src_url if dest_dir does not exist.

        Returns True if the repository was cloned.
        """
        if os.path.exists(repo_dir):
            return self.update(repo_dir, branch=branch)

        update_to_latest_tag = False
        if branch == "latest_tag":
            branch = ""
            update_to_latest_tag = True
        p = self.clone(repo_url, repo_dir, branch=branch, depth=depth)
        if not update_to_latest_tag:
            return p
        return self.update(repo_dir, branch="latest_tag")

    @module.export
    def latest_tag(self, repo_dir: str):
        p = self("describe",
                 "--tags",
                 "--abbrev=0",
                 cwd=repo_dir,
                 capture_output=True)
        return p.stdout.decode("utf-8").strip()


if __name__ == "__main__":
    module.run(Git)
