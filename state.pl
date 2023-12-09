#!C:/Strawberry/perl/bin/perl.exe -w
use CGI;
use DBI;
use DBD::mysql;
use JSON;
# print the http header specifically for json
print "Content-type: application/json; charset=iso-8859-1\n\n";

# your database variables
my $database = "recordz";
my $host = "localhost";#$dbh = DBI->connect( "DBI:mysql:recordz:localhost", "root", "",{ RaiseError => 1, AutoCommit => 1 } );
my $port = "3306";
my $tablename = "states";
my $user = "root";
my $pass = "root_password";
my $cgi = CGI->new();
my $term = $cgi->param('term');

# mysql connection information
$dsn = "dbi:mysql:$database:$host:$port";

# open the database connection
$connect = DBI->connect( "DBI:mysql:recordz:localhost", "root", "",{ RaiseError => 1, AutoCommit => 1 } );

# prepare the query
$query = $connect->prepare(qq{select id, state AS value, abbrev FROM states where state like ?;});

# execute the query
$query->execute('%'.$term.'%');

# obtain the results
while ( my $row = $query->fetchrow_hashref ){
    print "ITEM : $row";
push @query_output, $row;
}

# close the database connection
$connect->disconnect();

# print the json output to be returned to the HTML page
print JSON::to_json(\@query_output);