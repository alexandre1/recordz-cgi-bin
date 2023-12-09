#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use CGI;
use Time::HiRes qw(gettimeofday);
use Article;
use DBI;
use MyDB;
use LoadProperties;
use ImageManipulation;

use vars qw (%ENV $session_dir $can_do_gzip $cookie $page $dir $dirLang $dirError $imgdir $action $t0 $session_id $ycan_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);
$query = CGI->new ;
$cookie = "";
$current_ip = $ENV{'REMOTE_ADDR'};
$client = $ENV{'HTTP_USER_AGENT'};
$t0 = gettimeofday();
$host = "http://127.0.0.1";
%ERROR = ();%LABEL = ();$LANG = "";%LINK = ();%ARTICLE = ();%SESSION = ();
my %SERVER = ();
my $the_key = "otherbla";
$action = $query->param('action');
$page = $query->param("page");
$session_id  =  $query->param('session');
$can_do_gzip = ($ENV{'HTTP_ACCEPT_ENCODING'} =~ /gzip/i) ? 1 : 0;
$dir = "C:/Users/41786/OneDrive/Documents/recordz1/";
$dirLang = "C:/Users/41786/OneDrive/Documents/recordz1/lang";
$dirError = "C:/Users/41786/OneDrive/Documents/recordz1/lang";
$imgdir=  "C:/Users/41786/OneDrive/Documents/recordz1/upload";
$session_dir = "C:/Users/41786/OneDrive/Documents/recordz1/sessions";
$action = $query->param('action');
$session_id = $query->param('session');

my $dsn = "DBI:mysql:recordz";
my $username = "root";
my $password = '';
my $mydb = MyDB->new;
my $query = CGI->new ;
my $tableArticle = TableArticle->new;
my $articleClass = Article->createArticle();
my $imageManipulation = ImageManipulation->new;
my $userAction;
my $lang;
my $db = MyDB->new();
my $lp = LoadProperties->create();
loadLanguage();
loadError();
loadMyEnchereDeal();

