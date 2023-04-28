#!/bin/env python3

import subprocess


def _run_cmd(cmd: str):
    proc = subprocess.run(cmd, shell=True)
    proc.check_returncode()


def main():
    _run_cmd("ls -al")



if __name__ == "__main__":
    main()
