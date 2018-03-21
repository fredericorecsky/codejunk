

use strict;
use warnings;


for my $value ( 1 .. 10 ) {
    eval {
        die "hur" if $value == 3;
        1;
    } or do{
        last;
    };

    print $value . "\n";
    
}
