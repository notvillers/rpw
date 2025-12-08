# R(andom) P(ass)W(ord)

## Parameters and flags

### Parameters:

- l (length): Sets the length of the password(s). Takes a larger than 0 integer. Default is 32
- r (count): Count of printed out password(s). Takes a larger than 0 integer. Default is 1

### Flags:

- s (symbols): Include symbols in the charset
- c (challenge mode): Challenge-response code generator for security key(s), like YubiKey
- n (numbers only): Password must contain number(s) only
- L (lowercase): Uses lowercase alphanumeric characters in the charset
- N (number need): Password must contain a digit
- C (character needed): Password must contain an alphanumeric character
- S (symbol needed): Password must contain a symbol
- h (help): Shows help message
- easy (easy): Sets parameters for an easy password (Can be freely combined with other available flags)
- medium (medium): Sets parameters for a mediun password (Can be freely combined with other available flags)
- hard (hard): Sets parameters for a hard password (Can be freely combined with other available flags)

## Usage

### Examples

```
# default
~ ./rpw
OTe6KDEVGwDvkwYsUqNSkcgFsDJV4nB8

# set length and flags
~ ./rpw -l 8 -N -C -S
w7z@.Sk=

# repeated challenge-response(s)
~ ./rpw -c -r 5
cad28c8425f3f83d70037e3ab8cad0ea
d10c4ef5f09e813f91915890112c32e3
95e3af1f5d9344fcaf2546c3c3e6a96b
c6c249b3b0982e6b95e8be9ed121e350
79f1ad3700f47b5e30fa271b2a1e3ea3

# hard password with modified length
~ ./rpw --hard -l 24       
;!]CL|12?W3wl=}Q=1=I=f7M
```