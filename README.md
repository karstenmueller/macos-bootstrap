# macOS bootstrap

Bootstrap a fresh install of macOS (tested with macOS Big Sur)

You may want to use the latest macOS version, run "Software Update" App

## Usage

Fork this repository and consider pull requests if you change something to the better 😉

~~~shell
git clone https://github.com/karstenmueller/macos-bootstrap.git
export STRAP_GIT_NAME='Jane Doe'
export STRAP_GIT_EMAIL='jane@doe.com'
export STRAP_GITHUB_USER='janedoe'
export STRAP_GITHUB_TOKEN='6b7b09576b13ca10ba4b810gc0c518b86f613ac8'
bash macos-bootstrap/run.sh
[ ... ]
OK
--> Your system is now bootstrap'd
~~~

You may want to configure these variables in a `.envrc` file which is sourced by run.sh like direnv(1) does it.

## Optional

You may want to keep at least your dotfiles in GitHub repositories. Also tools and homebrew packages could be kept there. Beside other advantages the bootstrap will use these repositories as sources for installation.

- Dotfiles will be used from repository https://github.com/$STRAP_GITHUB_USER/dotfiles and cloned into $HOME/.dotfiles
- Tools and scripts and the like will be used from repository https://github.com/$STRAP_GITHUB_USER/bin and cloned into $HOME/.bin
- Homebrew related things will be used from repository https://github.com/$STRAP_GITHUB_USER/homebrew and cloned into $HOME/.homebrew
