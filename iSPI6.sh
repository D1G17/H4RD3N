#!/usr/bin/env bash
#
# Minimalistic IPv6 SPI Ruleset
# 
#
ip6tables -I INPUT -i lo -s ::1 -j ACCEPT
ip6tables -I INPUT -m state --state related,established -j ACCEPT
ip6tables -A INPUT -j LOG --log-prefix `hostname`-IP6-IN
ip6tables -P INPUT DROP
