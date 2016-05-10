# AIM

Automating login to the [NITC][nitc] Firewall instead of wasting time on *this:*

![login pic][login_pic]

## Dependencies

- bash
- curl

## Installation

~~~ bash
git clone https://github.com/arpankapoor/forti_login.git
cd forti_login
sudo make install
~~~

## Uninstallation

~~~ bash
sudo make uninstall
~~~

## Usage

~~~ bash
forti_login [-u <username>] [-p <password>] [-f <filename>]
~~~

Each line of input file should contain username and password delimited
by whitespace (see the file `forti_list`).

## Service files

Upstart and systemd service files have been included.

Start with

1. Upstart: `sudo initctl start forti_login`
2. systemd: `sudo systemctl start forti_login.service`

To start on boot:

1. Upstart: Add the following lines to the beginning of the upstart config file.

        start on runlevel [2345]
        stop on runlevel [!2345]

2. systemd: `sudo systemctl enable forti_login.service`

[nitc]: http://www.nitc.ac.in/
[login_pic]: https://i.imgur.com/qP1V15Y.png
