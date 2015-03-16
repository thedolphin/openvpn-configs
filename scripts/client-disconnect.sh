#!/bin/sh

/usr/sbin/arp -i vmbr0 -d $ifconfig_pool_remote_ip
