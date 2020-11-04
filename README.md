# macOS bootstrap

Bootstrap a fresh install of macOS (tested with macOS Big Sur)

## Usage

~~~shell
git clone https://github.com/karstenmueller/macos-bootstrap.git
bash macos-bootstrap/run.sh
~~~

## Prerequisites

### Mandatory

These enironment variables are required:

~~~shell
export STRAP_GIT_NAME='Jane Doe'
export STRAP_GIT_EMAIL='jane@doe.com'
export STRAP_GITHUB_USER='janedoe'
export STRAP_GITHUB_TOKEN='6b7b09576b13ca10ba4b810gc0c518b86f613ac8'
~~~

You may want to configure variables in a `.envrc` file which is used by direnv(1).

### Optional

A `Brewfile` for installing software packages and dotfiles will be used if personal GitHub repositories are present:

- Brewfile will be used from repository https://github.com/<username>/homebrew
- Dotfiles will be used from repository https://github.com/<username>/dotfiles
