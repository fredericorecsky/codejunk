
use strict;
use warnings;

$| = 1;
$SIG{ CHLD } = "IGNORE";

use Socket;
use POSIX;

my $socket_name = "skank";

my $id = 0;

socket( SOCK, PF_UNIX, SOCK_STREAM, 0 ) or die "Socket $!";
connect( SOCK, sockaddr_un( $socket_name ) ) or 
    die "\n\t> Count not connect $id $!\n";

while ( defined ( my $line = <SOCK> )) {
    print "[cc:$$][$id]\t$line";
}

POSIX::_exit(0);