sub loadMyEnchereDeal {
	$lang = $query->param("lang");
	loadLanguage();
	my $menu = $lp->loadMenu();
	my $article = $query->param("article");
	my $option = $query->param("option");
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );
	my $username = $query->param("u");
	
	my $encrypt =  &string2hex(&RC4($decypted,$the_key));
	$cookie_in = $query->cookie("USERNAME"); 
	my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
	
	
	if($decrypted) 
	{ 
#	if ($decrypted) {                          
	    my $table_index_invendu;
	    my $table_invendu;
	    my $cats = getCat();
	    my $invendu_counter = $articleClass->getInvenduCounter ($decrypted);
	    my $current_deal_counter = $articleClass->getMyCurrentDealCounter($decrypted);	
	    my $buy_waiting_counter = $articleClass->getBuyWaitingCounter($decrypted);
	    my $buy_current = $articleClass->getMyCurrentBuyCounter($decrypted);
	    my $table_index_todeliver;
	    my $table_todeliver;
	    my $todeliver_counter = $articleClass->getToDeliverCounter ($decrypted);
	    my $effected_counter = $articleClass->getToEffectedCounter($decrypted);
	    my $soulevement_counter = $articleClass->getSoulevementCounter($decrypted);
		my $soulevement_a_aller_chercher_counter = $articleClass->getSoulevementAllerChercherCounter($decrypted);
	    my $deliver_waiting_counter = $articleClass->getDeliverWaitingCounter($decrypted);
	    my $table_index_current_deal;
	    my $table_current_deal;
	    my $table_buy_waiting;
	    my $table_index_buy_waiting;
	    my $table_effect;
	    my $table_index_effect;
	    my $table_index_soulevement;
	    my $table_soulevement;
	    my $counterMyBuyToBuy;
	    my $tableCounterMyBuyToBuy;
	    my $tableIndexCounterMyBuyToBuy;
	    my $tableIndexWaitDelivering;
	    my $tableWaitDelivering;
	    my $tableBuyIndex;
	    my $tableBuy;
	    my $deal_passed_index;
	    my $deal_passed_table;
	    my %IMG = ();
	    my %SELECT = ();
	    
	    my $type_article = $query->param("category");
	    my $brand = $query->param("brand");
	    $counterMyBuyToBuy = $articleClass->loadCounterMyBuyToBuy($decrypted);
	    if ($option eq 'mynotdeal') {
		    $table_index_invendu = $tableArticle->loadTableIndexInvendu($decrypted);
		    $table_invendu= $tableArticle->loadTableByIndexInvendu($decrypted);
							     
	    }elsif ($option eq 'mybuytodeliver') {
		    $table_index_todeliver = $tableArticle->loadTableIndexToDeliver($decrypted);
		    $table_todeliver = $tableArticle->loadTableByIndexToDeliver($decrypted);
	    }elsif ($option eq 'mybuysoulevement') {
		    $table_index_soulevement = $tableArticle->loadTableIndexSoulevement($decrypted);
		    $table_soulevement = $tableArticle->loadTableByIndexSoulevement($decrypted);
    
		}elsif ($option eq 'mybuysoulevement_a_aller_chercher') {
		    $table_index_soulevement = $tableArticle->loadTableIndexSoulevementAllerChercher($decrypted);
		    $table_soulevement = $tableArticle->loadTableByIndexSoulevementAllerChercher($decrypted);
	    }elsif ($option eq 'mycurrentdeal') {
		    $table_index_current_deal = $tableArticle->loadTableIndexCurrentDeal($decrypted);
		    $table_current_deal = $tableArticle->loadTableByIndexCurrentDeal($decrypted);
	    }elsif ($option eq 'mybuywaiting') {
		    $table_index_buy_waiting = $tableArticle->loadTableIndexMyBuyWaiting($decrypted);
		    $table_buy_waiting = $tableArticle->loadTableByIndexMyBuyWaiting($decrypted);
	    }elsif ($option eq 'mybuyeffect') {
		    $table_effect = $tableArticle->loadTableByIndexEffect ($decrypted);
		    $table_index_effect =  $tableArticle->loadIndexEffect ($decrypted);
	    }elsif ($option eq 'mybuytobuy') {		
		    $tableIndexCounterMyBuyToBuy = $tableArticle->loadCounterMyBuyTable($decrypted);
		    $tableCounterMyBuyToBuy = $tableArticle->loadMyBuyToBuyTable($decrypted);
	    }elsif ($option eq 'mywaitdelivering') {
		    $tableIndexWaitDelivering = $tableArticle->loadIndexWaitDeliver($decrypted);
		    $tableWaitDelivering = $tableArticle->loadTableWaitDeliver($decrypted);
	    }elsif ($option eq 'mycurrentbuy') {
		    $tableBuyIndex = $articleClass->loadTableIndexMyBuy($decrypted);
		    $tableBuy = $articleClass->loadTableByIndexMyBuy($decrypted);		    
	    }elsif ($option eq "mydealpassed") {
		    $deal_passed_index = $articleClass->showMyDealPassedIndex($decrypted);
		    $deal_passed_table = $articleClass->showMyDealPassedTable($decrypted);
    	    
	    }elsif ($option eq 'statdealarticlebrand') {
		    my ($c) = $db->sqlSelectMany("libelle.libelle","categorie_libelle_langue,libelle,langue", "categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue  = langue.id_langue AND langue.key = '$lang'");
		    $SELECT{'type_article'} = "<td>$SERVER{'type_article'}</td><td><select name=\"category\" onchange=\"go();\">";
		    my  %OPTIONS = ();
		    my $selected = $query->param("category");
		    $SELECT{'type_article'} .= "<option selected VALUE=\"$selected\">$selected</option>";
		    while(($OPTIONS{'category'})=$c->fetchrow()) {	
		         $SELECT{'type_article'} .= "<option value=\"/cgi-bin/my_auctions.pl?lang=$lang&amp;page=myencheredeal&session=$session_id&option=statdealarticlebrand&u=$username&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
		    }
		    $SELECT{'type_article'} .= "</select></td>";
		    ($c) = $db->sqlSelectMany("DISTINCT article.marque","article,personne,categorie_libelle_langue, met_en_vente", "personne.nom_utilisateur = '$decrypted' and met_en_vente.ref_vendeur = personne.id_personne AND met_en_vente.ref_article = article.id_article AND article.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue,libelle,langue WHERE libelle.libelle = '$selected' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle and categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
		    %OPTIONS = ();
		    my $category = $query->param("category");
		    $selected = $query->param("brand");
		    $SELECT{'brand'} = "<td>$SERVER{'type_article'}</td><td><select name=\"brand\" onchange=\"go2();\">";
		    $SELECT{'brand'} .= "<option selected VALUE=\"$selected\">$selected</option>";
		    while(($OPTIONS{'category'})=$c->fetchrow()) {	
		         $SELECT{'brand'} .= "<option value=\"/cgi-bin/my_auctions.pl?lang=$lang&amp;page=myencheredeal&sesasion=$session_id&option=statdealarticlebrand&u=$username&category=$category&brand=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
		    }
		    $SELECT{'brand'} .= "</select>";
		     
		    $IMG{'statistiques_brand'} = generateGraphicStatArticleBrand($brand, $decrypted);
	    } elsif ($option eq 'statdealarticleville') {
		    my ($c) = $db->sqlSelectMany("nom","canton_fr", "id_canton = id_canton");
		    $SELECT{'canton'} .= "<td>$SERVER{'type_article'}</td><td><select name=\"canton\" onchange=\"go3();\">";
		    my  %OPTIONS = ();
		    my $selected = $query->param("canton");
		    $SELECT{'canton'} .= "<option selected VALUE=\"$selected\">$selected</option>";
		    while(($OPTIONS{'category'})=$c->fetchrow()) {	
		         $SELECT{'canton'} .= "<option value=\"/cgi-bin/my_auctions.pl?lang=$lang&amp;page=myencheredeal&session=$session_id&option=statdealarticleville&u=$username&canton=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
		    }
		$SELECT{'canton'} .= "</select>";
		if ($selected) {
		    $IMG{'statistiques_canton'} = generateGraphicStatArticleCanton($selected, $decrypted);
		}
		
		
	    }
	    my ($counter_deal_passed) = $db->sqlSelect("count(*)","article,met_en_vente,a_paye,personne", "met_en_vente.ref_article = id_article and met_en_vente.ref_vendeur = id_personne and nom_utilisateur = '$decrypted' and a_paye.ref_article = id_article and a_paye.ref_statut = '7'");

	    my $categoriesTosearch = $lp->loadCategories();
	    open (FILE, "<$dir/myencheredeal.html") or die "cannot open file $dir/myencheredeal.html";
	    my $content;
	    while (<FILE>) {	
		s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
		s/\$LANG/$lang/g;
		s/\$ARTICLE{'current_deal_counter'}/$current_deal_counter/g;
		s/\$ARTICLE{'buy_waiting_counter'}/$buy_waiting_counter/g;
		s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;		
		s/\$ERROR{'([\w]+)'}//g;
		s/\$ARTICLE{'id_article'}/$article/g;
		s/\$ARTICLE{'search'}//g;
		s/\$ARTICLE{'soulevement_counter'}/$soulevement_counter/g;
		s/\$ARTICLE{'soulevement_a_aller_chercher_counter'}/$soulevement_a_aller_chercher_counter/g;
		
		s/\$ARTICLE{'mybuyeffect_counter'}/$effected_counter/g;
		s/\$ARTICLE{'table_index_current_deal'}/$table_index_current_deal/g;
		s/\$ARTICLE{'table_current_deal'}/$table_current_deal/g;
		s/\$ARTICLE{'table_index_buywaiting'}/$table_index_buy_waiting/g;
		s/\$ARTICLE{'table_buywaiting'}/$table_buy_waiting/g;
		s/\$OPTIONS{'categories'}/$cats/g;
		s/\$ARTICLE{'invendu_counter'}/$invendu_counter/g;
		s/\$ARTICLE{'main_menu'}/$menu/g;
		s/\$ARTICLE{'table_index_deliver_waiting'}/$tableIndexWaitDelivering/g;;
		s/\$ARTICLE{'table_deliver_waiting'}/$tableWaitDelivering/g;
		s/\$ARTICLE{'todeliver_counter'}/$todeliver_counter/g;
		s/\$ARTICLE{'table_index_todeliver'}/$table_index_todeliver/g;
		s/\$ARTICLE{'mydeal_passed_index'}/$deal_passed_index/g;
		s/\$ARTICLE{'mydeal_passed_table'}/$deal_passed_table/g;
		s/\$ARTICLE{'table_todeliver'}/$table_todeliver/g;
		s/\$ARTICLE{'table_index_effect'}/$table_index_effect/g;
		s/\$ARTICLE{'table_effect'}/$table_effect/g;
		s/\$ARTICLE{'table_index_soulevement'}/$table_index_soulevement/g;
		s/\$ARTICLE{'table_soulevement'}/$table_soulevement/g;	    
		s/\$LINK{'admin'}/$LINK{'admin'}/g;
		s/\$ARTICLE{'deliver_counter'}/$deliver_waiting_counter/g;
		s/\$ARTICLE{'table_index_invendu'}/$table_index_invendu/g;
		s/\$ARTICLE{'table_invendu'}/$table_invendu/g;
		s/\$ARTICLE{'buy_counter'}/$counterMyBuyToBuy/g;
		
		s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
		s/\$ARTICLE{'mybuytobuyindex'}/$tableIndexCounterMyBuyToBuy/g;
	        s/\$ARTICLE{'mybuytobuytable'}/$tableCounterMyBuyToBuy/g;
		s/\$ARTICLE{'current_buy_counter'}/$buy_current/g;
		s/\$u/$username/g;
		s/\$ARTICLE{'my_deal_passed_counter'}/$counter_deal_passed/g;
		s/\$ARTICLE{'mybuyindex'}/$tableBuyIndex/g;
		s/\$ARTICLE{'mybuy_table'}/$tableBuy/g;
		s/\$SELECT{'type_article'}/$SELECT{'type_article'}/g;
		s/\$SELECT{'brand'}/$SELECT{'brand'}/g;
		s/\$SELECT{'canton'}/$SELECT{'canton'}/g;
		s/\$IMG{'statistiques_brand'}/$IMG{'statistiques_brand'}/g;
		s/\$IMG{'statistiques_canton'}/$IMG{'statistiques_canton'}/g;
		s/\$SESSIONID/$session_id/g;
		$content .= $_;	
	    }
	

	    print "Content-Type: text/html\n\n"; 
	    print $content;
	    close (FILE);
	}else {
		loadLogin();
	}
}
sub generateGraphicStatArticleCanton {
        
	my $brand = shift || '';
	my $username = shift || '';
	my $nbr;
	my $nbr2;
	my @array = ();
	my @array2= ();
	my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
        my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
	
	my @xLabels  = qw(Jan  Fév Mar Avr Mai Jui Jui Aou Sep Oct Nov Dec);	
	#SUM
	my $j;
	for (my $i = 1; $i < 13;$i++) {
	    if ($i eq '1' or $i eq '2' or $i eq '3' or $i eq '4' or $i eq '5' or $i eq '6' or $i eq '7' or $i eq '8' or $i eq '9') {
		$j = "0" .$i;
	    }else {
		$j = $i;
	    }
	    my %OPTIONS = ();
	    my $total;
	    my ($ref_canton) = $mydb->sqlSelect("id_canton","canton_fr", "nom = '$brand'");
	    my ($c) = $mydb->sqlSelectMany("distinct (id_a_paye)", "personne,article,a_paye,met_en_vente","nom_utilisateur = '$username' AND met_en_vente.ref_vendeur = id_personne  and a_paye.ref_article = article.id_article and a_paye.ref_canton = $ref_canton and a_paye.date_payement LIKE '%-$j-%'");
	    while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$total = $total + 1;
	    }
	    ($ARTICLE{'eval_count'}) = $total;
	    
             $array[ $i -1 ] = $ARTICLE{'eval_count'};
	}
	my @data = ( \@xLabels,\@array );
	
	my $graph = GD::Graph::bars->new(500, 300);
	$graph->set( title   => "$brand",
		     y_label => "Quantity");
	$graph->set_legend( "$brand)",
			    "$brand");
	my $gd = $graph->plot(\@data);
	binmode STDOUT;
	
	open(GRAPH,">C:/Users/41786/OneDrive/Documents/recordz1/upload/$username._evalcanton.jpg") || die "Cannot open /home/alexandre/apache/site/recordz1/upload/$username._evalcanton.jpg : $!\n";
	binmode GRAPH;
	print GRAPH $graph->gd->jpeg(100);
	close(GRAPH);
	return "<img alt=\"\" src=\"../upload/$username._evalcanton.jpg\">";	
}


