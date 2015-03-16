#!/usr/bin/perl

# usage:
# -a username
# -d username

use Env;
use Term::ReadKey;
use Digest::SHA qw(sha256_hex);
use strict;

my $passwdf = '/etc/openvpn/auth/openvpn.txt';
my %hash;

if( -e $passwdf ) {
    open(my $fh, "<$passwdf") || die $!;
    while(<$fh>) {
        chomp;
        (my $login, my $pass) = split;
        $hash{$login} = $pass;
    }
    close($fh)
}

my $cmd = $ARGV[0];
my $user = $ARGV[1];

die "Please specify username\n" if ( $cmd and not $user );

if ($cmd) {

    if ($cmd eq '-a') {
        my $pass1;
        my $pass2;
        ReadMode('noecho');
        do {
            print "Enter password: ";       chomp($pass1 = <STDIN>); print "\n";
            print "Enter password again: "; chomp($pass2 = <STDIN>); print "\n";
        } while ( $pass1 ne $pass2 );
        ReadMode('restore');
        $hash{$user} = sha256_hex($pass1);
    }

    if ($cmd eq '-d') {
        delete $hash{$user};
    }

    open(my $fh, ">$passwdf") || die $!;
    foreach my $login (sort keys %hash) {
        print $fh $login .' '. $hash{$login} ."\n";
    }
    close($fh);

} else {

    my $user = $ENV{'username'};
    my $pass = $ENV{'password'};
    my $passh = sha256_hex($pass);

    if ( $hash{$user} eq $passh ) {
        exit 0;
    } else {
        exit 1;
    }
}
