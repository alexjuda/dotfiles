#!/usr/bin/env python3

import json
from pathlib import Path
from http.client import HTTPSConnection


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
    conn = HTTPSConnection("api.github.com")
    owner = "ryanoasis"
    repo = "nerd-fonts"

    _, release_body = _send_get_gh(f"/repos/{owner}/{repo}/releases/latest")
    release_id = release_body["id"]
    _, assets_body = _send_get_gh(f"/repos/{owner}/{repo}/releases/{release_id}/assets")
    print(json.dumps(assets_body, indent=2))
    # breakpoint()


if __name__ == "__main__":
    main()
