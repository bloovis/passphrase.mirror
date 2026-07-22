passphrase : src/passphrase.cr
	crystal build --no-color --error-trace src/passphrase.cr

install : passphrase /usr/local/share/passphrase
	sudo cp wordlists/*.wordlist /usr/local/share/passphrase
	sudo cp passphrase /usr/local/bin

/usr/local/share/passphrase :
	sudo mkdir /usr/local/share/passphrase
