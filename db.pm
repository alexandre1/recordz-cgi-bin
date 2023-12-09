#!/usr/bin/perl -w
package MyDB;
use strict;
use DBI;
use SharedVariable qw ($action $dir $dirLang $dirError $imgdir $session_dir  $session_id $can_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);

our $dbh = DBI->connect( "DBI:mysql:recordz:localhost", "root", "alexandre",{ RaiseError => 1, AutoCommit => 1 } );

sub new {
        my $class = shift;
        my ($opts)= @_;
	my $self = {};
	return bless $self, $class;
}

sub sqlConnect {
	my  $dbname = shift || '';
	my  $dbusername = shift || '';
	my  $dbpassword = shift || '';

	$dbh = DBI->connect($dbname, $dbusername, $dbpassword);
	if (!$dbh) {
	}
	kill 9, $$ unless $dbh;
}

sub sqlSelect {
	my  $select = shift || '';
	my  $from = shift || '';
	my  $where = shift || '';
	my  $other = shift || '';


	my  $sql="SELECT $select ";
	$sql.="FROM $from " if $from;
	$sql.="WHERE $where " if $where;
	$sql.="$other" if $other;
	#$sql = $dbh->quote ($sql);
	#print "Content-Type: text/html\n\n";
	#print "sql : $sql\n";
	my  ($c)=$dbh->prepare($sql) or die "Sql has gone to hell\n";

	if(not ($c->execute())) {
		my  $err=$dbh->errstr;
		return undef;
	}
	my  (@r)=$c->fetchrow();
	$c->finish();
	return @r;
}

sub sqlInsert {
	my ($table,%data)=@_;

	my ($names,$values);
	$dbh||=sqlConnect();
	foreach (keys %data) {
		if (/^-/) {$values.="\n  ".$data{$_}.","; s/^-//;}
		else { $values.="\n  ".$dbh->quote($data{$_}).","; }
		$names.="$_,";
	}

	chop($names);
	chop($values);

	my  $sql="INSERT INTO $table ($names) VALUES($values)\n";
	#$sql = $dbh->quote ($sql);
	#print "Content-Type: text/html\n\n";
	#print "$sql <br />";

	if(!$dbh->do($sql)) {
		my  $err=$dbh->errstr;
	}
}

sub sqlUpdate {
	my ($table, $where, %data)=@_;

	my  $sql="UPDATE $table SET";

	foreach (keys %data) {
		if (/^-/) {
			s/^-//;
			$sql.="  $_ = $data{-$_} " . ",";
		} else {
			$sql.="  $_ = ".$dbh->quote($data{$_}).",";
		}
	}
	chop($sql);	
	$sql.=" WHERE $where ";
#	$sql = $dbh->quote ($sql);
#	print "Content-Type: text/html\n\n";
#	print "$sql";
	if(!$dbh->do($sql)) {
	    my  $err=$dbh->errstr;
	}
}

sub sqlSelectMany {
	my  $select = shift || '';
	my  $from = shift || '';
	my  $where = shift || '';
	my  $other = shift || '';

	my  $sql="SELECT $select ";
	$sql.="FROM $from " if $from;
	$sql.="WHERE $where " if $where;
	$sql.="$other" if $other;
	#print "Content-Type: text/html\n\n";
	#print "$sql";
	#$sql = $dbh->quote ($sql);
	my  $c=$dbh->prepare($sql);

	if($c->execute()) {
		return $c;
	} else {
		$c->finish();
		my  $err=$dbh->errstr;
		return undef;
		kill 9,$$
	}
}

sub sqlDelete {
	my  $fromtable = shift || '';
	my  $condition = shift || '';

	my  $sql = '';
	if ($condition) {
		$sql = "DELETE from $fromtable WHERE $condition";
	} else {
		$sql = "DELETE from $fromtable";
	}
	#print "Content-Type: text/html\n\n";
	#print "$sql";
	#$sql = $dbh->quote ($sql);	
	if (!$dbh->do($sql)) {
		my  $err=$dbh->errstr;
	}
}

BEGIN {
    use Exporter ();
  
    @DB::ISA = qw(Exporter);
    @DB::EXPORT      = qw();
    @DB::EXPORT_OK   = qw(new sqlConnect sqlSelect sqlInsert sqlUpdate sqlSelectMany sqlDelete);
}
1;