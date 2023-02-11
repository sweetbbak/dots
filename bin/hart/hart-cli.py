#!/usr/bin/env python

import enum
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import time
from collections import deque

import httpx

try:
    import pyperclip
except ImportError:
    pyperclip = None

has_kitty = bool(shutil.which("kitty"))

RSS_FEED_API = "https://yande.re/post/piclens"


SEARCHER_REGEX = re.compile(
    r"(?s)"
    r"<item>\s+"
    r"<title>(?P<title>.+?)</title>\s+"
    r"<link>(?P<url>.+?/(?P<id>\d+))</link>.+?"
    r'<media:thumbnail url="(?P<preview>.+?)"/>\s+'
    r'<media:content url="(?P<image_url>.+?)".+?/>',
)


fzf_executable = "fzf"
fzf_args = [
    fzf_executable,
    "--color=fg:#d60a79",
    "--reverse",
    "--height=50%",
    "--cycle",
    "--no-mouse",
]


def sanitize_filename(f):
    return "".join("_" if _ in '<>:"/\\|?*' else _ for _ in f).strip()


class UserMenuSelection(enum.Enum):
    KEEP_BROWSING = "b"
    QUIT = "q"


class UserBrowseSelection(enum.Enum):

    COPY_TO_CLIPBOARD = "c"
    DOWNLOAD = "d"
    PERSIST_SELECTION = "p"
    PREVIEW = "r"


def iter_results(session, tags=None):

    params = {}

    if tags:
        params["tags"] = tags

    content = {}
    page = 0

    while content is not None:
        content = None
        params.update({"page": page + 1})

        for content in SEARCHER_REGEX.finditer(
            session.get(RSS_FEED_API, params=params).text
        ):
            yield content.groupdict()

        page += 1
        time.sleep(1.0)


global_deque = deque()


def prompt_via_fzf(genexp, *, global_dequeue: deque = global_deque, is_last=False):

    fzf_process = subprocess.Popen(
        fzf_args + ["--multi"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    )

    component_holder = {}
    previous_session = b""

    for result in global_deque:

        console_out = ("{title} / {id}".format_map(result) + "\n").encode()
        component_holder[console_out] = result
        previous_session += console_out

    if global_deque:
        fzf_process.stdin.write(previous_session)
        fzf_process.stdin.flush()

    while fzf_process.returncode is None and not is_last:

        try:
            result = next(genexp)
        except StopIteration:
            is_last = True
            break

        console_out = ("{title} / {id}".format_map(result) + "\n").encode()

        if console_out in component_holder:
            continue

        component_holder.update({console_out: result})
        global_dequeue.append(result)

        try:
            fzf_process.stdin.write(console_out)
            fzf_process.stdin.flush()
        except OSError:
            break

    fzf_process.wait()

    return [component_holder[_] for _ in fzf_process.stdout.readlines()], is_last


def user_fzf_choice(args):

    fzf_process = subprocess.Popen(
        fzf_args,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    )

    fzf_process.stdin.write(b"\n".join((_.encode() for _ in args)) + b"\n")
    fzf_process.stdin.close()
    fzf_process.wait()

    return fzf_process.stdout.read()[:-1].decode()


def copy_opt(session, user_prompt):
    return pyperclip.copy(user_prompt["image_url"])


def download_opt(session, user_prompt):
    download_path = pathlib.Path(sanitize_filename(user_prompt["title"]) + ".jpg")

    with open(download_path, "wb") as image_file:
        image_file.write(session.get(user_prompt["image_url"]).content)

    print(f"hart: downloaded to {download_path.as_posix()!r}")


def preview_opt(session, user_prompt):

    temp_file_path = pathlib.Path(tempfile.gettempdir()) / "hart-preview.jpg"

    with open(temp_file_path, "wb") as image_file:
        image_file.write(session.get(user_prompt["preview"]).content)

    if has_kitty:
        process = subprocess.call(
            [
                "kitty",
                "+icat",
                "--place",
                "100x100@0x0",
                temp_file_path.as_posix(),
            ]
        )
    else:

        if sys.platform == "darwin":
            opener = "open"
        else:
            if sys.platform == "win32":
                opener = "start"
            else:
                opener = "xdg-open"
        process = subprocess.call([opener, temp_file_path.as_posix()], shell=True)

    if process != 0:
        return print(f"hart: failed to open preview, opener threw error {process}")


def browse_options(session, user_prompt, *, persist=False, persist_with=None):

    print("hart: {title!r} / yandere[{id}]".format_map(user_prompt))

    if persist_with is None:

        options = {
            "[d]ownload": UserBrowseSelection.DOWNLOAD,
        }

        if not persist:
            options.update(
                {
                    "[p]ersist selection for next in queue": UserBrowseSelection.PERSIST_SELECTION,
                    "p[r]eview": UserBrowseSelection.PREVIEW,
                }
            )

        if pyperclip is not None:
            options["[c]opy to clipboard"] = UserBrowseSelection.COPY_TO_CLIPBOARD

        user_choice = options.get(user_fzf_choice(options))

        if persist and persist_with is None:
            persist_with = user_choice

    else:
        user_choice = persist_with

    if user_choice is None:
        return

    if user_choice == UserBrowseSelection.PERSIST_SELECTION:
        return browse_options(session, user_prompt, persist=True)

    if user_choice == UserBrowseSelection.COPY_TO_CLIPBOARD:
        copy_opt(session, user_prompt)

    if user_choice == UserBrowseSelection.DOWNLOAD:
        download_opt(session, user_prompt)

    if user_choice == UserBrowseSelection.PREVIEW:
        preview_opt(session, user_prompt)
        return browse_options(
            session, user_prompt, persist=persist, persist_with=persist_with
        )
    
    if persist:
        return persist_with


def __main__(query=None):

    http_client = httpx.Client(headers={"User-Agent": "uwu"})

    genexp = iter_results(http_client, query)

    user_choice = None
    is_last = False

    options = {
        "[b]rowse harts": UserMenuSelection.KEEP_BROWSING,
        "[q]uit": UserMenuSelection.QUIT,
    }

    while user_choice != UserMenuSelection.QUIT:
        user_choice = options.get(user_fzf_choice(options), UserMenuSelection.QUIT)

        if user_choice == UserMenuSelection.KEEP_BROWSING:

            selection, is_last = prompt_via_fzf(genexp, is_last=is_last)

            if selection:

                persist_with = None

                for _ in selection:
                    persist_with = browse_options(
                        http_client,
                        _,
                        persist=persist_with is not None,
                        persist_with=persist_with,
                    )


if __name__ == "__main__":
    __main__(*sys.argv[1:])
