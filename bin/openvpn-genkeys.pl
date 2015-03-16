#!/usr/bin/perl

use Data::Dumper;

require 'openvpn-nodes.pl';

while ($left = shift @nodes) {
    foreach $right (@nodes) {
        $keyfile = 'keys/'. $left->{'name'} .'-'. $right->{'name'} .'.key';
        system("/usr/sbin/openvpn", "--genkey", "--secret", $keyfile) if ! -e $keyfile;
    }
}
