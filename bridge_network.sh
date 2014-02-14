#!/bin/bash

ifconfig eth2 192.168.7.1 netmask 255.255.255.0
echo "1" > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1
route add -host 192.168.254.101 eth2
