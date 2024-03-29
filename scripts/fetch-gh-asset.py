#!/usr/bin/env python3

import json
import logging
import re
from argparse import ArgumentParser
from pathlib import Path
from http.client import HTTPSConnection


logger = logging.getLogger(__name__)


def _send_get(host, path, headers):
    conn = HTTPSConnection(host)
    conn.request("GET", path, headers=headers)
    resp = conn.getresponse()
    if resp.status not in {200, 201}:
        raise RuntimeError(f"Bad status code: {resp.status}")

    body = json.loads(resp.read())
    return resp, body


def _send_get_gh(path):
    return _send_get("api.github.com", path, {"Accept": "application/vnd.github+json", "User-Agent": "python"})


def main():
    logging.basicConfig(level=logging.INFO)

    parser = ArgumentParser()
    parser.add_argument("owner")
    parser.add_argument("repo")
    parser.add_argument("asset_regex")
    parser.add_argument("--first", action="store_true")
    args = parser.parse_args()

    logger.info(f"{args = }")

    _find_download_url(args.owner, args.repo, args.asset_regex, args.first)


def _find_download_url(owner, repo, asset_regex, first):
    _, release_body = _send_get_gh(f"/repos/{owner}/{repo}/releases/latest")
    release_id = release_body["id"]

    matching_assets = []
    for page_i in range(1000):
        logger.info(f"Requesting page {page_i}")
        _, assets_list = _send_get_gh(f"/repos/{owner}/{repo}/releases/{release_id}/assets?page={page_i}")

        matching_from_page = [asset for asset in assets_list if re.match(asset_regex, asset["name"])]
        logger.info(f"Found {len(matching_from_page)} matching assets")
        matching_assets.extend(matching_from_page)

        if not assets_list:
            break

        if matching_assets and first:
            break

    for asset in matching_assets:
        print(asset["browser_download_url"])

        if first:
            break


if __name__ == "__main__":
    main()
