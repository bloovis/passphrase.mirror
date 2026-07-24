# passphrase

This Crystal program generates a passphrase using the Diceware algorithm.

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

With no arguments, `passphrase` prints a 6-word passphrase using
the EFF long word list.

For additional usage information, use this command:

```
passphrase --help
```

Here is the output of that command:

```
Usage: passphrase [args]
Generates a passphrase using diceware
    -w SIZE, --words=SIZE            Specifies the number of words for the passphrase
    -n NUMBER, --phrases=NUMBER      Specifies the number of passphrases to generate
    -l, --lowercase                  Don't capitalize words
    -b, --beale                      Use the Beale word list
    -d, --diceware                   Use the Diceware word list
    -s, --short                      Use the EFF short word list
    -a, --alternate                  Use the alternate EFF short word list
    -x STRING, --separator=STRING    Specifies the word separator
    -v, --verbose                    Print extra information
    -h, --help                       Show this help
```

To send a passphrase to the clipboard without displaying
it, use this command on Wayland:

```
passphrase | wl-copy
```

or use this command on X11:

```
passphrase | xclip
```

## Contributors

- [Mark Alexander](https://github.com/your-github-user) - creator and maintainer
