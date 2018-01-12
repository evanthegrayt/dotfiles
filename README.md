# dotfiles
My dotfiles. Here be dragons.

### Installation
I doubt you'd want to use my exact config, so I'd recommend just copying the
lines of code that you want and put them in your own config files... but if
you're looking to get weird, you can clone the entire repo. Once cloned, `cd`
into the repository and run the bootstrap script.

```sh
bash bin/bootstrap.sh -f
```

By default, the bootstrap script won't overwrite currently-existing files. To
overwrite all existing files, run with `-F`

Other options for the bootstrap script include

```
-v: Also set up vim directory, including plugins
-z: Change shell to zsh set up oh-my-zsh
-b: Change shell to bash set up bash-it
-F: Replace current dotfiles if they already exist
```

Obviously, this is set up for my workflow, so don't be surprised when stuff
doesn't work.

### Where are your vim runtime files?
Vim supports keeping your `vimrc` within your `.vim` directory itself, and I
have a separate repository for all my `vim` files. You can see them
[here](https://github.com/evanthegrayt/vimfiles)

