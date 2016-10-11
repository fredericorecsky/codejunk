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

my %words = ();

for my $part ( @parts ) {
    if ( $part->content_type eq "text/plain" ){
        my @body = split (/\s|,/, $part->body );
        for my $word ( @body ) {
            my $lc_word = lc $word;
             
            $lc_word =~ s/\W/ /g;

            next if ( $lc_word =~ /^\d+?$/ );
            $words{ $lc_word }++;
        }
        #print $part->body;
        print "\t" . $part->content_type . "\n";
    }else{
        print "\t Not text/plain part:" . $part->content_type . "\n";
    }
}

print "\n\n";

print Dumper \%words;
