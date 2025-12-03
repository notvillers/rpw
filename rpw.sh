#!/bin/bash
set -e

# Default variables
length=32 # Default length
use_symbols=0
lower_only=0
challenge_mode=0
must_have_number=0
must_have_char=0
must_have_symbol=0
min_length=0

# Print help
print_help() {
  cat <<EOF
Usage: $(basename "$0") [options]

Description:
R(andom)P(ass)W(ord) generates a random string from the (pre)specified charset, default charset is [A-Za-z0-9].

Options:
  -l <length>     Set password length (default: 32)
  -s              Include symbols
  -c              Challenge mode (charset: abcdef0123456789)
  -L              Use lowercase alphanumeric only
  -N              Password must contain a digit
  -C              Password must contain a character
  -S              Password must contain a symbol
  -h, --help      Show this help message
EOF
}

# Help arg
for arg in "$@"; do
  case "$arg" in
    --help)
      print_help
      exit 0
      ;;
  esac
done

# Options
while getopts ":l:scLhNCS" opt; do
  case "$opt" in
    l) length="$OPTARG" ;;
    s) use_symbols=1 ;;
    c) challenge_mode=1 ;;
    L) lower_only=1 ;;
    N) must_have_number=1; ((min_length++)) ;;
    C) must_have_char=1;   ((min_length++)) ;;
    S) must_have_symbol=1; ((min_length++)) ;;
    h) print_help; exit 0 ;;
    \?) echo "Invalid option: -$OPTARG"; print_help; exit 1 ;;
  esac
done

# Length validate
if ! [[ "$length" =~ ^[0-9]+$ ]] || [ "$length" -lt 1 ]; then
  echo "Error: -l <length> must be a positive integer (1 or larger)." >&2
  exit 1
fi

# Challenge mode cannot be combined with must-have flags
if [ "$challenge_mode" -eq 1 ] && [ "$min_length" -gt 0 ]; then
  echo "Error: Challenge mode cannot be combined with -s, -L, -N, -C, or -S flags." >&2
  exit 1
fi

# Checking min_length
if [ "$length" -lt "$min_length" ]; then
  echo "Length ($length) is smaller than the minimum required ($min_length), because it must contain:" 
  [ "$must_have_number" -eq 1 ] && echo " - a number"
  [ "$must_have_char" -eq 1 ] && echo " - a character"
  [ "$must_have_symbol" -eq 1 ] && echo " - a symbol"
  exit 1
fi

# Determine charset
if [ "$challenge_mode" -eq 1 ]; then
  charset="abcdef0123456789"
else
  if [ "$lower_only" -eq 1 ]; then
    charset="a-z0-9"
  else
    charset="A-Za-z0-9"
  fi

  if [ "$use_symbols" -eq 1 ] || [ "$must_have_symbol" -eq 1 ]; then
    charset="${charset}!@#\$%^&*()_+-=[]{}|;:,.<>?/"
  fi
fi

# Password generation function
generate_pw() {
  LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$length"
}

# Generating password with constraint checks
password=""
while :; do
  password=$(generate_pw)
  ok=1

  # Check for number, if needed
  [ "$must_have_number" -eq 1 ] && ! [[ "$password" =~ [0-9] ]] && ok=0

  # Check for alphabetic char, if needed
  [ "$must_have_char" -eq 1 ]   && ! [[ "$password" =~ [A-Za-z] ]] && ok=0

  # Check for symbol, if needed
  [ "$must_have_symbol" -eq 1 ] && ! [[ "$password" =~ [^A-Za-z0-9] ]] && ok=0

  [ "$ok" -eq 1 ] && break
done

echo "$password"
