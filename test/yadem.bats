#!/usr/bin/env bats

load test_helper

setup() {
    setup_install_home
}

write_yadem_config() {
    TEST_YADEM_CONFIG="$BATS_TEST_TMPDIR/yademrc.$BATS_TEST_NUMBER"
    export TEST_YADEM_CONFIG
    export YADEM_CONFIG="$TEST_YADEM_CONFIG"

    printf "%s\n" "$@" > "$TEST_YADEM_CONFIG"
}

@test "list prints available install targets" {
    run_yadem --list

    assert_success
    assert_output_contains "all"
    assert_output_contains "bash"
    assert_output_contains "brew"
    assert_output_contains "dotfiles"
    assert_output_contains "gems"
    assert_output_contains "homebrew"
    assert_output_contains "italics"
    assert_output_contains "macos"
    assert_output_contains "repos"
    assert_output_contains "shell"
    assert_output_contains "vim"
    assert_output_contains "zsh"
}

@test "global help includes options and targets" {
    run_yadem --help

    assert_success
    assert_output_contains "USAGE: yadem [OPTIONS] TARGET [TARGET...]"
    assert_output_contains "-t, --test"
    assert_output_contains "-a, --all"
    assert_output_contains "-l, --list"
    assert_output_contains "dotfiles"
}

@test "target help is delegated to the target script" {
    run_yadem dotfiles --help

    assert_success
    assert_output_contains "USAGE: yadem [OPTIONS] dotfiles"
    assert_output_contains "Existing symlinks are replaced"
}

@test "unknown target fails with a useful message" {
    run_yadem nope

    assert_failure
    assert_output_contains "Unknown install target: nope"
    assert_output_contains "Run yadem --list"
}

@test "brew dry-run prints Brewfile action and writes a log" {
    run_yadem --test brew

    assert_success
    assert_output_contains "Would install Homebrew packages from"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "brew would-install"
}

@test "gems dry-run prints gem actions and writes a log" {
    run_yadem --test gems

    assert_success
    assert_output_contains "Would install gem: standard"
    assert_output_contains "Would install gem: spoonerize"
    assert_output_contains "Would install gem: standup_md"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "gems would-install Would install gem: standard"
}

@test "dotfiles dry-run reports actions without modifying home" {
    printf "local zshrc\n" > "$TEST_HOME/.zshrc"
    ln -s /tmp/old-dotfile-target "$TEST_HOME/.bashrc"
    mkdir -p "$TEST_HOME/.config"

    run_yadem --test dotfiles

    assert_success
    assert_output_contains "Would back up $TEST_HOME/.zshrc"
    assert_output_contains "Would replace symlink: $TEST_HOME/.bashrc"
    assert_output_contains "Skipped existing directory: $TEST_HOME/.config"
    assert_output_contains "Dry run complete. Log written to $TEST_CACHE/yadem/install.log"
    assert_output_not_contains "Would link:"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "dotfiles would-back-up"

    [[ ! -L "$TEST_HOME/.zshrc" ]]
    [[ "$(cat "$TEST_HOME/.zshrc")" == "local zshrc" ]]
    [[ "$(readlink "$TEST_HOME/.bashrc")" == "/tmp/old-dotfile-target" ]]
    [[ -d "$TEST_HOME/.config" ]]
}

@test "dotfiles install links missing files" {
    run_yadem dotfiles

    assert_success
    [[ -L "$TEST_HOME/.zshrc" ]]
    [[ "$(readlink "$TEST_HOME/.zshrc")" == "$(repo_root)/dotfiles/zshrc" ]]
    assert_output_contains "Done. Log written to $TEST_CACHE/yadem/install.log"
    assert_output_not_contains "Linked:"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "dotfiles linked"
}

@test "dotfiles install replaces existing symlinks" {
    ln -s /tmp/old-dotfile-target "$TEST_HOME/.zshrc"

    run_yadem dotfiles

    assert_success
    [[ -L "$TEST_HOME/.zshrc" ]]
    [[ "$(readlink "$TEST_HOME/.zshrc")" == "$(repo_root)/dotfiles/zshrc" ]]
    assert_output_contains "Replaced symlink: $TEST_HOME/.zshrc"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "dotfiles replaced-link"
}

