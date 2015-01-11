AIM
===
Using the terminal to login into the [NITC](http://www.nitc.ac.in/) Firewall instead of *this:*

![login pic](http://i.imgur.com/3tIwMt2.jpg)

Dependencies
------------
* bash
* curl

Installation
------------
    git clone https://github.com/arpankapoor/forti-login.git
    cd forti-login
    chmod u+rx login.sh
    cp login.sh /usr/local/bin/forti-login

Usage
-----
    forti-login [<username>] [<password>]
