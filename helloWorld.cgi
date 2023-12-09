#!/usr/bin/perl -w

use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;

my $coinbaseURL = 'https://api.coindesk.com/v1/bpi/currentprice/usd.json';
my $value = $ua->get( $coinbaseURL )->result->json->{bpi}{USD}{rate};

print "Content-Type: text/html\n\n"; 
print "Bitcoin Price (USD): $value";
