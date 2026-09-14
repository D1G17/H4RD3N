#!/usr/bin/env bash
#
# Stateful Packet Inspection (SPI) FW Ruleset
#
# Dropped packets can be observed
# Rules can be saved e.g. via netfilter-persistent save
#
# * Implement SPI for all packets reaching INPUT and FORWARD
# * Allow traffic to SSH (as an anti-lockout rule)
# * Allow traffic via VPN and loopback interfaces
# * Log packets that do not match previous INPUT and FORWARD rules
# * Block packets that do not match previous rules by implementing DROP policy
#
echo "++ Imlementing SPI ruleset..."
iptables -I INPUT -m state --state related,established -j ACCEPT
iptables -I FORWARD -m state --state related,established -j ACCEPT
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
echo "++ Implement Logging..."
for i in tun+ tap+ wg+ lo; do iptables -I INPUT -i $i -j ACCEPT; done
for i in INPUT FORWARD; do iptables -A $i -j LOG --log-prefix `hostname`-$i
echo "++ Set Policy..."
for i in INPUT FORWARD; do iptables -P $i DROP ; done
echo "++ Implemented SPI rules OK+"
exit 0