@test "dotfiles install backs up existing regular files" {
    printf "local zshrc\n" > "$TEST_HOME/.zshrc"

    run_yadem dotfiles

    assert_success
    [[ -L "$TEST_HOME/.zshrc" ]]
    [[ "$(readlink "$TEST_HOME/.zshrc")" == "$(repo_root)/dotfiles/zshrc" ]]
    [[ -f "$TEST_CACHE/yadem/zshrc.$(date +%F)" ]]
    [[ "$(cat "$TEST_CACHE/yadem/zshrc.$(date +%F)")" == "local zshrc" ]]
    assert_file_contains "$TEST_CACHE/yadem/install.log" "dotfiles backed-up"
}

@test "dotfiles install increments backup names when today's backup exists" {
    mkdir -p "$TEST_CACHE/yadem"
    printf "previous backup\n" > "$TEST_CACHE/yadem/zshrc.$(date +%F)"
    printf "local zshrc\n" > "$TEST_HOME/.zshrc"

    run_yadem dotfiles

    assert_success
    [[ -f "$TEST_CACHE/yadem/zshrc.$(date +%F).1" ]]
    [[ "$(cat "$TEST_CACHE/yadem/zshrc.$(date +%F).1")" == "local zshrc" ]]
}

@test "dotfiles install can preserve supported existing files as local files" {
    write_yadem_config \
        "YADEM_LOCALIZE_EXISTING=true" \
        "YADEM_LOCAL_FILES=(zshrc)"
    printf "local zshrc\n" > "$TEST_HOME/.zshrc"

    run_yadem dotfiles

    assert_success
    [[ -L "$TEST_HOME/.zshrc" ]]
    [[ -L "$TEST_HOME/.zshrc.local" ]]
    [[ "$(cat "$TEST_HOME/.zshrc.local")" == "local zshrc" ]]
    assert_file_contains "$TEST_CACHE/yadem/install.log" "dotfiles linked-local"
}

@test "dotfiles install skips existing directories" {
    mkdir -p "$TEST_HOME/.config"

    run_yadem dotfiles

    assert_success
    [[ -d "$TEST_HOME/.config" ]]
    [[ ! -L "$TEST_HOME/.config" ]]
    assert_output_contains "Skipped existing directory: $TEST_HOME/.config"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "dotfiles skipped-directory"
}

@test "dotfiles install continues when log cannot be written" {
    printf "not a directory\n" > "$TEST_HOME/not-directory"
    export YADEM_LOG="$TEST_HOME/not-directory/install.log"

    run_yadem --test dotfiles

    assert_success
    assert_output_contains "Warning: could not write install log: $YADEM_LOG"
    assert_output_contains "Dry run complete. Log could not be written to $YADEM_LOG"
}

@test "multiple dry-run targets run in order" {
    run_yadem --test brew gems

    assert_success
    assert_output_contains "Would install Homebrew packages from"
    assert_output_contains "Would install gem: standard"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "brew would-install"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "gems would-install"
}

@test "--all runs the configured target sequence" {
    write_yadem_config \
        "YADEM_ALL_TARGETS=(gems)" \
        "YADEM_GEMS=(example_gem)"

    run_yadem --test --all

    assert_success
    assert_output_contains "Running target: gems"
    assert_output_contains "Would install gem: example_gem"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "all running-target Running target: gems"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "gems would-install Would install gem: example_gem"
}

@test "repos dry-run uses configured repositories" {
    write_yadem_config \
        "YADEM_REPO_DIR=\"$TEST_HOME/workflow\"" \
        "YADEM_REPOS=(https://github.com/example/project)"

    run_yadem --test repos

    assert_success
    assert_output_contains "Would clone https://github.com/example/project.git to $TEST_HOME/workflow/project"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "repos would-clone"
}

@test "shell dry-run reports missing shell configuration" {
    write_yadem_config "YADEM_LOGIN_SHELL=''"

    run_yadem --test shell

    assert_success
    assert_output_contains "YADEM_LOGIN_SHELL is not configured"
    assert_file_contains "$TEST_CACHE/yadem/install.log" "shell skipped"
}
