import os
import contextlib
import tempfile

from fnmatch import fnmatch

import requests

from dotfiles import common


def clone(c, src_url: str, dest_dir: str, branch="", depth=""):
    """Clones the git repository from src_url if dest_dir does not exist.

    Returns True if the repository was cloned.
    """
    if branch:
        branch = f"--branch {branch}"
    if depth:
        depth = f"--depth {depth}"
    if not os.path.exists(dest_dir):
        c.run(f"git clone {depth} {branch} {src_url} {dest_dir}")
        return True
    return False


_GITHUB_API_URL = "https://api.github.com"


@contextlib.contextmanager
def github_release(repo, version=None):
    headers = {
        "User-Agent": common.HTTP_USER_AGENT,
        "Accept": "application/vnd.github.v3+json",
    }
    url = f"{_GITHUB_API_URL}/repos/{repo}/releases/latest"
    if version:
        url = f"{_GITHUB_API_URL}/repos/{repo}/releases/tags/{version}"
    r = requests.get(url, headers=headers)
    r.raise_for_status()
    gh_response = r.json()
    with tempfile.TemporaryDirectory(prefix="dotfiles-") as downloads_dir:
        yield _GithubRelease(gh_response, downloads_dir)


class _GithubRelease:
    def __init__(self, gh_response, downloads_dir):
        self.gh_response = gh_response
        self.downloads_dir = downloads_dir

    def download_asset(self, name):
        asset_url, name = self._find_asset_url(name)
        headers = {"User-Agent": common.HTTP_USER_AGENT}
        r = requests.get(asset_url, headers=headers)
        r.raise_for_status()
        dest = os.path.join(self.downloads_dir, name)
        with open(dest, "wb") as f:
            f.write(r.content)
        return dest

    def _find_asset_url(self, name):
        for e in self.gh_response["assets"]:
            if e["name"] == name or fnmatch(e["name"], name):
                return e["browser_download_url"], e["name"]
        raise KeyError(f"No github asset with name: {name}")
