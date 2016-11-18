
use strict;
use warnings;

use Data::Dumper;

$| = 1;

use IO::Select;
use Socket;
use POSIX ":sys_wait_h";

print "started:[$$]\n";

my $socket_name = "/tmp/skank";

my $uaddr = sockaddr_un( $socket_name );
my $proto = getprotobyname( "tcp" );

my ( $Server, $Client );

socket ( $Server, PF_UNIX, SOCK_STREAM, 0 ) or die "Error creating the socket $!";
unlink $socket_name;
bind ( $Server, $uaddr  ) or die "Error when binding $uaddr $!";
listen( $Server, SOMAXCONN ) or die "Can't listen $!";

# TODO reaper

$SIG{ CHLD } = "IGNORE";

my $wait_io = IO::Select->new();
$wait_io->add( $Server );

my $count = 0;
my $not = 0;

while ( 1 ) {
    my $accept;
    my @clients = $wait_io->can_read( 1 );
    for my $client ( @clients ) {
        eval {
            #$accept = accept( $Client, $Server );
            $accept = accept( $Client, $client );
            #$count ++;
            1;
        } or do {
            warn "$@";
        };
        if ( $accept ) {
            my $pid = fork(); # or die;
            if ( ! $pid ) {
                #open(STDIN,  "<&Client")    || die "can't dup client to stdin";
                open(STDOUT, ">&", $Client)    || die "can't dup client to stdout";
                print "[$$]$count-$not Tim maia\n";
                shutdown( $Client, 2 );
                POSIX::_exit(0);
                exit;
            }
        }else{
            $not++;
            print "[$$]-$not\n";
        }
    }
    $count ++;
#    sleep 1;
    next;
}

