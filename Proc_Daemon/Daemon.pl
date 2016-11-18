
use strict;
use warnings;

use Proc::Daemon;

my $daemon = Proc::Daemon->new(
    work_dir    =>  '/',
    pid_file    =>  '/tmp/useless_machine',
);

my $pid = $daemon->Init();

if ( $pid ) {
    print "Daemon $pid started\n";
    exit;
}

while( 1 ) {
    sleep 1;
    if ( ! -e '/tmp/highlander' ) {
        print "!!!\n";
        open my $fh , ">", '/tmp/highlander';
        close $fh;
    }
}


# if file does not exists, create it

