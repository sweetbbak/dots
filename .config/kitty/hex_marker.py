#!/usr/bin/env python3
import re


def marker(text):
    with open("file.txt") as f:
        f.writelines(text)

    for i, ch in enumerate(text):
        match = re.search(r'^#(?:[0-9a-fA-F]{3}){1,2}$', text)
        if match:
            yield i, i, 3
