
use strict;
use warnings;

use POSIX;

mkfifo( "./test", 0700 );

my $count = 0;
while ( 1 ) {

    open my $fifo, ">", "./test";
        print $fifo $count . "\n";
    close $fifo;

    $count ++;
    sleep 1;
}
