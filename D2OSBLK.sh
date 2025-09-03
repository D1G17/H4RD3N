#!/bin/env bash
echo "Usage: ./D2OSBLK.sh I[nsert]|D[elete] aa.bb.cc"
for i in $2 ; do sudo iptables -t mangle -$1 PREROUTING -m iprange --src-range $i.0-$i.255 -j DROP ; done
echo "Operation: $1 $2"
exit 0
