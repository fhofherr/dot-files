def after(snip, s):
    line = snip.buffer[snip.line]
    col = snip.column
    try:
        return line[:col + 1].endswith(s)
    except IndexError:
        return False


def before(snip, s):
    line = snip.buffer[snip.line]
    col = snip.column
    try:
        return line[col + 1:].startswith(s)
    except IndexError:
        return False
