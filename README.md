# passphrase

This program generates a passphrase using the Diceware algorithm.

Several word lists are available:

* EFF long word list (default)
* Original Diceware word list
* Beale word list
* EFF first short list
* EFF second short list

The source for these word lists is [here](https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases).

## Installation

Run this command to build passphrase:

```
make
```

Run this command to install the binary in `/usr/local/bin` and the word lists
in `/usr/local/share/passphrase`:

```
make install
```

## Usage

Run this command for usage information:

```
passphrase --help
```

## Contributors

- [Mark Alexander](https://github.com/your-github-user) - creator and maintainer
