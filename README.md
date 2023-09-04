# macOS bootstrap

Bootstrap your macOS (tested from macOS versions 12.4 to 13.5) to make it your $HOME.

Bootstrap will do these things for you:

- Run MacOS software update
- Set macOS defaults
- Enable disc encryption
- Install xcode tools
- Install zsh addons
- Install Homebrew and tools
- Optional install your dotfiles
- Optional install your scripts

All functions are implemented as bash scripts in [modules](./modules/) and executed by [run.sh](./run.sh)

## Usage

Fork this repository and please consider pull requests if you change something to the better 😉

~~~shell
git clone https://github.com/karstenmueller/macos-bootstrap.git
cd macos-bootstrap
export STRAP_GIT_NAME='Jane Doe'
export STRAP_GIT_EMAIL='jane@doe.com'
export STRAP_GITHUB_USER='janedoe'
export STRAP_GITHUB_TOKEN='6b7b09576b13ca10ba4b810gc0c528b86f613bc6'
bash run.sh
[ ... ]
OK
--> Your system is now bootstrap'd
~~~

## Optional

You may want to configure the "STRAP*" variables in a `.envrc` file. This file will then be sourced by run.sh like direnv(1) does it automatically.

You may want to keep at least your dotfiles in a GitHub repository. Also scripts could be kept there. Beside other advantages the bootstrap will use these repositories as sources for installation:

- Dotfiles will be used from repository https://github.com/$STRAP_GITHUB_USER/dotfiles and cloned into $HOME/.dotfiles
- Tools and scripts and the like will be used from repository https://github.com/$STRAP_GITHUB_USER/bin and cloned into $HOME/.bin
