
use strict;
use warnings;

package Foo {

    my %a : ATTR(:Name<x>);
    
    use Data::Dumper;
    print Dumper $a;
    
1;

}


