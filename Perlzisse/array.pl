
use strict;
use warnings;


my $element = (return_array())[2];

print "[$element]\n";



sub return_array {
    return  map { "<$_>"} 0  .. 10;
}

