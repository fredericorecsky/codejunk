
use strict;
use warnings;

use File::Basename;
use File::Find;

find( \&wanted, $ARGV[0] );

sub wanted {
    if ( $File::Find::dir =~ /cur|new$/ ) {
        print "$File::Find::name\n";
    }
}
