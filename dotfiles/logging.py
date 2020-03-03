import logging
import colorlog


def _configure_root_logger(level=logging.INFO):
    fmt = colorlog.ColoredFormatter(
        "%(log_color)s[%(levelname)s]%(reset)s %(name)s:" +
        " %(blue)s%(message)s%(reset)s")
    handler = colorlog.StreamHandler()
    handler.setFormatter(fmt)
    logger = logging.getLogger()
    logger.addHandler(handler)
    logger.setLevel(level=level)
    return logger


ROOT_LOGGER = _configure_root_logger()


def get_logger(name, level=logging.INFO):
    logger = logging.getLogger(name)
    logger.setLevel(level=level)
    return logger
