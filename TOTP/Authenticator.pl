
use strict;
use warnings;

use Convert::Base32 qw( decode_base32 );
use Authen::OATH;

my $oath = Authen::OATH->new;
my $secret = $ARGV[0];
my $otp = $oath->totp( decode_base32( $secret ) );
print "$otp\n";
