#!/bin/bash
set -e

chown -R dionaea:dionaea /opt/dionaea/var/log
chown dionaea:dionaea /opt/dionaea/etc/dionaea/dionaea.conf

/opt/dionaea/bin/dionaea -c /opt/dionaea/etc/dionaea/dionaea.conf -w /opt/dionaea -u dionaea -g dionaea > /opt/dionaea/var/log/dionaea.out 2> /opt/dionaea/var/log/dionaea.err

