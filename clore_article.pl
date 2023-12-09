#!/usr/bin/perl -w
use DBI;
use POSIX qw/strftime/;

use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS ();
use Email::Simple ();
use Email::Simple::Creator ();
my $smtpserver = 'smtp.gmail.com';
my %ARTICLE;
my $smtpport = '587';
my $smtpuser   = 'alexjaquet@gmail.com';
my $smtppassword = 'bxwpypgecjwvvthp';

my $transport = Email::Sender::Transport::SMTPS->new({
  host => $smtpserver,
  port => $smtpport,
  ssl => "starttls",
  sasl_username => $smtpuser,
  sasl_password => $smtppassword,
});
    
my  $dir = "/home/alexandre/apache/site/recordz1/log.txt";
my $dbh = DBI->connect( "DBI:mysql:recordz:localhost", "root", "",{ RaiseError => 1, AutoCommit => 1 } );

my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;	
my  $time = sprintf("%4d:%02d",$hour,$min);
$time =~ s/^\s+//; 


 
my ($list) = sqlSelectMany("ref_article,ref_vendeur,prix,article.nom,ref_condition_payement,ref_condition_livraison", "met_en_vente,article"," ref_article = id_article AND enchere_date_fin like '%$date%$time%' and enchere = 1");

while( ($ARTICLE{'ref_article'},$ARTICLE{'ref_vendeur'},$ARTICLE{'price'},$ARTICLE{'nom_article'}, $ARTICLE{'ref_mode_de_payement'},$ARTICLE{'ref_mode_de_livraison'})=$list->fetchrow()) {

    #récupération de l enchère maximum faite ainsi que la référence de l'acheteur
    ($ARTICLE{'ref_acheteur'})= sqlSelect("max(prix), ref_enchereur", "personne,enchere", "id_personne = ref_enchereur AND ref_article = $ARTICLE{'ref_article'}");
    print "test2";
    
    
    #récupération du nom de l'acheteur ainsi que l'email de l'acheteur
    ($ARTICLE{'nom_utilisateur_acheteur'},$ARTICLE{'email_acheteur'})= sqlSelect("nom_utilisateur,email", "personne", "id_personne = '$ARTICLE{'ref_acheteur'}'");
     print "email acheteur  : $ARTICLE{'email_acheteur'}";
    #récupération du nom du vendeur ainsi que l'email du vendeur    
    ($ARTICLE{'nom_utilisateur_vendeur'},$ARTICLE{'email'})= sqlSelect("nom_utilisateur,email", "personne", "id_personne = '$ARTICLE{'ref_vendeur'}'");


    #mise a jour du statut de l article
    sqlUpdate("article", "id_article='$ARTICLE{'ref_article'}'",(ref_statut => '11'));

    
    #send mail to dealer and buyer
    
    my $email = Email::Simple->create(
      header => [
                    To      => "$ARTICLE{'email_acheteur'}",
                    From    => 'robot@avant-garde.no-ip.biz',
                    Subject => 'Vous avez gagné une enchère',
                ],
      body => 'test',);
      sendmail($email, { transport => $transport });

}
#($ARTICLE{'max_enchere'})=sqlSelect("MAX(prix)", "enchere", "ref_article = '$article'");



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
	my  ($c)=$dbh->prepare($sql) or die "Sql has gone to hell\n";
	#print "Content-type: text/html\n\n";
	#print "$sql <br />";
	if(not ($c->execute())) {
		my  $err=$dbh->errstr;
		return undef;
	}
	my  (@r)=$c->fetchrow();
	$c->finish();
	return @r;
}

$dbh->disconnect();
