# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

`rpw` is a single-file bash password generator (`./rpw`). No build step, no dependencies beyond bash, tr, head, awk, and /dev/urandom.

## Running and linting

```bash
# Run directly
./rpw
./rpw --easy
./rpw -l 16 -N -A -S

# Lint (install shellcheck first if needed)
shellcheck rpw

# Test with bats (if test suite is added)
bats tests/
```

## Architecture

Everything lives in the single `rpw` script:

1. **Argument parsing** — long options (`--easy`, `--clipboard`, `--format=`) are pre-processed in a loop before `getopts` handles short flags.
2. **Charset selection** — built from `tr` POSIX character classes (`[:alnum:]`, `[:digit:]`, etc.) except challenge mode which uses a literal hex string.
3. **Generation loop** — draws from `/dev/urandom` via `LC_ALL=C tr -dc`, then re-rolls if must-have constraints (`-N`, `-A`, `-S`) aren't satisfied.
4. **Output** — results are collected in the `results[]` array, then formatted as plain or JSON and written to stdout or appended to a file. Stdout is suppressed when `-o` or `--clipboard` is active.
5. **Clipboard** — tries `pbcopy` → `xclip` → `xsel` in order; silently no-ops if none is available.

## Known gap

The README and `-f` help text advertise `csv` as a supported format, but the script's `case "$format"` block has no csv branch and will exit with an error if `--format=csv` is passed. Add a csv branch before the `*` catch-all when implementing it.
