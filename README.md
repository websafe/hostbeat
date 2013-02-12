hostbeat
========

A very simple `host is alive` solution written in Bash for monitoring multiple
hosts.

**Proof of Concept** ;-)


Installation
------------


~~~~ bash
mkdir /etc/websafe
cd /etc/websafe
git clone git://github.com/websafe/hostbeat.git
cp /etc/websafe/hostbeat/cron.d/websafe-hostbeat /etc/cron.d/
~~~~

and restart `crond`

~~~~ bash
service cron restart
~~~~

or

~~~~ bash
/etc/rc.d/rc.crond restart
~~~~


Upgrade
-------

~~~~ bash
cd /etc/websafe/hostbeat/ && git pull
~~~~

