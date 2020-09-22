import os
from typing import Callable, Tuple, Union

import github3
from github3.repos.release import Asset, Release


def github_find_latest_release(repo_id,
                               pre_release_ok=False,
                               gh=None) -> Release:
    if not gh:
        gh = _new_gh()
    repo = gh.repository(*repo_id.split("/"))
    latest_release = repo.latest_release()
    if latest_release:
        return latest_release
    if pre_release_ok:
        for release in repo.releases():
            if not latest_release:
                latest_release = release
            if latest_release.created_at < release.created_at:
                latest_release = release
    return latest_release


def github_asset(repo_id: str,
                 asset_filter: Union[str, Callable[[str], bool]],
                 dest_dir: str,
                 version=None,
                 pre_release_ok=False,
                 force_download=False,
                 gh=None,
                 log=None):
    if not gh:
        gh = _new_gh()
    if version:
        repo = gh.repository(*repo_id.split("/"))
        release = repo.release_from_tag(version)
    else:
        release = github_find_latest_release(repo_id,
                                             pre_release_ok=pre_release_ok,
                                             gh=gh)
    if not release:
        raise DownloadError(f"No matching release found for {repo_id}")

    asset_paths = []
    did_download = False
    for asset in release.assets():
        if callable(asset_filter) and not asset_filter(asset.name):
            continue
        if not callable(asset_filter) and asset_filter != asset.name:
            continue
        dest = os.path.join(dest_dir, asset.name)
        if not os.path.exists(dest) or force_download:
            if log:
                log.info(f"Downloading {asset.name} to {dest}")
            os.makedirs(dest_dir, exist_ok=True)
            asset.download(dest)
            did_download = True
        asset_paths.append(dest)

    if not asset_paths:
        raise DownloadError(f"No matching asset found for {repo_id}")
    return asset_paths, did_download


def _split_repo_id(repo_id: str) -> Tuple[str, str]:
    repo_owner, repo_name = repo_id.split("/")
    if not repo_owner or not repo_name:
        raise ValueError(f"Invalid repo_id: {repo_id}")
    return repo_owner, repo_name


class DownloadError(Exception):
    pass


def _new_gh():
    token = os.getenv("DOTFILES_GITHUB_API_TOKEN")
    if token:
        return github3.GitHub(token=token)
    return github3.GitHub()
