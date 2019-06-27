# My Dotfiles
These are my personal configuration files. Here be dragons.

If you're looking for my old dotfiles install script, it's been moved to
[cli-env-manager](https://github.com/evanthegrayt/cli-env-manager). Sorry for
any inconvenience!

## Installation
These are my personal configuration files, and I've taken a lot of steps to make
sure these work on both Linux and BSD, with either `zsh` or `bash` (and `csh`,
although I don't have much set up for it). I doubt you'd want to clone this
entire repository just for my files, but if you do, feel free to do so.
Otherwise, just copy the lines you want and paste them into your dotfiles.

If you want the whole enchilada, I recommend installing my
[cli-env-manager](https://github.com/evanthegrayt/cli-env-manager) and following
the
[README](https://github.com/evanthegrayt/cli-env-manager/blob/master/README.md).

If you don't want the manager script, just clone the repository and link the
files in your home directory.
```sh
git clone https://github.com/evanthegrayt/dotfiles.git
for i in $PWD/dotfiles/resource/*; do ln -s "$i" $HOME/."${i##*/}"; done
```

