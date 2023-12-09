#!/usr/bin/perl -w
use strict;
use Net::FTP;

our $ftp;
$ftp = Net::FTP->new("some.host.name", Debug => 0);
or die "Cannot connect to some.host.name";
$ftp->login("root",'alexandre');
or die "Cannot login ", $ftp->message;
$ftp->cwd("/pub")
or die "Cannot change working directory ", $ftp->message;
$ftp->get("that.file");
or die "get failed ", $ftp->message;
$ftp->quit;

