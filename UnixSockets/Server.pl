
use strict;
use warnings;

$| = 1;

use Socket;
use POSIX ":sys_wait_h";

print "started:[$$]\n";

my $socket_name = "skank";

my $uaddr = sockaddr_un( $socket_name );
my $proto = getprotobyname( "tcp" );

socket ( Server, PF_UNIX, SOCK_STREAM, 0 ) or die "Error creating the socket $!";
unlink $socket_name;
bind ( Server, $uaddr  ) or die "Error when binding $uaddr $!";
listen( Server, SOMAXCONN ) or die "Can't listen $!";

# TODO reaper

$SIG{ CHLD } = "IGNORE";

my $count = 0;
my $not = 0;

while ( 1 ) {
    my $accept;
    eval {
        $accept = accept( Client, Server );
        $count ++;
        1;
    } or do {
        warn "$@";
    };
    if ( $accept ) {
        #print "[$$]+$count\n";
        my $pid = fork(); # or die;
        if ( ! $pid ) {
            #open(STDIN,  "<&Client")    || die "can't dup client to stdin";
            open(STDOUT, ">&Client")    || die "can't dup client to stdout";
            print "[$$]$count-$not Tim maia\n";
            shutdown( Client, 2 );
            POSIX::_exit(0);
            exit;
        }
    }else{
        $not++;
        print "[$$]-$not\n";
    }
}

