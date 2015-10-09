all:
	@echo "Run 'make install' to install."

install:
	install -Dm755 forti_login /usr/bin/forti_login
	install -Dm755 forti_login.service /usr/lib/systemd/system/forti_login.service

.PHONY: all install
