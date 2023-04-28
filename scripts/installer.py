#!/bin/env python3

import subprocess
import sys
import typing as t


class ColorCode:
    # The terminal codes usually include brackets. Having a single opening
    # bracket screws up code editors.
    BOLD = "\033" + chr(91) + "1m"
    END = "\033" + chr(91) + "0m"


class Runner:
    @staticmethod
    def _run_cmd(cmd: str):
        proc = subprocess.run(cmd, shell=True)
        proc.check_returncode()


    @staticmethod
    def _print_bold(text: str):
        print(ColorCode.BOLD + text + ColorCode.END)


    @classmethod
    def _ask_n_run_cmd(cls, cmd: str):
        while True:
            cls._print_bold(cmd)
            ans = input("Run ^ command? [y]es/[n]o/[q]uit/[s]kip group: ")

            if ans == "y":
                cls._run_cmd(cmd)
                print()
                break
            elif ans == "n":
                # Skipping this command
                print()
                break
            elif ans == "q":
                sys.exit()
            elif ans == "s":
                raise StopIteration()
            else:
                print(f"Invalid answer: {ans}")

    @classmethod
    def run(cls, cmds: t.Sequence[str], group: t.Optional[str] = None):
        if group is not None:
            print("=" * 80)
            print(group.capitalize())
            print("=" * 80)

        for cmd in cmds:
            try:
                cls._ask_n_run_cmd(cmd)
            except StopIteration:
                break


def main():
    nerd_font = "NerdFontsSymbolsOnly"
    Runner.run([
        "sudo dnf install jetbrains-mono-fonts",
        f"mkdir -p ~/Desktop/fonts && cd ~/Desktop/fonts && ghrel -p {nerd_font}.zip ryanoasis/nerd-fonts",
        f"mkdir -p ~/.local/share/fonts/{nerd_font}",
        f"unzip ~/Desktop/fonts/{nerd_font}.zip -d ~/.local/share/fonts/{nerd_font}",
        f"fc-cache ~/.local/share/fonts/{nerd_font}",
    ], group="fonts")


    Runner.run([
        "sudo dnf install fd-find",
        "sudo dnf install ripgrep",
        "sudo dnf install gh",
        "sudo dnf copr enable atim/lazygit -y",
        "sudo dnf install lazygit",
    ], group="system utilities")

    Runner.run([
        "sudo dnf install nodejs",
        "mkdir -p ~/.local/share/npm-global",
        "npm config set prefix ~/.local/share/npm-global",
    ], group="node")


if __name__ == "__main__":
    main()
