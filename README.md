# AIM
Using the terminal to login into the NITC Firewall instead of *this:*

![login pic](https://i.imgur.com/qP1V15Y.png)

# Dependencies
- bash
- curl

# Installation
    git clone https://github.com/arpankapoor/forti_login.git
    cd forti_login
    sudo make install

# Usage
    forti_login [-u <username>] [-p <password>] [-f <filename>]

Each line of given file should contain `Tab` delimited username and password.

# Service files
Upstart and systemd service files have been included.
Edit `/etc/init/forti_login.conf` OR
`/usr/lib/systemd/system/forti_login.service` to add your credentials.

Start with `sudo start forti_login` (Upstart) OR
`sudo systemctl start forti_login.service` (systemd).
