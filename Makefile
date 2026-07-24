passphrase : src/passphrase.cr
	crystal build --no-color --error-trace src/passphrase.cr

install : passphrase /usr/local/share/passphrase
	sudo cp wordlists/*.wordlist /usr/local/share/passphrase
	sudo cp passphrase /usr/local/bin

install-ruby : src/passphrase.rb /usr/local/share/passphrase
	sudo cp wordlists/*.wordlist /usr/local/share/passphrase
	sudo cp src/passphrase.rb /usr/local/bin/passphrase

/usr/local/share/passphrase :
	sudo mkdir /usr/local/share/passphrase
