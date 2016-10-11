#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use Email::MIME;

my $filename = $ARGV[0];

open my $fh , "<", $filename or die;

local $/;
my $message = <$fh>;

close $fh;

my $parsed = Email::MIME->new( $message );

my @parts = $parsed->parts;

my %header  = $parsed->header_pairs();

print map { "$_\t$header{ $_ }\n" } qw/To From Subject/;

print "\n\n";

for my $part ( @parts ) {
    if ( $part->content_type eq "text/plain" ){
        #print $part->body;
        print "\t" . $part->content_type . "\n";
    }else{
        print "\t Not text/plain part:" . $part->content_type . "\n";
    }
}

print "\n\n";
