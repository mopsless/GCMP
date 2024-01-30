import os
from typing import List, Any


def time_consuming(default):
    def wrapper_factory(fn):
        def wrapper(*args, **kwargs):
            if os.environ.get("RUN_TIME_CONSUMING", "1").lower().strip() not in ["0", "false"]:
                return fn(*args, **kwargs)
            else:
                return default

        return wrapper

    return wrapper_factory


def any_in(which: List[Any], target: List[Any]) -> bool:
    """
    Check whether at least one element is in list.
    :param which: List[Any]: list of items to check
    :param target: List[Any]: list to check from
    :return: bool: whether at least on item from which found in target
    """
    for item in which:
        if item in target:
            return True
    return False
