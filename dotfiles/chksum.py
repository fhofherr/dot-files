import hashlib

from dotfiles import logging

_LOG = logging.get_logger(__name__)


def verify_sha256(path, expected_sha256_sum):
    h = hashlib.new("sha256")
    with open(path, "rb") as f:
        h.update(f.read())
    actual = h.hexdigest()
    if expected_sha256_sum != actual:
        raise Error(f"{expected_sha256_sum} != {actual}")


def verify_sha256_file(path, name, expected_sha256_sum_file):
    _LOG.info(
        f"Verify sha256 sum of {name} located at {path} against sums in {expected_sha256_sum_file}"
    )
    with open(expected_sha256_sum_file) as f:
        lines = f.readlines()
        if len(lines) == 0:
            _LOG.warn("Sha256 sum file {expected_sha256_sum_file} is empty")
        for line in lines:
            line = line.strip()
            if line.endswith(name):
                expected_sha256_sum = line.split(" ")[0]
                try:
                    verify_sha256(path, expected_sha256_sum)
                    return
                except Error as e:
                    raise Error(f"{name}: {e}")
            else:
                _LOG.debug(f"Line '{line}' does not end with '{name}'")
    raise Error(f"None of the entries in {expected_sha256_sum_file} matched")


class Error(Exception):
    pass
