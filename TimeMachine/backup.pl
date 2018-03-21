#!/usr/bin/perl

use feature ':5.10';

use Getopt::Long;
use DateTime;
use File::Path;
use Cwd;

my $path = cwd();

my ($host, $user, $dir , $out_dir , $verbose);

GetOptions( "user=s" => \$user,
	    "verbose" => \$verbose,
	    "host=s" => \$host,
	    "dir=s" => \$dir);

my $dt = DateTime->now(); 
my $date = $dt->ymd('_');
$date .= "_". $dt->hms('_');

die "need user, host, and dir\n" unless ($user && $host && $dir);

opendir my $fh , "./$host/";
	my @oldbackups = grep {!/\.{1,2}/} readdir $fh;
closedir $fh;

my @dates;

for (@oldbackups){
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

@dates = sort @dates;

my $last =  $dates[-1]->ymd('_');
$last .= "_" . $dates[-1]->hms('_');

mkpath "./$host/$date";

my $rsync = "rsync -alvC -f \"- *.iso\" --rsh=\"ssh -c blowfish\" --link-dest=$path/$host/$last $user\@$host:$dir ./$host/$date";

my @log = qx/$rsync/;

say @log if $verbose;

