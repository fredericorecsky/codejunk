#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use autodie;
use Cwd;
use DateTime;
use File::Path;
use File::Slurp;
use Getopt::Long;
use JSON;

my $config;
my $configfile;

GetOptions( "config=s" => \$configfile );

die if ! $configfile;

my $file = read_file( $configfile );

$config = decode_json $file;

backup( $config );

sub backup {

    my ( $config ) = @_;

    my $dt = DateTime->now();
    my $date = $dt->ymd('_');
    $date .= "_". $dt->hms('_');

    my $path = cwd();

    if ( ! -e "./$config->{ host }" ){
        mkpath $config->{ host };
    }

    opendir my $fh , "./$config->{ host }/";
        my @oldbackups = grep {!/\.{1,2}/} readdir $fh;
    closedir $fh;

    my @dates;

    for ( @oldbackups ){
        my ($y,$m,$d,$h,$mi,$s) = split(/_/);

        my $dt = DateTime->new( year   => $y,
                           month  => $m,
                           day    => $d,
                           hour   => $h,
                           minute => $mi,
                           second => $s,
                         );
        push @dates, $dt;
    }

    my $last;
    if( @dates ) {
        @dates = sort @dates;
        $last =  $dates[-1]->ymd('_');
        $last .= "_" . $dates[-1]->hms('_');
    }


    my $destiny = "./$config->{ host }/$date";
    mkpath $destiny;

    for my $dir ( @{ $config->{ dirs } } ){
        my $rsync = "rsync -alvC -f \"- *.iso\" --rsh=\"ssh -c blowfish\" --link-dest=$path/$config->{ host }/$last $config->{ user }\@$config->{ host }:$dir $destiny";
        my @log = qx/$rsync/;
        print  @log;
    }


}

__END__
#rsync -alvC -f "- *.iso" --rsh="ssh -c blowfish" user@127.0.0.1:/home/user .

