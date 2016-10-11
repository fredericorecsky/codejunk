
use strict;
use warnings;

use Redis;

my $redis = Redis->new( server => "127.0.0.1:6379" );

#sleep 30;

for my $number ( 0 .. 1_000_000 ) {
    $redis->set( "Default_$number" => "Detault_$number" );
}

#sleep 10;

for my $number ( 0 .. 1_000_000 ) {
    my $keyword = $redis->get( "Default_$number" );
    print "$keyword\n";
}

#sleep 10;

for my $number ( 0 .. 1_000_000 ) {
#    $redis->del( "Default_$number" );
}