sub loadLogin {
	open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	
	my $categoriesTosearch = $lp->loadCategories();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$c/$encrypted/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
	#print "client :" .$client;
        close (FILE);
}


sub RC4 {
 my($message,$key) = @_;
 my($RC4);
 my(@asciiary);
 my(@keyary);
 my($index,$jump,$temp,$y,$t,$x,$keylen);
 $keylen = length($key);
 for ($index = 0; $index <= 255; $index++) {
  $keyary[$index] = ord(substr($key, ($index%$keylen) + 1, 1));
 }
 for ($index = 0; $index <= 255; $index++) {$asciiary[$index] = $index;}
 $jump = 0;
 for ($index = 0; $index <= 255; $index++) {
  $jump = ($jump + $asciiary[$index] + $keyary[$index])%256;
  $temp = $asciiary[$index];
  $asciiary[$index] = $asciiary[$jump];
  $asciiary[$jump] = $temp;
 }
 $index = 0;
 $jump = 0;
 for ($x = 0; $x < length($message); $x++) {
  $index = ($index + 1)%256;
  $jump = ($jump + $asciiary[$index])%256;
  $t = ($asciiary[$index] + $asciiary[$jump])%256;
  $temp = $asciiary[$index];
  $asciiary[$index] = $asciiary[$jump];
  $asciiary[$jump] = $temp;
  $y = $asciiary[$t];
  $RC4 .= chr(ord(substr($message, $x, 1))^$y);
 }
 return($RC4);
}

