
use strict;
use warnings;

use MIME::Lite;
                
my $msg = MIME::Lite->new(
    From    => "",
    To      => "",
    Subject => "test",
    Type    => "TEXT",
    Data    => "Boo",
);
$msg->send();
