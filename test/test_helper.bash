repo_root() {
    cd -- "$BATS_TEST_DIRNAME/.." && pwd -P
}

yadem_bin() {
    printf "%s/bin/yadem\n" "$(repo_root)"
}

setup_install_home() {
    TEST_HOME="$(mktemp -d "${BATS_TEST_TMPDIR}/home.XXXXXX")"
    TEST_CACHE="$(mktemp -d "${BATS_TEST_TMPDIR}/cache.XXXXXX")"
    export TEST_HOME TEST_CACHE
}

run_yadem() {
    HOME="$TEST_HOME" XDG_CACHE_HOME="$TEST_CACHE" run "$(yadem_bin)" "$@"
}

assert_success() {
    if [[ "$status" -ne 0 ]]; then
        printf "expected success, got status %s\n" "$status" >&2
        printf "%s\n" "$output" >&2
        return 1
    fi
}

assert_failure() {
    if [[ "$status" -eq 0 ]]; then
        printf "expected failure, got status 0\n" >&2
        printf "%s\n" "$output" >&2
        return 1
    fi
}

assert_output_contains() {
    local expected="$1"

    if [[ "$output" != *"$expected"* ]]; then
        printf "expected output to contain: %s\n" "$expected" >&2
        printf "%s\n" "$output" >&2
        return 1
    fi
}

assert_output_not_contains() {
    local unexpected="$1"

    if [[ "$output" == *"$unexpected"* ]]; then
        printf "expected output not to contain: %s\n" "$unexpected" >&2
        printf "%s\n" "$output" >&2
        return 1
    fi
}

assert_file_contains() {
    local file="$1"
    local expected="$2"

    if [[ ! -f "$file" ]]; then
        printf "expected file to exist: %s\n" "$file" >&2
        return 1
    fi

    if ! grep -F -- "$expected" "$file" >/dev/null 2>&1; then
        printf "expected %s to contain: %s\n" "$file" "$expected" >&2
        printf "%s\n" "$(cat "$file")" >&2
        return 1
    fi
}