sub loadError {
    if (defined $query) { 
		$lang = lc ($query->param('lang'));
		open (FILE, "<$dirError/$lang.error.conf") or die "cannot open file $dirError/$lang.error.conf";    
		while (<FILE>) {
			(my  $label, my  $value) = split(/=/);
			$SERVER{$label} = $value;	
		}
		close (FILE);
		}
}

sub _untaint { # This doesn't make things safe. It just removes the taint flag. Use wisely.
   my ($value) = @_;
   my ($untainted_value) = $value =~ m/^(.*)$/s;
   return $untainted_value;
}

sub loadLanguage {
	if (defined $query) { 
		$lang = $query->param("lang");
		$lang = uc ($lang);
		open (FILE, "<$dirLang/$lang.conf") or die "cannot open file $dirLang/$lang.conf";    
		
		while (<FILE>) {
		(my  $label, my  $value) = split(/=/);
		$SERVER{$label} = $value;
		}
		close (FILE);
	}
}

sub loadCategories {
    my $string;
    my  %OPTIONS = ();
    my  ($c)= $mydb->sqlSelectMany("libelle.libelle","categorie_libelle_langue,libelle, langue","categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");	
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
    }

    return $string;
}

sub loadMenu {
	my $string = "";
	$string .=  "<li><a href=\"/cgi-bin/a.pl?lang=$lang&amp;page=art_design\" class=\"menulink\" >$SERVER{'art'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/b.pl?lang=$lang&amp;page=parfum\" class=\"menulink\" >$SERVER{'parfum_cosmetik'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/c.pl?lang=$lang&amp;page=wear_news\" class=\"menulink\" >$SERVER{'fashion'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=lingerie\" class=\"menulink\" >$SERVER{'lingerie'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=baby\" class=\"menulink\" >$SERVER{'baby'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=animal\" class=\"menulink\" >$SERVER{'animal'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=watch\" class=\"menulink\" >$SERVER{'watch_jewels'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=jardin\" class=\"menulink\" >$SERVER{'Habitat_et_jardin'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=auto\" class=\"menulink\" >$SERVER{'car'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=moto\" class=\"menulink\" >$SERVER{'moto'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=immo\" class=\"menulink\" >$SERVER{'real_estate'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=cd_vinyl_mixtap\" class=\"menulink\" >$SERVER{'cd_music'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=intruments\" class=\"menulink\" >$SERVER{'music_instrument'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=collection\" class=\"menulink\" >$SERVER{'collections'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wine\" class=\"menulink\" >$SERVER{'wine'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=boat\" class=\"menulink\" >$SERVER{'boat'}</a></li>";		
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=tv_video\" class=\"menulink\" >$SERVER{'tv_video_camera'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games\" class=\"menulink\" >$SERVER{'games'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=book\" class=\"menulink\" >$SERVER{'book'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=dvd\" class=\"menulink\" >$SERVER{'dvd_k7'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=sport\" class=\"menulink\" >$SERVER{'sport'}</a></li>";
	return $string;
}

