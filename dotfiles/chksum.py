import hashlib
import os


def verify_sha256(path, expected, log=None):
    h = hashlib.new("sha256")
    with open(path, "rb") as f:
        h.update(f.read())
    actual = h.hexdigest()
    if log:
        log.info(f"expected checksum: {expected}")
        log.info(f"actual checksum: {actual}")
    if expected != actual:
        if log:
            log.warn(f"verify_sha256: {expected} != {actual}")
        return False
    return True


def verify_sha256_file(path, sha256_file, log=None):
    with open(sha256_file) as f:
        lines = f.readlines()

    if len(lines) == 0:
        raise ValueError(f"File {sha256_file} empty")
    if len(lines) == 1:
        return verify_sha256(path, lines[0].strip(), log=log)

    name = os.path.basename(path)
    for line in lines:
        line = line.strip()
        if not line.endswith(name):
            continue
        expected = line.split(" ")[0].strip()
        return verify_sha256(path, expected, log=log)
