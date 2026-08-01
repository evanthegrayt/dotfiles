# My Dotfiles
These are my personal configuration files. Here be dragons.

## About
I admit that I'm a customization fanatic, so when I find a new tool that's fun
to customize, I tend to go wild. I've spent over two decades accumulating
settings for Zsh, Bash, and even Csh on both macOS and Linux. I've done a lot
of work to keep this repo as consistent as possible across operating systems
and shells, but I make no guarantees.

Some files I haven't touched in years; others were probably edited yesterday.
If you find a setting you like, I can't promise it won't change tomorrow.

My current development environment is running Zsh on macOS with Vim and iTerm2.
I love programming with Ruby, and I write Bash scripts for portability. Files
related to those tools are the most likely to be modern, but also the most
likely to frequently change.

## Rationale
I keep these files public because I am regularly asked about my configuration.
Ideally, you wouldn't install them directly; just copy the lines you want into
your own files. However, I know some people like to try out an entire config, so
if that's you, read on for further info.

## Installation
The files live in `dotfiles/` without a leading dot so they stay visible and
easy to browse in the repository. When using them directly, symlink or copy the
files you want into your home directory with the leading dot added. For example,
`dotfiles/zshrc` maps to `~/.zshrc`. See [the "Related" section](#related) for
help with automation.

Nested directories follow the same idea:

- `dotfiles/config/psysh/config.php` maps to `~/.config/psysh/config.php`
- `dotfiles/ctags.d/` maps to `~/.ctags.d/`

## Local Files
Some dotfiles source a matching `.local` file after loading the repository
version. This keeps machine-specific or private settings out of the public
repo, while still letting the shared file define the default behavior.

For example, `dotfiles/zshrc` will source `~/.zshrc.local` if it exists.

Files with local override support:

- `.aliases`
- `.bash_profile`
- `.bashrc`
- `.cshrc`
- `.inputrc`
- `.irbrc`
- `.profile`
- `.pryrc`
- `.shellrc`
- `.zshrc`

## Shells
Most of the shell setup is shared through `shellrc`, which is sourced by both
`bashrc` and `zshrc`. Shell-specific startup files stay separate where the
shells expect them.

The `cshrc`, `logout`, `zlogin`, and `zlogout` files are still here for systems
where I end up needing compatibility with older environments or shell-specific
login/logout hooks.

## Vim
There is no `vimrc` here. Vim supports keeping its config inside `~/.vim`, and I
keep that setup in a [separate repository](https://github.com/evanthegrayt/vimfiles).

## Related
Automated installation and further system bootstrapping lives in
[yadem](https://github.com/evanthegrayt/yadem).
