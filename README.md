# AIM
Using the terminal to login into the NITC Firewall instead of *this:*

![login pic](http://i.imgur.com/3tIwMt2.jpg)

# Dependencies
- bash
- curl

# Installation
    git clone https://github.com/arpankapoor/forti-login.git
    cd forti-login
    chmod u+rx login.sh
    cp login.sh /usr/local/bin/forti-login
    cp forti-login.service /etc/systemd/system/

# Usage
    forti-login [<username>] [<password>]

# Systemd service
Edit the file `/etc/systemd/system/forti-login.service` to change the username
and password. Then enable or start the service.

    systemctl enable forti-login.service
