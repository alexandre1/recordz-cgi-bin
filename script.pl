#!/usr/bin/perl -w
use DBI;
use POSIX qw/strftime/;
use MIME::Lite;

my %ARTICLE;
    
my  $dir = "/home/alexandre/apache/site/recordz1/log.txt";
my $dbh = DBI->connect( "DBI:mysql:recordz:localhost", "root", "alexandre",{ RaiseError => 1, AutoCommit => 1 } );

my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;	
my  $time = sprintf("%4d:%02d",$hour,$min);
$time =~ s/^\s+//; 

open my $FH, '+>>', "$dir" or die "Couldn't open file: $!";
 
my ($list) = sqlSelectMany("ref_article,ref_vendeur,prix,article.nom,ref_mode_de_payement,ref_mode_de_livraison", "met_en_vente,article"," ref_article = id_article AND enchere_date_fin like '%$date%$time%' and is_enchere = 1");

while( ($ARTICLE{'ref_article'},$ARTICLE{'ref_vendeur'},$ARTICLE{'price'},$ARTICLE{'nom_article'}, $ARTICLE{'ref_mode_de_payement'},$ARTICLE{'ref_mode_de_livraison'})=$list->fetchrow()) {

    #récupération de l enchère maximum faite ainsi que la référence de l'acheteur
    ($ARTICLE{'max_enchere'},$ARTICLE{'id_enchere'})=sqlSelect("MAX(prix),id_enchere", "enchere", "ref_article = '$ARTICLE{'ref_article'}'");
    ($ARTICLE{'ref_enchereur'})=sqlSelect("ref_enchereur", "enchere", "ref_article = '$ARTICLE{'ref_article'}' AND prix = '$ARTICLE{'max_enchere'}'");    
    
    #récupération du nom de l'acheteur ainsi que l'email de l'acheteur
    ($ARTICLE{'nom_utilisateur_acheteur'},$ARTICLE{'email_acheteur'})= sqlSelect("nom_utilisateur,email", "personne", "id_personne = '$ARTICLE{'ref_enchereur'}'");
    
    #récupération du nom du vendeur ainsi que l'email du vendeur    
    ($ARTICLE{'nom_utilisateur_vendeur'},$ARTICLE{'email'})= sqlSelect("nom_utilisateur,email", "personne", "id_personne = '$ARTICLE{'ref_vendeur'}'");


    #mise a jour du statut de l article
    sqlUpdate("article", "id_article='$ARTICLE{'ref_article'}'",(ref_statut => '5'));
    sqlUpdate("a_paye", "id_article='$ARTICLE{'ref_article'}'",(ref_statut => '8',
								montant =>     $ARTICLE{'max_enchere'},
								ref_acheteur => $ARTICLE{'ref_enchereur'},
								ref_vendeur => $ARTICLE{'ref_vendeur'},
								ref_mode_de_payement => $ARTICLE{'ref_mode_de_payement'},
								ref_mode_de_livraison => $ARTICLE{'ref_mode_livraison'},
								ref_article => $ARTICLE{'ref_article'},
								ref_enchere => $ARTICLE{'id_enchere'},
								date_fermeture_enchere => "$date $time"
)); 
    
    #send mail to dealer and buyer
    my  $Message = new MIME::Lite From =>'robot@djmarketplace.biz',
    To =>$ARTICLE{'email'}, Subject =>"Article vendu" ,
    Type =>'TEXT',
    Data =>"Article : $ARTICLE{'ref_article'} <br/> $ARTICLE{'nom_article'} <br/> CHF de base : $ARTICLE{'price'} <br/> Vendu pour le prix de : $ARTICLE{'max_enchere'}";       
    $Message->attr("content-type" => "text/html; charset=iso-8859-1");
    $Message->send_by_smtp('localhost:2525');
    
    $Message = new MIME::Lite From =>'robot@djmarketplace.biz',
    To =>$ARTICLE{'email_acheteur'}, Subject =>"Article acheté" ,
    Type =>'TEXT',
    Data =>"Article : $ARTICLE{'ref_article'} <br/> $ARTICLE{'nom_article'} <br/> CHF de base : $ARTICLE{'price'} <br/> Vendu pour le prix de : $ARTICLE{'max_enchere'}";       
    $Message->attr("content-type" => "text/html; charset=iso-8859-1");
    $Message->send_by_smtp('localhost:2525');    
}
#($ARTICLE{'max_enchere'})=sqlSelect("MAX(prix)", "enchere", "ref_article = '$article'");
close $FH;

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
