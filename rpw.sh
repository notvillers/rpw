#!/bin/bash

# default variables
length=32
use_symbols=0
lower_only=0
challenge_mode=0
must_have_number=0
must_have_char=0
must_have_symbol=0
min_length=0

# help fn
print_help() {
  cat <<EOF
Usage: ./rpw [options]

Description:
R(andom)P(ass)W(ord) generates a random string from the (pre)specified charset

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

# help arg
for arg in "$@"; do
  case "$arg" in
    --help)
      print_help
      exit 0
      ;;
  esac
done

# getopts
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

# length validate
if ! [[ "$length" =~ ^[0-9]+$ ]] || [ "$length" -lt 1 ]; then
  echo "Error: -l <length> must be a positive integer (1 or larger)." >&2
  exit 1
fi

# challenge mode cannot be combined with must-have flags
if [ "$challenge_mode" -eq 1 ] && [ "$min_length" -gt 0 ]; then
  echo "Error: Challenge mode cannot be combined with -N, -C, or -S flags." >&2
  exit 1
fi

# checking min_length
if [ "$length" -lt "$min_length" ]; then
  echo "Length ($length) is smaller than the minimum required, because you defined:" 
  [ "$must_have_number" -eq 1 ] && echo " - must contain a number"
  [ "$must_have_char" -eq 1 ] && echo " - must contain a character"
  [ "$must_have_symbol" -eq 1 ] && echo " - must contain a symbol"
  exit 1
fi

# determine charset
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

# password generation function
generate_pw() {
  LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$length"
}

# generating password with must-have constraints
password=""
while :; do
  password=$(generate_pw)
  ok=1

  [ "$must_have_number" -eq 1 ] && ! [[ "$password" =~ [0-9] ]] && ok=0
  [ "$must_have_char" -eq 1 ]   && ! [[ "$password" =~ [A-Za-z] ]] && ok=0
  [ "$must_have_symbol" -eq 1 ] && ! [[ "$password" =~ [^A-Za-z0-9] ]] && ok=0

  [ "$ok" -eq 1 ] && break
done

echo "$password"
