# AIM
Using the terminal to login into the NITC Firewall instead of *this:*

![login pic](https://i.imgur.com/qP1V15Y.png)

# Dependencies
- bash
- curl

# Installation
    git clone https://github.com/arpankapoor/forti_login.git
    cd forti_login
    # make install

# Usage
    forti_login [<username>] [<password>]

# Systemd service
Set the username and password in `/usr/lib/systemd/system/forti_login.service`

## Start service immediately:

    # systemctl start forti_login.service

## Start on boot:

    # systemctl enable forti_login.service
