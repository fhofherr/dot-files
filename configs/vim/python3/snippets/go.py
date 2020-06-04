import os.path


def pkg_decl(snip, path):
    pkg = os.path.basename(os.path.dirname(os.path.realpath(path)))
    file_name = snip.basename
    if file_name.endswith("_test") and "internal" not in file_name:
        pkg = f"{pkg}_test"
    snip.rv = f"package {pkg}"
