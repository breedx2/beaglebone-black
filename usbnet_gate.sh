#!/bin/bash

set -e 

DEV=`dmesg | grep rndis_host | grep device | sed -e 's/^.*\(eth\|usb\)\(.\):.*/\1\2/'`
DEV=eth2
echo The device is ${DEV}

case "$1" in

up)
    ifconfig $DEV 192.168.7.1 netmask 255.255.255.0
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F
    iptables -X
    iptables -t nat -X
    iptables -t mangle -X

    iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
    iptables -A FORWARD -i $DEV -j ACCEPT

    echo 1 > /proc/sys/net/ipv4/ip_forward

    if ( ifconfig wlan0 | grep -q DOWN ); then
        echo "Don't forget to put up the wlan0 interface!"
    fi
    ;;

down)
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F

    iptables -X
    iptables -t nat -X
    iptables -t mangle -X
    ifconfig $DEV down
    ;;

*)
    echo "Usage: $0 {up|down}"
    exit 1
    ;;

esac

exit 0
