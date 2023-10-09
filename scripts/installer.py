#!/bin/env python3

import argparse
import subprocess
import sys
from dataclasses import dataclass
import typing as t


def main():
    groups = []
    share_aj_apps = "~/.local/share/aj-apps"
    groups.append(
        Runner.Group(
            [
                "sudo dnf install zsh",
                # For 'chsh'
                "sudo dnf install util-linux-user",
                "chsh -s /bin/zsh",
                "mkdir -p ~/.config",
                "ln -s $PWD/config/kitty ~/.config/kitty",
                "ln -s $PWD/config/nvim ~/.config/nvim",
                "ln -s $PWD/macos/.zshrc ~/.zshrc",
                "ln -s $PWD/linux/.bash_aliases ~/.bash_aliases",

                "mkdir -p ~/.local/bin",
                "ln -s $PWD/scripts/git-fetch-repos ~/.local/bin/",

                f"mkdir -p {share_aj_apps}",
                f"git clone https://github.com/qoomon/zsh-lazyload.git {share_aj_apps}/zsh-lazyload"  # noqa: E501insta
            ],
            name="configs",
        )
    )

    groups.append(
        Runner.Group(
            [
                "git config --global user.email 'FIXME'",
                "git config --global user.name 'Alexander Juda'",
                "sudo dnf install gcc-g++",
            ],
            name="coreutils",
        )
    )

    groups.append(
        Runner.Group(
            [
                "sudo dnf install neovim",
                'git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim',  # noqa: E501
                "mkdir -p ~/.local/share/lang-servers/ltex-ls-data",
                "touch ~/.local/share/lang-servers/ltex-ls-data/dict.txt",
                'nvim -c ":PaqSync"',
            ],
            name="neovim",
        )
    )

    font_dir = "NerdFontsSymbolsOnly"
    groups.append(
        Runner.Group(
            [
                "brew tap homebrew/cask-fonts",
                "brew install font-jetbrains-mono",
                f"mkdir -p ~/Desktop/fonts && cd ~/Desktop/fonts && ghrel -p {font_dir}.zip ryanoasis/nerd-fonts",  # noqa: E501
                f"unzip ~/Desktop/fonts/{font_dir}.zip -d ~/Desktop/fonts/{font_dir}",
                f"cp ~/Desktop/fonts/{font_dir}/SymbolsNerdFont*-Regular.ttf ~/Library/Fonts/",  # noqa: E501
            ],
            name="fonts",
        )
    )

    groups.append(
        Runner.Group(
            [
                "sudo dnf install fd-find",
                "sudo dnf install ripgrep",
                "sudo dnf install gh",
                "sudo dnf install lazygit",
                "sudo dnf install htop",
                "sudo dnf install glances",
            ],
            name="cli-flair",
        )
    )

    # Src: https://heynode.com/tutorial/install-nodejs-locally-nvm/
    groups.append(
        Runner.Group(
            [
                "curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh -o install_nvm.sh",  # noqa: E501
                "bash install_nvm.sh",
                "nvm install --lts",
            ],
            name="node",
        )
    )

    # Src:
    # * https://github.com/pyenv/pyenv#installation
    # * https://stribny.name/blog/install-python-dev/
    groups.append(
        Runner.Group(
            [
                # Pyenv. We don't wanna use homebrew's pyenv because it makes the
                # terminal super slow.
                "git clone https://github.com/pyenv/pyenv.git ~/.pyenv",
                "cd ~/.pyenv && src/configure && make -C src",
                f"ln -s $PWD/macos/pyenv.sh {share_aj_apps}/pyenv.sh",
                # Python
                "pyenv install -k 3",
                "pyenv global 3 && pyenv versions",
                # Pipx
                "sudo dnf install pipx",
                "pipx install cookiecutter",
            ],
            name="python",
        )
    )

    groups.append(
        Runner.Group(
            [
                "pipx install 'python-lsp-server[rope]'",
                "pipx inject python-lsp-server python-lsp-black",
                "pipx inject python-lsp-server python-lsp-ruff",
                "pipx inject python-lsp-server pylsp-rope",
                "pipx install pyright",
            ],
            name="python-lsp",
        )
    )

    groups.append(
        Runner.Group(
            [
                "npm install -g typescript typescript-language-server",
            ],
            name="js-lsp",
        )
    )

    groups.append(
        Runner.Group(
            [
                "npm install -g vscode-langservers-extracted",
            ],
            name="html-json-lsp",
        )
    )

    ls_dir = "~/Desktop/langservers"
    groups.append(
        Runner.Group(
            [
                "mkdir -p ~/.local/share/aj-apps",
                f"mkdir -p {ls_dir} && cd {ls_dir} && ghrel -p ltex-ls-*-linux-x64.tar.gz valentjn/ltex-ls",  # noqa: E501
                Runner.Notice(
                    f"Go to {ls_dir}. Unzip ltex-ls. Move it under {share_aj_apps}. Link the ~/.local/bin"  # noqa: E501
                ),
            ],
            name="languagetool-lsp",
        )
    )

    path_3rd_party = "~/Code/3rd-party"
    groups.append(
        Runner.Group(
            [
                # ccls' build deps
                "sudo dnf install cmake clang-devel llvm-devel",
                f"mkdir -p {path_3rd_party}",
                f"git clone --depth=1 --recursive git@github.com:MaskRay/ccls.git {path_3rd_party}/ccls",  # noqa: E501
                f"cd {path_3rd_party}/ccls && cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release",  # noqa: E501
                f"cd {path_3rd_party}/ccls && cmake --build Release",
                f"cp {path_3rd_party}/ccls/Release/ccls ~/.local/bin/ccls",
            ],
            name="cpp-lsp",
        )
    )

    groups.append(
        Runner.Group(
            [
                "brew install lua-language-server",
            ],
            name="lua-lsp",
        )
    )

    Runner(groups).run_with_cli()


class Runner:
    @dataclass
    class Notice:
        msg: str

    Entry = t.Union[str, Notice]

    @dataclass(frozen=True)
    class Group:
        entries: t.Sequence["Runner.Entry"]
        name: t.Optional[str]

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
    def _run_groups(cls, groups: t.Sequence[Group]):
        for group in groups:
            if group.name is not None:
                print("=" * 80)
                print(group.name)
                print("=" * 80)

            for entry in group.entries:
                cmd = cls._cmd_for_entry(entry)
                try:
                    cls._ask_n_run_cmd(cmd)
                except StopIteration:
                    print()
                    break

    def __init__(self, groups: t.Sequence[Group]):
        self._groups = groups

    def run(self):
        self._run_groups(self._groups)

    def run_with_cli(self):
        argparser = argparse.ArgumentParser()
        argparser.add_argument("-g", "--group", help="Run only this command group")
        argparser.add_argument(
            "-l",
            "--list-groups",
            help="Print available groups instead of running anything",
            action="store_true",
        )

        args = argparser.parse_args()

        if args.list_groups:
            print("Available groups:")
            for group in self._groups:
                print(group.name)
            return

        if (selected_group := args.group) is not None:
            try:
                group = next(filter(lambda g: g.name == selected_group, self._groups))
            except StopIteration:
                raise ValueError(f"Invalid group name: {selected_group}")

            self._run_groups([group])
        else:
            self._run_groups(self._groups)


if __name__ == "__main__":
    main()
