#!/bin/bash

length=32
use_symbols=0
lower_only=0
challenge_mode=0

print_help() {
  cat <<EOF
Usage: ./rpw [options]

Options:
  -l <length>   Set password length (default: 32)
  -s            Include symbols
  -L            Use lowercase alphanumeric only
  -c            Challenge mode (charset: abcdef0123456789)
  -h, --help    Show this help message
EOF
}


for arg in "$@"; do
  case "$arg" in
    --help)
      print_help
      exit 0
      ;;
  esac
done

while getopts ":l:sLch" opt; do
  case "$opt" in
    l) length="$OPTARG" ;;
    s) use_symbols=1 ;;
    L) lower_only=1 ;;
    c) challenge_mode=1 ;;
    h) print_help; exit 0 ;;
    \?) echo "Invalid option: -$OPTARG"; print_help; exit 1 ;;
  esac
done

if [ "$challenge_mode" -eq 1 ]; then
  charset="abcdef0123456789"
else
  if [ "$lower_only" -eq 1 ]; then
    charset="a-z0-9"
  else
    charset="A-Za-z0-9"
  fi

  if [ "$use_symbols" -eq 1 ]; then
    charset="${charset}!@#\$%^&*()_+-=[]{}|;:,.<>?/"
  fi
fi

LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$length"
echo
