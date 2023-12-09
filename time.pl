#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use Time::HiRes qw(gettimeofday);

my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+2,$mday;
my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);

print " DATE : $date TIME : $time";