# dotfiles
My dotfiles. Here be dragons.

### Installation
I doubt you'd want to use my exact config, so I'd recommend just copying the
lines of code that you want and put them in your own config files... but if
you're looking to get weird, you can clone the entire repo. Just make sure to
link files that should be dotfiles in your home directory like so:

```sh
ln -s $PATH_TO_REPO/bashrc ~/.bashrc
```

Obviously, replace `$PATH_TO_REPO` with the actual path to where you cloned the
repository.

Also obviously, this is set up for my workflow, so don't be surprised when stuff
doesn't work.

### Where are your vim runtime files?
Vim supports keeping your `vimrc` within your `.vim` directory itself, and I
have a separate repository for all my `vim` files. You can see them
[here](https://github.com/evanthegrayt/vimfiles)

