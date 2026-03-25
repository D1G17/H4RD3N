#!/usr/bin/env bash
#
# Stateful Packet Inspection (SPI) FW Ruleset
#
# Dropped packets can be observed and rules created
# Rules can be saved e.g. via netfilter-persistent save
#
# * Implement SPI for all packets reaching INPUT and FORWARD
# * Allow traffic to SSH (as an anti-lockout rule)
# * Allow traffic via VPN and loopback interfaces
# * Log packets that do not match previous INPUT and FORWARD rules
# * Block packets that do not match previous rules by implementing DROP policy
#
iptables -I INPUT -m state --state related,established -j ACCEPT
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
for i in tun+ tap+ wg+ lo; do iptables -I INPUT -i $i -j ACCEPT; done
iptables -A INPUT -j LOG --log-prefix `hostname`-INPUT
iptables -I FORWARD -m state --state related,established -j ACCEPT
iptables -A FORWARD -j LOG --log-prefix `hostname`-INPUT
for i in INPUT FORWARD; do iptables -P $i DROP ; done
exit 0
