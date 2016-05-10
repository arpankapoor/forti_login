SYSTEMD_DIR=/lib/systemd/system/
UPSTART_DIR=/etc/init/

all:
	@echo "Run 'make install' to install."
	@echo "Run 'make uninstall' to uninstall."

install:
	cp forti_login /usr/bin/forti_login
	[ ! -d "${SYSTEMD_DIR}" ] || cp forti_login.service "${SYSTEMD_DIR}"
	[ ! -d "${UPSTART_DIR}" ] || cp forti_login.conf "${UPSTART_DIR}"
	mkdir -p /usr/share/misc
	cp forti_list /usr/share/misc/forti_list

uninstall:
	$(RM) /usr/bin/forti_login
	$(RM) /usr/share/misc/forti_list
	$(RM) "${SYSTEMD_DIR}"/forti_login.service
	$(RM) "${UPSTART_DIR}"/forti_login.conf

.PHONY: all install uninstall
