
use strict;
use warnings;

my %struct = (
    base => {
        leaf1   => 24,
        leaf2   => 42,
    },
);


print join "\n", values $struct{base}, "\n";