sub arrondi {
     my  $n = shift;
     $n = int($n + 0.5);
     if ($n < 1) {
	$n = 1;
     }
     
     return $n;
}


sub string2hex {
 my($instring) = @_;
 my($retval,$strlen,$posx,$tval,$h1,$h2);
 my(@hexvals) = ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
 $strlen = length($instring);
 for ($posx = 0; $posx < $strlen; $posx++) {
  $tval = ord(substr($instring,$posx,1));
  $h1 = int($tval/16);
  $h2 = int($tval - ($h1*16));
  $retval .= $hexvals[$h1] . $hexvals[$h2];
 }
 return($retval);
}

sub RC4 {
 my($message,$key) = @_;
 my($RC4);
 my(@asciiary);
 my(@keyary);
 my($index,$jump,$temp,$y,$t,$x,$keylen);
 $keylen = length($key);
 for ($index = 0; $index <= 255; $index++) {
  $keyary[$index] = ord(substr($key, ($index%$keylen) + 1, 1));
 }
 for ($index = 0; $index <= 255; $index++) {$asciiary[$index] = $index;}
 $jump = 0;
 for ($index = 0; $index <= 255; $index++) {
  $jump = ($jump + $asciiary[$index] + $keyary[$index])%256;
  $temp = $asciiary[$index];
  $asciiary[$index] = $asciiary[$jump];
  $asciiary[$jump] = $temp;
 }
 $index = 0;
 $jump = 0;
 for ($x = 0; $x < length($message); $x++) {
  $index = ($index + 1)%256;
  $jump = ($jump + $asciiary[$index])%256;
  $t = ($asciiary[$index] + $asciiary[$jump])%256;
  $temp = $asciiary[$index];
  $asciiary[$index] = $asciiary[$jump];
  $asciiary[$jump] = $temp;
  $y = $asciiary[$t];
  $RC4 .= chr(ord(substr($message, $x, 1))^$y);
 }
 return($RC4);
}

