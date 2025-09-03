# Hint: Rules can be saved e.g. via netfilter-persistent
# Implement SPI for all packets reaching INPUT
iptables -I INPUT -m state --state related,established -j ACCEPT
# Allow traffic to SSH (as an anti-lockout rule)
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
# Allow traffic via VPN (OpenVPN, wireguard) and loopback interfaces
for i in tap+ wg+ lo; do iptables -I INPUT -i $i -j ACCEPT; done
# Log packets that do not match previous rules
iptables -A INPUT -j LOG --log-prefix `hostname`-INPUT
# Block packets that do not match previous rules
iptables -A INPUT -j DROP
exit 0
