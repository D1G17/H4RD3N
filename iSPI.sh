#!/usr/bin/env bash
#
# Stateful Packet Inspection (SPI) FW Ruleset
#
#
# Hint: Rules can be saved e.g. via netfilter-persistent save
# Implement SPI for all packets reaching INPUT
iptables -I INPUT -m state --state related,established -j ACCEPT
# Allow traffic to SSH (as an anti-lockout rule)
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
# Allow traffic via VPN and loopback interfaces
for i in tun+ tap+ wg+ lo; do iptables -I INPUT -i $i -j ACCEPT; done
# Log packets that do not match previous INPUT rules
iptables -A INPUT -j LOG --log-prefix `hostname`-INPUT
# Block packets that do not match previous rules by implementing DROP policy
iptables -A INPUT -P DROP
# Implement SPI for all packets reaching FORWARD
iptables -I FORWARD -m state --state related,established -j ACCEPT
# Log packets that do not match previous FORWARD rules
iptables -A FORWARD -j LOG --log-prefix `hostname`-INPUT
# Block packets that do not match previous rules by imlementing DROP policy
iptables -A FORWARD -P DROP
exit 0
