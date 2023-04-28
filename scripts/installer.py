#!/bin/env python3

import subprocess
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
            ans = input("Run ^ command? [y]es/[n]o/[q]uit: ")

            if ans == "y":
                cls._run_cmd(cmd)
                print()
                break
            elif ans == "n":
                # Skipping this command
                print()
                break
            elif ans == "q":
                raise StopIteration()
            else:
                print(f"Invalid answer: {ans}")

    @classmethod
    def run(cls, cmds: t.Sequence[str]):
        for cmd in cmds:
            try:
                cls._ask_n_run_cmd(cmd)
            except StopIteration:
                break


def main():
    font_name = "NerdFontsSymbolsOnly"
    Runner.run([
        f"mkdir -p ~/Desktop/fonts && cd ~/Desktop/fonts && ghrel -p {font_name}.zip ryanoasis/nerd-fonts",
        f"mkdir -p ~/.local/share/fonts/{font_name}",
        f"unzip ~/Desktop/fonts/{font_name}.zip -d ~/.local/share/fonts/{font_name}",
        f"fc-cache ~/.local/share/fonts/{font_name}",
    ])


if __name__ == "__main__":
    main()
