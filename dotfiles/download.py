import os
from typing import Callable, Tuple, Union

import github3
import requests
from github3.repos.release import Asset, Release

from dotfiles import chksum


def github_find_latest_release(repo_id,
                               pre_release_ok=False,
                               gh=None) -> Release:
    if not gh:
        gh = _new_gh()
    repo = gh.repository(*repo_id.split("/"))
    try:
        return repo.latest_release()
    except github3.exceptions.NotFoundError:
        pass
    latest_release = None
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
                 checksum_filter: Union[str, Callable[[str], bool]] = None,
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

    if did_download and checksum_filter:
        if callable(checksum_filter):
            checksums = next(a for a in asset_paths
                             if checksum_filter(os.path.basename(a)))
        else:
            checksums = next(a for a in asset_paths
                             if checksum_filter == os.path.basename(a))
        asset_paths = [a for a in asset_paths if a != checksums]
        for a in asset_paths:
            if not chksum.verify_sha256_file(a, checksums, log=log):
                raise ValueError("Checksum mismatch")

    return asset_paths, did_download


def _split_repo_id(repo_id: str) -> Tuple[str, str]:
    repo_owner, repo_name = repo_id.split("/")
    if not repo_owner or not repo_name:
        raise ValueError(f"Invalid repo_id: {repo_id}")
    return repo_owner, repo_name


def _new_gh():
    token = os.getenv("DOTFILES_GITHUB_API_TOKEN")
    if token:
        return github3.GitHub(token=token)
    return github3.GitHub()


def file(url, dest):
    dest_dir = os.path.dirname(dest)
    os.makedirs(dest_dir, exist_ok=True)
    r = requests.get(url, allow_redirects=True)
    r.raise_for_status()
    with open(dest, "wb") as f:
        f.write(r.content)


class DownloadError(Exception):
    pass
