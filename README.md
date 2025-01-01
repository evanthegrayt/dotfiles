# My Dotfiles
These are my personal configuration files. Here be dragons.

## Installation
These are my personal configuration files, and I've taken a lot of steps to make
sure these work on both Linux and BSD, with either `zsh` or `bash` (and `csh`,
although I don't have much set up for it). I doubt you'd want to clone this
entire repository just for my files, but if you do, feel free to do so.
Otherwise, just copy the lines you want and paste them into your dotfiles.

Clone the repository and link the files in your home directory. There exists an
installation script in `bin/`, but all it does is try to link the files in your
home directory. If the file already exists, this won't succeed. A list will
print of what installed and what didn't.

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
for your `.bashrc`. Files that support a "local" version are as follows.

- `.zshrc`
- `.bashrc`
- `.bash_profile`
- `.shellrc` (shared by both `.zshrc` and `.bashrc`)
- `.profile`
- `.cshrc`
- `.irbrc`
- `.pryrc`
- `.inputrc`
- `.aliases` (shared by both `.zshrc` and `.bashrc`)


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
