#!/usr/bin/env python3

import json
import logging
import re
from urllib.parse import urlparse
from tempfile import NamedTemporaryFile
from argparse import ArgumentParser
from pathlib import Path
from http.client import HTTPSConnection


logger = logging.getLogger(__name__)


def main():
    logging.basicConfig(level=logging.INFO)

    parser = ArgumentParser()
    parser.add_argument("url")
    parser.add_argument("file_glob")
    parser.add_argument("target_dir")
    args = parser.parse_args()

    logger.info(f"{args = }")

    _extract(args.url, args.file_glob, args.target_dir)


def _extract(url, file_glob, target_dir):
    parsed = urlparse(url)
    resp = _send_get(host=parsed.hostname, path=parsed.path, headers={})
    with NamedTemporaryFile() as tmp_file:
        n_bytes = resp.readinto(tmp_file)
        logger.info(f"Fetched {n_bytes} bytes into {tmp_file.name}")
        tmp_file.seek(0)


def _send_get(host, path, headers):
    conn = HTTPSConnection(host)
    conn.request("GET", path, headers=headers)
    resp = conn.getresponse()
    if resp.status not in {200, 201}:
        raise RuntimeError(f"Bad status code: {resp.status}")

    return resp


if __name__ == "__main__":
    main()
