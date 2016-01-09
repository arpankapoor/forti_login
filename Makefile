SYSTEMD_DIR=/usr/lib/systemd/system/
UPSTART_DIR=/etc/init/

all:
	@echo "Run 'make install' to install."

install:
	install -Dm755 forti_login /usr/bin/forti_login
	@if [ -d "${SYSTEMD_DIR}" ]; then \
		install -m 644 -t "${SYSTEMD_DIR}" forti_login.service; \
	fi
	@if [ -d "${UPSTART_DIR}" ]; then \
		install -m 644 -t "${UPSTART_DIR}" forti_login.conf; \
	fi

.PHONY: all install
