# Dotfiles, plus so much more!
My dotfiles, plus an installation script with a boat-load of features.

It should go without saying, but here be dragons, as this repository contains
files that you definitely don't want, like my global `.gitconfig` file.

## Rationale
Ideally, you shouldn't need a script this hefty for installing your
configuration, as most people only need to get their environment set up once
per-computer they purchase. However, I regularly have to set up my workflow on
various VMs and Vagrant boxes, and I got tired of contstantly having to manually
set up `vim`, `rvm`, `zsh`, `virtualbox`, `vagrant`, `git-lfs`, and the like.
So, I made a script that does it all for me.

## Installation
These are my personal configuration files, and I've taken a lot of steps to make
sure these work on both Linux and BSD, with either `zsh` or `bash` (and `csh`,
although I don't have much set up for it). I doubt you'd want to clone this
entire repository just for my files, but if you do, feel free to do so.

What is much more likely, is that you'd want the installation script, which has
the ability to log changes, backup files, skip installing specified files, clone
my `vim` config, enable terminal italics, install `oh-my-zsh`, `bash_it` and
`rvm`, etc.. If this is the case, you should fork the repository, commit your
own dotfiles to your forked version, and then proceed.

If you want the whole enchilada, clone my repository wherever you want it:
```sh
git clone https://github.com/evanthegrayt/dotfiles.git
```
...or clone your forked version. Then run the installation script from within
the repository:
```sh
cd dotfiles
bin/install -f
```
This will link the files from `resource/` to `$HOME` as dotfiles, unless the
file is in the `lib/ignore.yml` file. By default, the script won't move or
overwrite currently-existing files. To change the way existing files are
handled, see the options under "Handling old dotfiles" in the
[help documentation](lib/help_menu.txt). There are also a lot of other options,
including installing a single file, cloning shell frameworks, etc.

Moving the files around is heavily discouraged, as the directory and file
structure is important for the install script to work properly. Let the script
do all the work for you; otherwise, why are you cloning this?

## Features
Some, but not all, of the features include:

### Logging
Everything that's done by the install script is logged, whether it's
installation of programs or linking of files. There will be a log file for every
day the `bin/install` script is run, and these will be located in the `log/`
directory, along with timestamps. You can print the log file for today's date
using `bin/install -p`. To print an older log file, run `bin/install -P [DATE]`.
To get a list of log files, run `bin/install -l`

### "Local" Config Files
There are settings I have that are specifically for work that I didn't want
to publicly commit, so I have added a feature to deal with this issue. If a
file exists in your home directory with the same name, but has a `.local`
extension, that file will be sourced *after* the file from the repository is
loaded. This allows for overriding settings from the files in the repository.
You can keep these locally, or store them in a private repository, which is what
I've done. Currently, only one "local" counterpart is supported for each
dotfile; that is, one `.bashrc.local` for your `.bashrc`. you can find which
files will source "local" counterparts in the [config
folder](config/local_files.yml).

### Custom Repositories
You can add repositories to [file in the config
folder](config/git_repos.yml) to be cloned with the `-c` option. When
this option is passed, the repository will be cloned, and if there's a
`Rakefile` or `Makefile`, it will be executed.

### Install Packages with Brew
There are two files in the `config` folder which allow you to add programs to be
installed with [brew](config/brew_taps.yml) or [brew
cask](config/brew_casks.yml).

### Ruby Gems
You can add ruby gems to [a file](config/ruby_gems.yml) and install them
with `-g`.

### Constants
If you're careful, you can edit the [constants file](lib/constants.sh). I've
tried to put things I think that people might want to change in this file, such
as `REPO_DIR=`, which defines where custom `git` repositories will be cloned.

## Un-Installation
If you want to un-install just the dotfiles, just run the `install` script with
the `-u` option; however, this script *does* come with a way to safely remove
the entire repository without losing the files saved in the `backup` directory.
Just run the `safely_uninstall_repo` script in the `bin` directory. It will move
all the files in the `backup` directory to your `$HOME` directory before
removing the entire repository.

## FAQ
#### Where are your vim runtime files?
Vim supports keeping your `vimrc` within your `.vim` directory itself, and I
have a separate repository for all my `vim` files. You can see them
[here](https://github.com/evanthegrayt/vimfiles).

#### What about other repositories, like oh-my-zsh? Why not use submodules?

I tried keeping repositories in here as submodules (such as `vim`, `oh-my-zsh`,
etc.), but I didn't like it, as I wanted more control over what gets installed.
Having the option to install these other repositories via the `install` script
seemed like the best compromise.

## Disclaimers
Obviously, the dotfiles in the `resource` directory are set up for my workflow,
so don't be surprised if some things don't work for you, or if you don't like
my setup.

Also, I've given users a lot of options for saving/backing up their
old dotfiles, but it IS possible to delete your old files. As I've said, I
*really* recommend forking this repository and replacing my files by committing
your files to the `resource/` directory.

## Reporting Bugs
When it comes to the config files, a "bug" for you is probably not a "bug" for
me. However, there could be issues with the install script, so if you see one,
please let me know by
[creating an issue in the
repository](https://github.com/evanthegrayt/dotfiles/issues/new)
detailing the problem. If it's an issue, I'll fix it; otherwise, if it's a
configuration preference, I suggest that you fork the repository and add your
own customizations.

