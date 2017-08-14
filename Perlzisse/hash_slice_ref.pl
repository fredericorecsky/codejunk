
use strict;
use warnings;

my $struct = [
    { 
        a => 31, b => 32, c => 33, d => 34,
    },
    { 
        a => 11, b => 12, c => 13, d => 14,
    },
    { 
        a => 21, b => 22, c => 23, d => 24,
    },
];

for my $item ( @{ $struct } ) {
    print join "\t", @{ $item }{ qw/a d/ };
    print "\n";
}

