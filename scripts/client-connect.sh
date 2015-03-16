#!/bin/sh

/usr/sbin/arp -i vmbr0 -Ds $ifconfig_pool_remote_ip vmbr0 pub
