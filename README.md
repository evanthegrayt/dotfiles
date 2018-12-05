# Dotfiles, plus so much more!
My dotfiles, plus an installation script with a boat-load of features. It should
go without saying, but here be dragons.

### Rationale
Ideally, you shouldn't need an script this hefty for installing your
configuration, as most people only need to get their environment set up once
per-computer they purchase. However, I regularly have to set up my workflow on
various VMs and Vagrant boxes, and I got tired of contstantly having to manually
set up `vim`, `rvm`, `zsh`, `virtualbox`, `vagrant`, `git-lfs`, and the like.
So, as any good developer would do, I made a script that does it all for me.

### Installation and Features
These are my personal configuration files, and I've taken a lot of steps to make
sure these work on both Linux and BSD, with either `zsh` or `bash` (and `csh`,
although I don't have much set up for it). I doubt you'd want to clone this
entire repository just for my files, but if you do, feel free to do so.

What is much more likely, is that you'd want the installation script, which has
the ability to log changes, backup files, skip installing specified files, clone
my `vim` config, enable terminal italics, install `oh-my-zsh`, `bash_it` and
`rvm`, etc. (basically everything *except* my config files). If this is the
case, you should fork the repository, commit your own dotfiles to your forked
version, and then proceed.

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

By default, the script won't move or overwrite currently-existing files. To
change the way existing files are handled, see the options under
"Handling old dotfiles"

```

Install options (must pass at least one of these options)
  -a         | Allow ignored files to be installed
  -f         | Install all dotfiles
  -s [FILE]  | Install a single dotfile
  -v         | Install vimfiles
  -z         | Install 'oh-my-zsh'
  -b         | Install 'bash-it'
  -m         | Install MacOS files I need for work
             + rvm, command-line-tools, homebrew, git-lfs, virtualbox, vagrant

Additional install options (default: Don't add these settings)
  -C [SHELL] | Change login shell to [SHELL]
  -i         | Enable terminal italics

Handling old dotfiles; pass with '-f' (default: Do nothing if they exist)
  -F         | Force overwrite of all current dotfiles. THIS DELETES OLD COPIES!
  -B         | Replace old dotfiles, but save them with '.bak' extension
  -L         | If file already exists, move it to [FILE].local. This is
             + different from '-B', because my dotfiles will source a file
             + of the same name if it's in the home directory with the
             + '.local' extension. This allows for additional settings to
             + be applied on different systems.

Uninstalling dotfiles
  -u         | Unlink all files
  -U [FILE]  | Unlink FILE
  -R         | With `-u` or `-U`; if dotfile exists with `.bak` or `.local`
             + extension, move it back to original name.

Usage options
  -h         | Print this help and exit

```

Don't manually move things around; the directory and file structure is important
for the install script to work properly. Let the script do all the work for you;
otherwise, why are you cloning this?

There are settings I have that are specifically for work that I didn't want
to publicly commit, so I have added a feature to deal with this issue. If a
file exists in your home directory with the same name, but has a `.local`
extension, that file will be sourced *after* the file from the repository is
loaded. This allows for overriding settings from the files in the repository.
You can keep these locally, or store them in a private repository, which is
what I've done.

### Un-Installation
If you want to un-install just the dotfiles, just run the `install` script with
the `-u` option; however, this script *does* come with a way to safely remove
the entire repository without losing the files saved in the `backup` directory.
Just run the `safely_uninstall_repo` script in the `bin` directory. It will move
all the files in the `backup` directory to your `$HOME` directory before
removing the entire repository.

### Where are your vim runtime files?
Vim supports keeping your `vimrc` within your `.vim` directory itself, and I
have a separate repository for all my `vim` files. You can see them
[here](https://github.com/evanthegrayt/vimfiles)

### Disclaimer
Obviously, the dotfiles in the `resource` directory are set up for my workflow,
so don't be surprised if some things don't work for you, or if you don't like
my setup.

### Reporting Bugs
These are my config files, so a "bug" for you is probably not a "bug" for me;
however, if you see things that could be done more efficiently, anything that
is implemented incorrectly, or you find an actual bug in one of the scripts,
please let me know by
[creating an issue in the
repository](https://github.com/evanthegrayt/dotfiles/issues/new)
detailing the problem.
If it's truly an issue, I'll fix it; otherwise, if it's a configuration
preference, I suggest that you fork the repository and add your own
customizations.

