#!/bin/env python3

import subprocess
import sys
from dataclasses import dataclass
import typing as t


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

    ls_dir = "~/Desktop/langservers"
    Runner.run(
        [
            "mkdir -p ~/.local/share/aj-apps",
            f"mkdir -p {ls_dir} && cd {ls_dir} && ghrel -p ltex-ls-*-linux-x64.tar.gz valentjn/ltex-ls",  # noqa: E501
            Runner.Notice(
                f"Go to {ls_dir}. Unzip ltex-ls. Move it under ~/.local/share/aj-apps. Link the ~/.local/bin"  # noqa: E501
            ),
        ],
        group="LSP (LanguageTool)",
    )

    path_3rd_party = "~/Code/3rd-party"
    Runner.run(
        [
            # ccls' build deps
            "sudo dnf install cmake clang-devel llvm-devel",
            f"mkdir -p {path_3rd_party}",
            f"git clone --depth=1 --recursive git@github.com:MaskRay/ccls.git {path_3rd_party}/ccls",  # noqa: E501
            f"cd {path_3rd_party}/ccls && cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release",  # noqa: E501
            f"cd {path_3rd_party}/ccls && cmake --build Release",
            # TODO: fix the install target
            f"cd {path_3rd_party}/ccls && cmake  --build . -DCMAKE_INSTALL_PREFIX=~/.local --target install",  # noqa: E501
        ],
        group="LSP (C++)",
    )


class Runner:
    @dataclass
    class Notice:
        msg: str

    class _ColorCode:
        # The terminal codes usually include brackets. Having a single opening
        # bracket screws up code editors.
        BOLD = "\033" + chr(91) + "1m"
        END = "\033" + chr(91) + "0m"

    @classmethod
    def _print_bold(cls, text: str):
        print(cls._ColorCode.BOLD + text + cls._ColorCode.END)

    class _Cmd(t.Protocol):
        def announce(self):
            ...

        @property
        def prompt(self) -> str:
            ...

        def execute(self):
            ...

    class _ShellCmd:
        def __init__(self, line: str):
            self._line = line

        def announce(self):
            Runner._print_bold(self._line)

        @property
        def prompt(self) -> str:
            return "Run ^ command?"

        def execute(self):
            proc = subprocess.run(self._line, shell=True)
            proc.check_returncode()

    class _NoticeCmd:
        def __init__(self, notice: "Runner.Notice"):
            self._notice = notice

        def announce(self):
            print(self._notice.msg)

        @property
        def prompt(self) -> str:
            return "Have you done ^?"

        def execute(self):
            # No action needed.
            pass

    Entry = t.Union[str, Notice]

    @classmethod
    def _ask_n_run_cmd(cls, cmd: _Cmd):
        while True:
            cmd.announce()
            ans = input(f"{cmd.prompt} [y]es/[n]o/[q]uit/[s]kip group: ")

            if ans == "y":
                cmd.execute()
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
    def _cmd_for_entry(cls, entry: Entry) -> "Runner._Cmd":
        if isinstance(entry, str):
            return cls._ShellCmd(entry)
        elif isinstance(entry, cls.Notice):
            return cls._NoticeCmd(entry)
        else:
            raise TypeError(f"Invalid run entry type: {type(entry)}")

    @classmethod
    def run(cls, entries: t.Sequence[Entry], group: t.Optional[str] = None):
        if group is not None:
            print("=" * 80)
            print(group.capitalize())
            print("=" * 80)

        for entry in entries:
            cmd = cls._cmd_for_entry(entry)
            try:
                cls._ask_n_run_cmd(cmd)
            except StopIteration:
                break


if __name__ == "__main__":
    main()
