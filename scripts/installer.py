#!/bin/env python3

import subprocess
import sys
import typing as t


class Runner:
    class ColorCode:
        # The terminal codes usually include brackets. Having a single opening
        # bracket screws up code editors.
        BOLD = "\033" + chr(91) + "1m"
        END = "\033" + chr(91) + "0m"

    @staticmethod
    def _run_cmd(cmd: str):
        proc = subprocess.run(cmd, shell=True)
        proc.check_returncode()

    @classmethod
    def _print_bold(cls, text: str):
        print(cls.ColorCode.BOLD + text + cls.ColorCode.END)

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
    Runner.run(
        [
            "sudo dnf install jetbrains-mono-fonts",
            f"mkdir -p ~/Desktop/fonts && cd ~/Desktop/fonts && ghrel -p {nerd_font}.zip ryanoasis/nerd-fonts",  # noqa: E501
            f"mkdir -p ~/.local/share/fonts/{nerd_font}",
            f"unzip ~/Desktop/fonts/{nerd_font}.zip -d ~/.local/share/fonts/{nerd_font}",  # noqa: E501
            f"fc-cache ~/.local/share/fonts/{nerd_font}",
        ],
        group="fonts",
    )

    Runner.run(
        [
            "sudo dnf install fd-find",
            "sudo dnf install ripgrep",
            "sudo dnf install gh",
            "sudo dnf copr enable atim/lazygit -y",
            "sudo dnf install lazygit",
            "sudo dnf install htop",
        ],
        group="system utilities",
    )

    # Src: https://developer.fedoraproject.org/tech/languages/nodejs/nodejs.html
    Runner.run(
        [
            "sudo dnf install nodejs",
            "mkdir -p ~/.local/share/npm-global",
            "npm config set prefix ~/.local/share/npm-global",
        ],
        group="node",
    )

    # Src:
    # * https://github.com/pyenv/pyenv#installation
    # * https://stribny.name/blog/install-python-dev/
    Runner.run(
        [
            "git clone https://github.com/pyenv/pyenv.git ~/.pyenv",
            "cd ~/.pyenv && src/configure && make -C src",
            "sudo dnf install zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils",  # noqa: E501
            "pyenv install -k 3",
            "pyenv global 3 && pyenv versions",
            "sudo dnf install pipx",
        ],
        group="python",
    )

    Runner.run(
        [
            "pipx install 'python-lsp-server[rope]'",
            "pipx inject python-lsp-server python-lsp-black",
            "pipx inject python-lsp-server python-lsp-ruff",
            "pipx inject python-lsp-server pylsp-rope",
            "npm install -g pyright",
        ],
        group="LSP (Python)",
    )

    Runner.run(
        [
            "npm install -g typescript typescript-language-server",
        ],
        group="LSP (JavaScript)",
    )

    Runner.run(
        [
            "npm install -g vscode-langservers-extracted",
        ],
        group="LSP (HTML + JSON)",
    )


if __name__ == "__main__":
    main()
