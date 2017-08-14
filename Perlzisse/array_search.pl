
use strict;
use warnings;

my %struct = (
    dcs => [ qw/ index naoindex limao abacate/ ],
);


use Data::Dumper;

my %index;
@index{ values $struct{ dcs } } = ( 0 .. $#{ $struct{ dcs } } );

my @stuff = values $struct{ dcs };

print Dumper \@stuff;

print Dumper \%index;

print $#{ $struct{ dcs } };

print "\n";