sub hex2string {
 my($instring) = @_;
 my($retval,$strlen,$posx);
 $strlen = length($instring);
 for ($posx = 0; $posx < $strlen; $posx=$posx+2) {
  $retval .= chr(hex(substr($instring,$posx,2)));
 }
 return($retval);
}

sub generateGraphicStatArticleBrand {
	my $brand = shift || '';
	if ($brand =~ m/'/)  {
	    $brand=~ s/\'/\'\'/g;
	}
	
	my $username = shift || '';	
	my $nbr;
	my $nbr2;
	my @array = ();
	my @array2= ();
	my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
        my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
	
	my @xLabels  = qw(Jan  Fév Mar Avr Mai Jui Jui Aou Sep Oct Nov Dec);	
	#SUM
	my $j;
	for (my $i = 1; $i < 13;$i++) {
	    if ($i eq '1' or $i eq '2' or $i eq '3' or $i eq '4' or $i eq '5' or $i eq '6' or $i eq '7' or $i eq '8' or $i eq '9') {
		$j = "0" .$i;
	    }else {
		$j = $i;
	    }
	    ($ARTICLE{'eval_count'})= $mydb->sqlSelect("count(*)", "personne,article,a_paye,met_en_vente","nom_utilisateur = '$username' AND a_paye.ref_vendeur = id_personne  and a_paye.ref_article = article.id_article and article.marque = '$brand' and a_paye.date_payement LIKE '%-$j-%' AND met_en_vente.ref_article = article.id_article AND met_en_vente.ref_vendeur = personne.id_personne");	
             $array[ $i -1 ] = $ARTICLE{'eval_count'};
	}
	my @data = ( \@xLabels,\@array );
	
	my $graph = GD::Graph::bars->new(500, 300);
	$graph->set( title   => "$brand",
		     y_label => "Quantity");
	$graph->set_legend( "$brand)",
			    "$brand");
	my $gd = $graph->plot(\@data);
	binmode STDOUT;
	
	open(GRAPH,">C:/Users/41786/OneDrive/Documents/recordz1/upload/$username._evalbrand.jpg") || die "Cannot open /home/alexandre/apache/site/recordz1/upload/$username._evalbrand.jpg : $!\n";
	binmode GRAPH;
	print GRAPH $graph->gd->jpeg(100);
	close(GRAPH);
	return "<img alt=\"\" src=\"../upload/$username._evalbrand.jpg\">";	
}


