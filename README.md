# dotfiles
My dotfiles, plus an installation script. Here be dragons.

### Installation
I doubt you'd want to use my exact config, so I'd recommend just copying the
lines of code that you want and put them in your own config files... but if
you're looking to get weird, you can clone the entire repo. Once cloned, `cd`
into the repository and run the shell script.

```sh
bash bin/bootstrap.sh -f
```

By default, the script won't overwrite currently-existing files. To overwrite
all existing files, run with `-F`

Some other options for the installation script include:

```txt
-v: Also set up vim directory, including plugins
-z: Change shell to zsh set up oh-my-zsh
-b: Change shell to bash set up bash-it
-F: Replace current dotfiles if they already exist
-h: See all available options
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

