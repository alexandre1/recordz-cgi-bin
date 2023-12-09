#!/usr/bin/perl

use MyDB;
my $db = MyDB->new;

my @o = $db->sqlSelect("pub_date_end","article","id_article = 248");
my  $old_date = $o[0];
print "old date : $old_date";
         
my @n = $db->sqlCalculateDate($old_date);
my  $new_date = $n[0];

print "new date : $new_date";