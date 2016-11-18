
use strict;
use warnings;

use Data::Dumper;

use IO::Select;
use IO::Socket::UNIX;
use POSIX ":sys_wait_h";

$SIG{ CHLD } = "IGNORE";

my $socket = IO::Socket::UNIX->new(
    Local   => '/tmp/skank',
    Type    => SOCK_STREAM,
    Listen  => SOMAXCONN,
);

die "$!" unless $socket;

my $wait_io = IO::Select->new();
$wait_io->add( $socket );

my $count;

while( 1 ) {
    my $accept;
    my @clients = $wait_io->can_read( 1 );
    for my $client ( @clients ){
        eval {
            $accept = $socket->accept();
            1;
        } or do {
            warn "$@";
        };
        
        if ( $accept ){
            my $pid = fork();
            if ( ! $pid ) {
                print $accept "[$$][$count] -> Catra\n";
                POSIX::_exit(0);
            }
        }
    }
    $count++;
}



