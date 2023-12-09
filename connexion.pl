#!C:/Strawberry/perl/bin/perl.exe -w
use strict;
use DBI;
my $dbh = DBI->connect( "DBI:mysql:recordz:localhost", "root", "",{ RaiseError => 1, AutoCommit => 1 } );
print "Hello";

sqlCalculateDate("");

sub sqlCalculateDate {
	my $date = shift || '';
	my $sql = "SELECT DATE_ADD('$date',INTERVAL +3 MONTH";
        print "Content-Type: text/html\n\n";
        print "SQL : $sql \n";	
	my  ($c)=$dbh->prepare($sql) or die "Sql has gone to hell\n";
	if(not ($c->execute())) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                my  $err=$dbh->errstr;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                return undef;   
	}
	my  (@r)=$c->fetchrow();
    print "sql : $sql\n";
	return @r;
}   