SSL CHeck monitor
=============================

A simple script write in that provide check SSL certificates for your domains list.

Getting started
---------------

Install Ruby and run it!.

### Start ###

Starts the script and response how days you want verify.

    $ ruby certmonitor.rb

### Status ###

In this released version I did not include sending emails since I use a third-party library with private sendgrid credentials.

You can take the domains_to_expire_sendgrid array to integrate it to receive your alerts.


License
-------

Copyright (C) 2020 jhsilva

This is open source software, licensed under the MIT License. See the
file LICENSE for details.
git@github.com:jhsilva007/Ssl_monitoring.git