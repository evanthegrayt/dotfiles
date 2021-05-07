# My Dotfiles
These are my personal configuration files. Here be dragons.

If you're looking for my old dotfiles install script, it's been moved to
[yadem](https://github.com/evanthegrayt/yadem). Sorry for
any inconvenience!

## Installation
These are my personal configuration files, and I've taken a lot of steps to make
sure these work on both Linux and BSD, with either `zsh` or `bash` (and `csh`,
although I don't have much set up for it). I doubt you'd want to clone this
entire repository just for my files, but if you do, feel free to do so.
Otherwise, just copy the lines you want and paste them into your dotfiles.

If you want the whole enchilada, I recommend installing
[yadem](https://github.com/evanthegrayt/yadem) and following
the
[README](https://github.com/evanthegrayt/yadem/blob/master/README.md).

If you don't want the manager script, just clone the repository and link the
files in your home directory. There exists an installation script in `bin/`, but
all it does is try to link the files in your home directory. If the file already
exists, this won't succeed. A list will print of what installed and what didn't.
```sh
git clone https://github.com/evanthegrayt/dotfiles.git
cd dotfiles
bash bin/install
```
### "Local" Config Files
Something I did that people might find interesting: There are settings I have
that are specifically for work that I didn't want to publicly commit, so I have
added a feature to deal with this issue. If a file exists in your home directory
with the same name, but has a `.local` extension, that file will be sourced
*after* the file from the repository is loaded. This allows for overriding
settings from the files in the repository. You can keep these locally, or store
them in a private repository, which is what I've done. Currently, only one
"local" counterpart is supported for each dotfile; that is, one `.bashrc.local`
for your `.bashrc`. You can find which files will source "local" counterparts in
the [config
folder](https://github.com/evanthegrayt/yadem/blob/master/config/local_files.yml)
of my [CLI environment manager
script](https://github.com/evanthegrayt/yadem.git).

## FAQ
#### Where's your vimrc?
Vim supports keeping your `vimrc` within your `.vim` directory itself, and I
have a separate repository for all my `vim` files. You can see them
[here](https://github.com/evanthegrayt/vimfiles).

## Self-Promotion
I do these projects for fun, and I enjoy knowing that they're helpful to people.
Consider starring [the repository](https://github.com/evanthegrayt/dotfiles) if
you like it! If you love it, follow me [on
github](https://github.com/evanthegrayt)!
