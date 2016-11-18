
use strict;
use warnings;

use Data::Dumper;

use IO::Socket::UNIX;

$SIG{ CHLD } = "IGNORE";

my $id;
for my $seq ( 0 .. 500_000 ) {
    my $pid = fork();
    if ( ! $pid ) {
        $id = $seq;
        last;
    }
}

my $client = IO::Socket::UNIX->new(
    TYPE    => SOCK_STREAM,
    Peer    => "/tmp/skank",
);

die "$!" unless $client;

my  $line = <$client>;

print "<$id>$line\n";

exit;
