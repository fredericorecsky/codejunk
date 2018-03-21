
use strict;
use warnings;

my $string = "hostname";

my $no_dot = "nq_" . ( $string =~ s/\.//g ? $string : "" );

print "\n$no_dot\n";
