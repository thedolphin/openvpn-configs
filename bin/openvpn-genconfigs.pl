#!/usr/bin/perl

require 'openvpn-nodes.pl';

$thisnodeindex = 0;
$portbase = 1194;

$thisnode = @nodes[$thisnodeindex];

foreach $node (@nodes) {
    next if $node->{'id'} == $thisnode->{'id'};

    if ($node->{'id'} > $thisnode->{'id'}) {
        $keyname= $thisnode->{'name'} .'-'. $node->{'name'};
        $port = $portbase + 20 * $thisnode->{'id'} + $node->{'id'};
    } else {
        $keyname= $node->{'name'} .'-'. $thisnode->{'name'};
        $port = $portbase + 20 * $node->{'id'} + $thisnode->{'id'};
    }


    open($fh, ">../$keyname.conf");
    print $fh "dev tun$node->{'id'}
remote $node->{'global_ip'}
local $thisnode->{'global_ip'}
port $port
proto udp
secret /etc/openvpn/keys/$keyname.key
ifconfig 10.32.$thisnode->{'id'}.$node->{'id'} 10.32.$node->{'id'}.$thisnode->{'id'}
route-noexec
route-up \"/bin/ip route replace $node->{'network'} dev tun$node->{'id'} src $thisnode->{'local_ip'}\";
log \"/var/log/openvpn-$keyname.log\"
script-security 2
";

}
