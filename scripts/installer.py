#!/bin/env python3

import subprocess


class ColorCode:
    # The terminal codes usually include brackets. Having a single opening
    # bracket screws up code editors.
    BOLD = "\033" + chr(91) + "1m"
    END = "\033" + chr(91) + "0m"


def _run_cmd(cmd: str):
    proc = subprocess.run(cmd, shell=True)
    proc.check_returncode()


def _print_bold(text: str):
    print(ColorCode.BOLD + text + ColorCode.END)


def _ask_run_cmd(cmd: str):
    _print_bold(cmd)
    ans = input("Run this command? [y]es/[n]o/[q]uit ")

    if ans == "y":
        _run_cmd(cmd)


def main():
    _ask_run_cmd("ls -al")


if __name__ == "__main__":
    main()
