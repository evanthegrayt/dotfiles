# dotfiles
My dotfiles, plus an installation script. Here be dragons.

### Installation
I doubt you'd want to use my exact config, so I'd recommend just copying the
lines of code that you want and put them in your own config files... but if
you're looking to get weird, you can clone the entire repo. Once cloned, `cd`
into the repository and run the shell script, which is arguably the biggest
reason someone would want to clone this repository.

```sh
bin/install -f
```

By default, the script won't move or overwrite currently-existing files. To
change the way existing files are handled, see the options under
"Handling old dotfiles"

```
USAGE: install [OPTIONS]

Install options (must pass at least one of these options)
  -a         | Allow ignored files to be installed
  -f         | Install all dotfiles
  -s [FILE]  | Install a single dotfile
  -v         | Install vimfiles
  -z         | Install 'oh-my-zsh'
  -b         | Install 'bash-it'
  -r         | Install 'rvm'

Additional install options (default: Don't add these settings)
  -C [SHELL] | Change login shell to [SHELL]
  -i         | Enable terminal italics

Handling old dotfiles; pass with '-f' (default: Do nothing if they exist)
  -F         | Force overwrite of all current dotfiles
  -B         | Replace old dotfiles, but save them with '.bak' extension
  -L         | If file already exists, move it to [FILE].local. This is
             + different from '-B', because my dotfiles will source a file
             + of the same name if it's in the home directory with the
             + '.local' extension. This allows for additional settings to
             + be applied on different systems.
  -u         | Unlink all files
  -U [FILE]  | Unlink FILE
  -R         | With `-u` or `-U`; if dotfile exists with `.bak` or `.local`
             + extension, move it back to original name.

Usage options
  -h         | Print this help and exit
```

Obviously, this is set up for my workflow, so don't be surprised if some stuff
doesn't work for you.

### Other Features
There are settings I have that are specifically for work that I didn't want
to publicly commit, so I have added a feature in all my dotfiles where, if a
file exists in your home directory with the same name, but has a `.local`
extension, that file will be sourced after the file from the repository is
loaded, overwriting settings from the original file. You can keep these locally,
or store them in a private repository (which is what I've done).

### Where are your vim runtime files?
Vim supports keeping your `vimrc` within your `.vim` directory itself, and I
have a separate repository for all my `vim` files. You can see them
[here](https://github.com/evanthegrayt/vimfiles)

