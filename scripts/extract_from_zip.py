#!/usr/bin/env python3

import json
import logging
import re
from urllib.parse import urlparse
from tempfile import NamedTemporaryFile
from argparse import ArgumentParser
from pathlib import Path
from http.client import HTTPSConnection
from zipfile import ZipFile


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
    resp = _send_get(host=parsed.hostname, path=parsed.path, headers={"User-Agent": "python"})
    with NamedTemporaryFile() as tmp_file:
        while chunk := resp.read(1000):
            tmp_file.write(chunk)
        logger.info(f"Fetched {tmp_file.name}")
        tmp_file.seek(0)

        zip_file = ZipFile(tmp_file)
        logger.info(f"Files inside the zip: {zip_file.namelist()}")


def _parse_url_comps(url):
    parsed = urlparse(url)
    host = parsed.netloc
    scheme_host = f"{parsed.scheme}://{host}"
    return host, url[len(scheme_host):]


def _send_get(host, path, headers):
    conn = HTTPSConnection(host)
    conn.request("GET", path, headers=headers)
    resp = conn.getresponse()

    if resp.status == 302:
        # Follow redirects until the call stack is filled
        new_url = resp.headers["Location"]
        return _send_get(*_parse_url_comps(new_url), headers)


    if resp.status not in {200, 201}:
        raise RuntimeError(f"Bad status code: {resp.status}")

    return resp


if __name__ == "__main__":
    main()
