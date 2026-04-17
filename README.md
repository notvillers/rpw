# rpw — Random PassWord 🔐

A tiny, POSIX-friendly password generator written as a single bash script. Fast, dependency-free, and designed for secure random output from /dev/urandom.

## Quick start

- Make executable:  `chmod +x ./rpw`
- Run:  `./rpw`
- Run with presets: `./rpw --easy | --medium | --hard`

## Parameters

- `-l <length>` Set password length (default: 32)
- `-r <count>`  Number of passwords to generate (default: 1)
- `-o <file>`   Append outputs to file instead of stdout

## Flags

- `-s`  Include symbols in the charset
- `-c`  Challenge/response mode (hex charset; for YubiKey-like flows)
- `-n`  Numbers only
- `-L`  Lowercase alphanumeric only
- `-N`  Require at least one digit
- `-A`  Require at least one alphabetic character (script uses -A)
- `-S`  Require at least one symbol
- `-h`, `--help`    Show help
- `--easy`  Preset: easy (short, lowercase)
- `--medium`    Preset: medium (balanced)
- `--hard`  Preset: hard (symbols + stricter requirements)
- `--yubi-challenge`    Preset: yubi-compatible challenge (hex)

## Examples

- Default:  `./rpw`
- Simple 8-char with all classes:   `./rpw -l 8 -N -A -S`
- Repeat 5 challenge responses: `./rpw -c -r 5`
- Hard preset with custom length:   `./rpw --hard -l 24`
- Save two easy passwords:  `./rpw --easy -r 2 -o passwords.txt`

## Notes

- Uses LC_ALL=C with tr for locale-safe byte filtering from /dev/urandom.
- Script enforces minimum length when "must-have" flags are set.
- No external dependencies: just bash, tr, head, and /dev/urandom.

## Contributing

- Small repo: keep changes minimal and shellcheck-friendly.
- Consider adding tests (bats/shunit2) and CI lint (shellcheck) if contributing larger changes.
