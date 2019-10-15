#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Data::Dumper;
use Digest::MD5 qw/md5_hex/;
use LWP::UserAgent;
use Mojo::DOM;
use POSIX qw/ :sys_wait_h ceil/;
use URI;
use URI::Split qw/uri_split/;

use open ':std', ':encoding(UTF-8)';

my $max_processes = 50;

my $url = $ARGV[0];

die if not $url;

my $uri = URI->new( $url );
my $domain = $uri->host;
# also remove the www

my @queue = ();
my %all = ();
my %links =  ();
my %skip = ();
my %visited = ();

push @queue, $url;

my $ua = LWP::UserAgent->new( 
    timeout => 3,
);

my %children;

my $report = 101;

while(my $url = pop  @queue ) {
    next if ! $url;
    #next if $url =~ /jpg$/i;
    next if $url eq "#";

    my $digest = md5_hex $url;
    next if ( exists $skip{ $digest } );
    next if ( exists $links{ $digest } );

    if ( $report > 100 ) {
        print "Queue size: " . ( scalar @queue );
        print "  Visited:" . ( scalar keys %visited );
        print "  Skipped:" . ( scalar keys %skip );
        print "  know:" . ( scalar keys %all ) . "\n";
        $report = 0;
    }else{
        $report ++;
    }

    my $pid;
    $pid = fork();
    if ( $pid ) {
        $children{ $pid } = 1;
    } else {
        #print "[$$] Getting $url\n";
        my $response = $ua->get( $url );

        open my $fh, ">:raw", "results/get_$digest";
            print $fh $response->decoded_content;
        close $fh;

        my @append_links = ();
        my @skip_links = ();
  
        if ( $response->is_success ) {
            my $dom = Mojo::DOM->new( $response->decoded_content ); 
            for my $link (  $dom->find( 'a' )->map(attr => 'href')->each ) {
                my $link_domain;
                my $uri = URI->new( $link );
                eval {
                    $link_domain = $uri->host();
                } or do {
                    push @skip_links, $link;
                    #warn "invalid $link\n";
                    next;
                };
                next if ( $link_domain ne $domain );

                push @append_links, $link;
            }
            open my $fh, ">", "append_$$";
                print $fh join "", map{ "append\t$_\n" } @append_links;
                print $fh join "", map{ "skip\t$_\n" } @skip_links;
            close $fh;
        } 

        exit;
    }
    $links{ $digest }++;
    $visited{ $digest } = $url;
    #

    while( scalar keys %children > $max_processes || ( ( ! @queue ) && scalar keys %children  ) ) {
        my $wait_pid = waitpid( -1, WNOHANG );
        if ( $wait_pid ) {
            delete $children{ $wait_pid };
            my $filename = "append_$wait_pid";
            if ( -e $filename ) {
                open my $fh, "<", $filename;
                while( my $line =  <$fh> ) {
                    chomp $line;
                    my ( $type, $link ) = split( "\t", $line );
                    my $link_digest = md5_hex $link;
                    if ( $type eq "append" ) {
                        #$links{ $link_digest } = $link;
                        $all{ $link_digest }++;
                        push @queue, $link;
                        next;
                    }
                    if ( $type eq "skip" ) {
                        $skip{ $link_digest } = $link;
                        next;
                    }
                }
                close $fh;
                unlink $filename;
                # integrate
                #print "out: $filename\n";
            }
        } else {
            sleep 1;
        }
    }
}

open my $fh , ">", "results";
for my $md5 ( keys %visited ) {
    print $fh join "\t", "[$links{ $md5 }]",  $md5, $visited{ $md5 };
}
close $fh;

print "Visited links:\n";
print join "\n", values  %visited;


