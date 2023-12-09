#!/usr/bin/perl -w
package CommandeTable;
use MyDB;
use strict;
use SharedVariable qw ($action $session_dir $dir $dirLang $dirError $imgdir $session_id $can_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);  

sub loadCommandIndex {
    my  $client_id = shift || '';

    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  ($c)= sqlSelectMany("id_commande,session_ID,date, date_payement",
			   "commande",
			   "client_ref = $client_id");	
    my  $id_command;	
	while(($id_command)=$c->fetchrow()) {
	    $total +=1;
	}
    my  $nb_page = arrondi ($total / 4, 1);
    my  $min_index = '0';
    my  $max_index = '40';
    
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=mycommand&amp;min_index=$min_index&amp;max_index=$max_index\"  class=\"menulink2\" ><-$i-></a>&#160;&nbsp;";		
	$min_index += 40;
	
    }
	return $string;
    
}

sub loadCommandByIndex {
    my  $index_start = $query->param ("min_index");
    $index_start =~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index");
    $index_end =~ s/[^A-Za-z0-9 ]//;
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;

    my  $client_id = shift || '';
    
    if (!$index_start ) {
	$index_start = 0;
    }
    if (!$index_end ) {
	$index_end = 40;
    }
    
    my  ($c)= sqlSelectMany("id_commande,session_ID,date, date_payement",
		       "commande",
		        "client_ref = $client_id LIMIT $index_start, $index_end");	
    
    my  $string = "<table width=\505\" border=\"0\"><tr bgcolor=\"#DBE4F8\"><td align=\"left\" width=\"51\">$SERVER{'id_commande'}</td><td align=\"left\">$SERVER{'session_ID'}</td><td align=\"left\">$SERVER{'date'}</td><td align=\"left\" width=\"181\">$SERVER{'date_payement'}</td></tr>";
    

    while( ($COMMAND{'id_commande'},$COMMAND{'session_ID'}, $COMMAND{'date'}, $COMMAND{'date_payement'})=$c->fetchrow()) {
	$string .= "<tr><td align=\"left\"><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&amp;action=mycommandetail&amp;commandID=$COMMAND{'id_commande'}\">$COMMAND{'id_commande'}</a></td><td align=\"left\">$COMMAND{'session_ID'}</td><td align=\"left\">$COMMAND{'date'}</td><td align=\"left\">$COMMAND{'date_payement'}</td></tr>";
    }
    $string .="</table>";
    return $string;
    
}

sub loadCommandDetailIndex {
    
    my  $command_id = shift || '';

    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $string = "";
    my  $index = '0';
    my  $total = '0';#ajouter la référence à l'acheteur
    my  ($c)= sqlSelectMany("ref_article",
			   "commande_article",
			   "ref_commande = $command_id");	
    my  $id_command;	
	while(($id_command)=$c->fetchrow()) {
	    $total +=1;
	}
    my  $nb_page = arrondi ($total / 4, 1);
    my  $min_index = '0';
    my  $max_index = '40';
    
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;amp;action=detail_command_article&amp;command=$command_id&amp;min_index=$min_index&amp;max_index=$max_index\"><-$i-></a>&#160;&nbsp;";		
	$min_index += 40;
	
    }
	return $string;
        
}

sub loadCommandDetailByIndex {
    my  $index_start = $query->param ("min_index");
    $index_start=~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index") ;
    $index_end=~ s/[^A-Za-z0-9 ]//;
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;

    my  $command_id = shift || '';
    
    if (!$index_start ) {$index_start = 0;}
    if (!$index_end ) {$index_end = 40;}
    
    my  $string = "<table width=\"305\" border=\"0\"><tr bgcolor=\"#DBE4F8\"><td align=\"left\" width=\"51\">&nbsp;</td><td align=\"left\" width=\"47\">Titre</td><td align=\"left\" width=\"29\">Dj</td><td align=\"left\" width=\"54\">Label</td><td align=\"left\" width=\"90\">CHF en francs suisse</td>";
    my  $amount = ();
    if ($command_id) {
	my  ($c)= sqlSelectMany("nom,marque,label,prix",
			       "article,commande_article,commande",
			       "ref_article = id_article and id_article = id_article AND commande_article.ref_article = id_article AND id_commande = $command_id AND commande_article.ref_commande = id_commande and commande_article.date_payement LIMIT $index_start, $index_end");	
	    while( ($ARTICLE{'name'},$ARTICLE{'author'},$ARTICLE{'label'},$ARTICLE{'price'})=$c->fetchrow()) {
		$string .= "<tr><td align=\"left\"><td align=\"left\">$ARTICLE{'name'}</td><td align=\"left\">$ARTICLE{'author'}</td><td align=\"left\">$ARTICLE{'label'}</td><td align=\"left\">$ARTICLE{'price'}</td></tr>";
		$amount +=$ARTICLE{'price'};	    	    
	    }
	    $string .="</table><br />";
    }else {
	loadPage ();
    }
	return $string;    
    
}


BEGIN {
    use Exporter ();
  
    @Initialize::ISA = qw(Exporter);
    @Initiliaze::EXPORT      = qw(loadCommandDetailByIndex loadCommandDetailIndex loadCommandByIndex loadCommandIndex);
    @Initiliaze::EXPORT_OK   = qw();
}

END

1;