package LoadPage;
use warnings;
use MyImageManipulation;
use MyDB;
use LoadProperties;
use Search;
use Digest::MD5 qw(md5_hex);
use Article;
use GD::SecurityImage::AC;
use CGI::Cookie;
use CGI qw/:standard/;
use String::Util 'trim';
use UserAction;
use TableArticle;
use Date::Manip;
use DateTime;
use POSIX qw(strftime);
use Time::HiRes qw(gettimeofday);
use Article;
use DBI;
use MyDB;
use vars qw (%ENV $session_dir $can_do_gzip $cookie $page $dir $dirLang $dirError $imgdir $action $t0 $session_id $ycan_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);

$query = CGI->new ;
$cookie = "";
$current_ip = $ENV{'REMOTE_ADDR'};
$client = $ENV{'HTTP_USER_AGENT'};
$t0 = gettimeofday();
$host = "http://127.0.0.1";
%ERROR = ();%LABEL = ();$LANG = "";%LINK = ();%ARTICLE = ();%SESSION = ();
my %SERVER = (); 
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
my $lang;
our $db = MyDB->new;
our $imageManipulation = MyImageManipulation->new;

our $the_key = "otherbla";
our $cookie;

my $session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});
$session_id = $session->id();

if ($session_id eq '') {
    $session_id = $session->id();    
    
}


sub _untaint { # This doesn't make things safe. It just removes the taint flag. Use wisely.
   my ($value) = @_;
   my ($untainted_value) = $value =~ m/^(.*)$/s;
   return $untainted_value;
}
sub loadPage {
    our $page = '';
    $page = $query->param("page");
    
    if ($page eq 'main') {
       loadMainPage();
       return 1;
    }elsif ($page eq 'login') {
	    loadLogin();
	    return 1;
    }elsif ($page eq 'myench') {
	    loadMyEnchereDeal();
	    return 1;
    } elsif ($page eq 'personal_data') {
	    loadPersonalData();
	    return 1;
    } elsif ($page eq 'myaccount') {
	    loadMyAccount();
	    return 1;
    } elsif ($page eq 'wear_news') {
	    loadWear();
	    return 1;
    } elsif ($page eq 'register') {
	    loadRegister();
	    return 1;
    } elsif ($page eq 'art_design') {
	    loadArtAndDesign();
	    return 1;
    } elsif ($page eq 'lingerie') {
	    loadLingerie();
	    return 1;
    } elsif ($page eq 'baby') {
	    loadBaby();
	    return 1;
    } elsif ($page eq 'animal') {
	    loadAnimal();
	    return 1;	    
    } elsif ($page eq 'parfum') {
	    loadParfum();
	    return 1;
    } elsif ($page eq 'astro') {
	    loadAstrologie();
	    return 1;
    } elsif ($page eq 'auto') {
	    loadAutomobile();
	    return 1;
    } elsif ($page eq 'watch') {
	    loadWatch();
	    return 1;
    } elsif ($page eq 'moto') {
	    loadMoto();
	    return 1;	    
    } elsif ($page eq 'jardin') {
	    loadJardin();
	    return 1;
    } elsif ($page eq 'about') {
	    loadAbout();
	    return 1;	    
    } elsif ($page eq 'cd_vinyl_mixtap') {
	    loadCdVinylMixtape();
	    return 1;    	
    } elsif ($page eq 'intruments') {
	    loadInstruments();
	    return 1;
    } elsif ($page eq 'collection') {
	    loadCollections();
	    return 1;
    } elsif ($page eq 'wine') {
	    loadWine();
	    return 1; 
    } elsif ($page eq 'boat') {
    	    loadBoat();
    	    return 1;	    
    } elsif ($page eq 'tv_video') {
	    loadTvVideo();
	    return 1;
    } elsif ($page eq 'informatique') {
	    loadInformatique();
	    return 1;
    } elsif ($page eq 'games') {
	    loadGames();
	    return 1;
    } elsif ($page eq 'book') {
    	    loadBook();
    	    return 1;
    } elsif ($page eq 'dvd') {
    	    loadDvd();
    	    return 1;
    } elsif ($page eq 'sport') {
	    loadSport();
	    return 1;
    } elsif ($page eq 'immo') {
	    loadImmobilier();
	    return 1;
    } elsif ($page eq 'profil_vendeur') {    	
	    loadProfilDealer();
	    return 1;
    } elsif ($page eq 'commentaire') {
	    loadCommentaire();
	    return 1;
    } elsif ($page eq 'add_other') {	
	    loadAddArticle();
	    return 1;
    } elsif ($page eq 'search_wear') {
	    loadSearchWear();
	    return 1;
    } elsif ($page eq 'search_lingerie') {
	    loadSearchLingerie();
	    return  1;
    } elsif ($page eq 'search_parfum') {
	    loadSearchParfum();
	    return 1;
    } elsif ($page eq 'search_art') {
	    loadSearchArt();
	    return 1;
    } elsif ($page eq 'search_baby') {
	    loadSearchBaby();
	    return 1;
    } elsif ($page eq 'search_astro') {
	    loadSearchAstro();
	    return 1;
    } elsif ($page eq 'search_animal') {
	    loadSearchAnimal();
	    return 1;
    } elsif ($page eq 'search_watch') {
	    loadSearchWatch();
	    return 1;
    } elsif ($page eq 'search_jardin') {
	    loadSearchJardin();
	    return 1;
    } elsif ($page eq 'search_auto') {
	    loadSearchAuto();
	    return 1;
    } elsif ($page eq 'search_moto') {
	    loadSearchMoto();
	    return 1;
    } elsif ($page eq 'search_immo') {
	    loadSearchImmo();
	    return 1;
    } elsif ($page eq 'search_cd') {
	    loadSearchMuzik();
	    return 1;
    } elsif ($page eq 'search_instruments') {
	    loadSearchInstruments();
	    return 1;
    } elsif ($page eq 'search_collection') {
	    loadSearchCollection();
	    return 1;
    } elsif ($page eq 'search_wine') {
	    loadSearchWine();
	    return 1;
    } elsif ($page eq 'search_boat') {
	    loadSearchBoat();
	    return 1;
    } elsif ($page eq 'search_tv') {
	    loadSearchTv();
	    return 1;
    } elsif ($page eq 'search_games') {
	    loadSearchGames();
	    return 1;
    } elsif ($page eq 'search_book') {
	    loadSearchBook();
	    return 1;
    } elsif ($page eq 'search_dvd') {
	    loadSearchDvd();
	    return 1;
    } elsif ($page eq 'search_sport') {
	    loadSearchSport();
    } elsif ($page eq 'encherir') {
	    loadEncherirPage();
	    return 1;
    } elsif ($page eq 'advertise') {
	    loadAdvertise();
	    return 1;
    } elsif ($page eq 'historique') {
	    loadHistoriqueEnchere();
	    return 1;
    } elsif ($page eq 'acheter') {
	    loadAcheterPage();
	    return 1;
    } elsif ($page eq 'myencheredeal') {
	    loadMyEnchereDeal();
	    return 1;
    } elsif ($page eq 'update_statut_article_waiting_buy') {
	    loadPageUpdateArticleWaitingBuy();
	    return 1;
    } elsif ($page eq 'detail_buyer') {
	    loadPageDetailBuyer();
	    return 1;
    } elsif ($page eq 'update_statut_delivered') {
	    loadPageUpdateStatutDelivered();
	    return 1;
    } elsif ($page eq 'update_statut_send_article') {
	    loadPageUpdateStatutDelivered();
	    return 1;
    } elsif ($page eq 'update_article_received') {
	    loadUpdateArticleReceived();
	    return 1;
    } elsif ($page eq 'update_statut_article_payed') {
	    loadUpdateArticlePayment();
	    return 1;
    } elsif ($page eq 'longer') {
	    loadLongerPage();
	    return 1;
    } elsif ($page eq "longerupdate") {
	    loadPayPallForAccount();
	    return 1;
    } elsif ($page eq 'promote') {
	    loadPromote();
	    return 1;
    } elsif ($page eq 'askvisit') {
	    loadAskVisit();
	    return 1;
    } elsif ($page eq 'tarifs') {
	    loadTarifs();
	    return 1;
    } elsif ($page eq 'deleteitem') {
	    loadDeleteItem();
	    return 1;
    } elsif ($page eq 'last_buyers') {
	    loadLastBuyers();
	    return 1;
    }
}

sub loadLastBuyers {
    my $article = $query->param("article");
    my $index = $userAction->loadHistoriqueLastBuyersIndex();
    my $table = $userAction->loadHistoriqueLastBuyersByIndex();
    open (FILE, "<$dir/historique.html") or die "cannot open file $dir/historique.html";
    our $content;
    while (<FILE>) {	
        s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
        s/\$LANG/$lang/g;
	s/\$ARTICLE{'historique_index'}/$index/g;
	s/\$ARTICLE{'historique_table'}/$table/g;
        s/\$SESSIONID/$session_id/g;
        $content .= $_;	
    }
    print "Content-Type: text/html\n\n"; 
    print $content;
    close (FILE);
    
}
sub loadDeleteItem {
        open (FILE, "<$dir/deleteitem.html") or die "cannot open file $dir/deleteitem.html";
	our $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
    
}
sub loadTarifs {
        our $menu = $lp->loadMenu();
	our $categoriesTosearch = $lp->loadCategories();
        open (FILE, "<$dir/tarifs.html") or die "cannot open file $dir/tarifs.html";
	our $content = "";
	$ARTICLE{'image_pub'} = loadPublicite ();
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
    
}
sub loadUpdateArticlePayment {
    our $article = $query->param("article");
    our $username;
    our $u = $query->param("user");
    our $decrypted =  &RC4(&hex2string($u),$the_key);
    our @ib = $db->sqlSelect("iban","article,personne,met_en_vente","id_article = $article and id_article = ref_article");
    our $iban = $ib[0];
    open (FILE, "<$dir/update_statut_article_payed.html") or die "cannot open file $dir/update_statut_article_payed.html";
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'name'}/$name/g;
	    s/\$ARTICLE{'iban'}/$iban/g;
	    s/\$u/$u/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
    
}
sub loadAskVisit {
    my $article = $query->param("article");
    my $name = $query->param("name");
    my $u = $query->param("u");
    my $account_type = $query->param("account_type");
    my $decrypted =  &RC4(&hex2string($u),$the_key);

    open (FILE, "<$dir/askvisit.html") or die "cannot open file $dir/askvisit.html";
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'name'}/$name/g;
	    s/\$u/$u/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
    
}
sub loadPromote {
    my $article = $query->param("article");
    my $name = $query->param("name");
    my $u = $query->param("u");
    my $account_type = $query->param("account_type");
    my $decrypted =  &RC4(&hex2string($u),$the_key);
    open (FILE, "<$dir/promote.html") or die "cannot open file $dir/promote.html";
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'name'}/$name/g;
	    s/\$u/$u/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);

}
sub loadPayPallForAccount {
    my $u = $query->param("u");
    my $account_type = $query->param("account_type");
    my $decrypted =  &RC4(&hex2string($u),$the_key);
    my $time = $query->param("time");
    my ($ref_type_de_compte) = $db->sqlSelect("ref_type_de_compte", "type_de_compte_libelle_langue, libelle, langue","type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang' and libelle.libelle = '$account_type'");
    my ($id_personne,$first_name,$name, $adresse, $city, $npa) = $db->sqlSelect("id_personne,prenom,nom,adresse,ville,npa", "personne","personne.nom_utilisateur = '$decrypted'");
    my  @c= $db->sqlSelect("prix","type_de_compte_libelle_langue, libelle, langue","type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND libelle.libelle = '$accountType'");
    my $price = $c[0];
    $price = $price * $time;
    my ($y, $m, $d, $hh, $mm, $ss) = (localtime)[5,4,3,2,1,0];
    $y += 1900; $m++;
    #my $iso_now;
    if ($m < 10) {
    	 $m = "0$m";
    }
    my $iso_now = "$y-$m-$d $hh:$mm:$ss";
    &Date_Init("Language=French","DateFormat=non-US","TZ=FST"); #French Summer Time 
    my  $date2 = ParseDateString("aujourd'hui");

    my  $currentDate = $iso_now;
    my  $cutoffDate  = &DateCalc($iso_now, "+ $accountDuration mois");
    
    my $year2 = substr($cutoffDate,0,4);
    my $month2 = substr($cutoffDate,4,2);
    my $day2 = substr($cutoffDate,6,2);
    my $date_finish = "$year2-$month2-$day2";
    print $date_finish;
    open (FILE, "<$dir/dolongernext.html") or die "cannot open file $dir/dolongernext.html";
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\ARTICLE{'register_id'}/$id_personne/g;
	    s/\$ARTICLE{'register_amount'}/$price/g;
	    s/\$ARTICLE{'register_firstname'}/$first_name/g;
	    s/\$ARTICLE{'register_lastname'}/$name/g;
	    s/\$ARTICLE{'register_adress'}/$adresse/g;
	    s/\$ARTICLE{'register_city'}/$city/g;
	    s/\$ARTICLE{'register_npa'}/$npa/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);

}
sub loadLongerPage {
	    my $account_type;
	    my $u = $query->param("u");
	print "Content-Type: text/html\n\n";
	print $u;
	    my $accountType = $query->param("account_type");
	    my $accountDuration = $query->param("time");
	    my $OPTIONS = ();
	    if ($accountType) {
		    my $selected = $query->param("account_type");
		    $account_type .= "<option selected VALUE=\"$selected\">$selected</option>";
	    }
	    my  ($c) = $db->sqlSelectMany("libelle.libelle", "type_de_compte_libelle_langue,libelle,langue","ref_type_de_compte = ref_type_de_compte AND type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang'");
	    while(($OPTIONS{'account'})=$c->fetchrow()) {
	        $account_type .= "<option value=/cgi-bin/recordz.cgi?lang=$lang&u=$u&page=longer&account_type=$OPTIONS{'account'}>$OPTIONS{'account'}</option>";
	    }
    
        	
	    
	    my $time;
	    my $i;
	    my $time_select;
	    if ($accountDuration) {
		$time_select .= "<option selected value=$accountDuration>$accountDuration</option>";
	    }
	    
	    for ($i = 0; $i < 13;$i++) {
		$time_select .= "<option value=/cgi-bin/recordz.cgi?lang=$lang&page=longer&account_type=$accountType&time=$i&u=$u>$i</option>";
	    }
	    
	    
	    
	    my $string;
	    $string = "<td>$SERVER{'register_price'}</td>";
	    my  @c= $db->sqlSelect("prix","type_de_compte_libelle_langue, libelle, langue","type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND libelle.libelle = '$accountType'");
	    my $price = $c[0];
	    $price = $price * $accountDuration;
	    $string .="<td><input type=\"text\" name=\"price\" value=\"$price\"</input></td>";
	    my ($y, $m, $d, $hh, $mm, $ss) = (localtime)[5,4,3,2,1,0]; $y += 1900; $m++;	    
	    if ($m < 10) {
	    	 $m = "0$m";
	    }
    	    my $iso_now = "$y-$m-$d $hh:$mm:$ss";
	&Date_Init("Language=French","DateFormat=non-US","TZ=FST"); #French Summer Time 
        my  $date2 = ParseDateString("aujourd'hui");

	my   $currentDate = $iso_now;
	my   $cutoffDate  = &DateCalc($iso_now, "+ $accountDuration mois");
	
	my $year2 = substr($cutoffDate,0,4);
	my $month2 = substr($cutoffDate,4,2);
	my $day2 = substr($cutoffDate,6,2);
	my $date_finish = "$year2-$month2-$day2";
	print "Content-Type: text/html\n\n";
	print $date_finish;
	open (FILE, "<$dir/longer.html") or die "cannot open file $dir/longer.html";
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'date_end'}/$date_finish/g;
	    s/\$OPTIONS{'time'}/$time_select/g;
	    s/\$OPTIONS{'cat'}/$account_type/g;
	    s/\$SELECT{'date_start'}/$iso_now/g;
	    s/\$VALUE{'price'}/$string/g;
	    s/\$u/$u/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
	}
    
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
    
}


sub loadAdvertise {
        my $menu = $lp->loadMenu();
	my $username = $query->param("u");
	my $cookie_in = $query->cookie("USERNAME");
	my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
	my $encrypt =  &string2hex(&RC4($decypted,$the_key));
	my $table_index_current_deal = '';
	if($decrypted) 
	{ 	
	#if ($decrypted) {                          
	    $table_index_current_deal = $tableArticle->loadTableAdvertiseIndexCurrentDeal($decrypted);
	    $table_current_deal = $tableArticle->loadTableAdvertiseByIndexCurrentDeal($decrypted);
	    my $categoriesTosearch = $lp->loadCategories();
	    open (FILE, "<$dir/advertise.html") or die "cannot open file $dir/advertise.html";
	    my $content;
	    while (<FILE>) {	
		s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
		s/\$LANG/$lang/g;
		s/\$ARTICLE{'table_index_current_deal'}/$table_index_current_deal/g;
		s/\$ARTICLE{'table_current_deal'}/$table_current_deal/g;
		s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
		s/\$ARTICLE{'main_menu'}/$menu/g;
		s/\$SESSIONID/$session_id/g;
		s/\$u/$username/g;
		$content .= $_;	
	    }
	

	    print "Content-Type: text/html\n\n"; 
	    print $content;
	    close (FILE);
	}
}
	
sub loadMyEnchereDeal {
      
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
		         $SELECT{'type_article'} .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=myencheredeal&session=$session_id&option=statdealarticlebrand&u=$username&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
		    }
		    $SELECT{'type_article'} .= "</select></td>";
		    ($c) = $db->sqlSelectMany("DISTINCT article.marque","article,personne,categorie_libelle_langue, met_en_vente", "personne.nom_utilisateur = '$decrypted' and met_en_vente.ref_vendeur = personne.id_personne AND met_en_vente.ref_article = article.id_article AND article.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue,libelle,langue WHERE libelle.libelle = '$selected' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle and categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
		    %OPTIONS = ();
		    my $category = $query->param("category");
		    $selected = $query->param("brand");
		    $SELECT{'brand'} = "<td>$SERVER{'type_article'}</td><td><select name=\"brand\" onchange=\"go2();\">";
		    $SELECT{'brand'} .= "<option selected VALUE=\"$selected\">$selected</option>";
		    while(($OPTIONS{'category'})=$c->fetchrow()) {	
		         $SELECT{'brand'} .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=myencheredeal&sesasion=$session_id&option=statdealarticlebrand&u=$username&category=$category&brand=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
		    }
		    $SELECT{'brand'} .= "</select>";
		     
		    $IMG{'statistiques_brand'} = $imageManipulation->generateGraphicStatArticleBrand($brand, $decrypted);
	    } elsif ($option eq 'statdealarticleville') {
		    my ($c) = $db->sqlSelectMany("nom","canton_fr", "id_canton = id_canton");
		    $SELECT{'canton'} .= "<td>$SERVER{'type_article'}</td><td><select name=\"canton\" onchange=\"go3();\">";
		    my  %OPTIONS = ();
		    my $selected = $query->param("canton");
		    $SELECT{'canton'} .= "<option selected VALUE=\"$selected\">$selected</option>";
		    while(($OPTIONS{'category'})=$c->fetchrow()) {	
		         $SELECT{'canton'} .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=myencheredeal&session=$session_id&option=statdealarticleville&u=$username&canton=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
		    }
		$SELECT{'canton'} .= "</select>";
		if ($selected) {
		    $IMG{'statistiques_canton'} = $imageManipulation->generateGraphicStatArticleCanton($selected, $decrypted);
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
	}
}


sub loadPageUpdateStatutDelivered {
    my $article = $query->param("article");
    my $u = $query->param("u");
    my $decrypted =  &RC4(&hex2string($u),$the_key);
    my $id_a_livre = $query->param("id_a_livre");
    
    ($ARTICLE{'id_personne'},$ARTICLE{'first_name'},$ARTICLE{'name'},$ARTICLE{'country'},$ARTICLE{'adresse'},$ARTICLE{'city'},$ARTICLE{'npa'},$ARTICLE{'phone_number'},$ARTICLE{'email'}) = $db->sqlSelect("id_personne,prenom,nom,pays,adresse,ville,npa,no_telephone,email","personne,a_livre","id_a_livre = $id_a_livre and ref_acheteur = id_personne");
    my ($id_a_paye) = $db->sqlSelect("id_a_paye","a_paye","ref_article = $article AND ref_vendeur = $ARTICLE{'id_personne'}");
    open (FILE, "<$dir/update_statut_send.html") or die "cannot open file $dir/update_statut_send.html";    	
    my $content;
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	s/\$LANG/$lang/g;
	s/\$ARTICLE{'price'}/$price/g;
	s/\$ARTICLE{'id_article'}/$article/g;
	s/\$ARTICLE{'id_a_paye'}/$id_a_paye/g;
	s/\$ARTICLE{'id_a_livre'}/$id_a_livre/g;
	s/\$ARTICLE{'first_name'}/$ARTICLE{'first_name'}/g;
	s/\$ARTICLE{'name'}/$ARTICLE{'name'}/g;
	s/\$ARTICLE{'country'}/$ARTICLE{'country'}/g;
	s/\$ARTICLE{'adresse'}/$ARTICLE{'adresse'}/g;
	s/\$ARTICLE{'city'}/$ARTICLE{'city'}/g;
	s/\$ARTICLE{'npa'}/$ARTICLE{'npa'}/g;
	s/\$ARTICLE{'phone_number'}/$ARTICLE{'phone_number'}/g;
	s/\$ARTICLE{'email'}/$ARTICLE{'email'}/g;
	s/\$ARTICLE{'mode_de_livraison'}/$condition_livraison_libelle/g;
	s/\$u/$u/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }

    $content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
    print "Content-Length: ", length($content) , "\n";
    print "Content-Encoding: gzip\n" ;
    print "Content-Type: text/html\n\n"; 
    print $content;
    close (FILE);				
	
}

sub loadUpdateArticleReceived {
    my $article = $query->param("article");
    my $u = $query->param("u");
    my $decrypted =  &RC4(&hex2string($u),$the_key);
    my $id_a_paye = $query->param("id_a_paye");
    
    my ($id_a_livre) = $db->sqlSelect("id_a_livre","a_livre","ref_article = $article AND ref_acheteur = (SELECT id_personne FROM personne WHERE nom_utilisateur = '$decrypted')");
    open (FILE, "<$dir/update_article_received.html") or die "cannot open file $dir/update_article_received.html";    	
    my $content;
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	s/\$LANG/$lang/g;
	s/\$ARTICLE{'price'}/$price/g;
	s/\$ARTICLE{'id_article'}/$article/g;
	s/\$ARTICLE{'id_a_paye'}/$id_a_paye/g;
	s/\$ARTICLE{'id_a_livre'}/$id_a_livre/g;
	s/\$u/$decrypted/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }

    $content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
    print "Content-Length: ", length($content) , "\n";
    print "Content-Encoding: gzip\n" ;
    print "Content-Type: text/html\n\n"; 
    print $content;
    close (FILE);				
    
}


sub loadAcheterPage {
	my $article = $query->param("article");
	my $nb_article = $query->param("nb_article");
	my @enchere = $db->sqlSelect("prix","article","id_article = $article");
	my $price = $enchere[0];
	
	my @payment_mode = $db->sqlSelect("ref_condition_payement","article","id_article = $article");
	my $payment_mode_ref = $payment_mode[0];
	my @payment = $db->sqlSelect("libelle.libelle","condition_payement_libelle_langue,libelle,langue","ref_condition_payement = '$payment_mode_ref' AND condition_payement_libelle_langue.ref_libelle = libelle.id_libelle AND condition_payement_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my $payment_libelle = $payment[0];
	
	my @condition_livraison_mode = $db->sqlSelect("ref_condition_livraison","article","id_article = $article");
	my $condition_livraison_ref = $condition_livraison_mode[0];
	my @condition_livraison = $db->sqlSelect("libelle.libelle","condition_livraison_libelle_langue,libelle,langue","ref_condition_livraison = $condition_livraison_ref AND condition_livraison_libelle_langue.ref_libelle = libelle.id_libelle AND condition_livraison_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my $condition_livraison_libelle = @condition_livraison[0];
	my @buy_waiting_counter = $db->sqlSelect("quantite", "article", "id_article = $article");
	my $buy_waiting_counter = @$buy_waiting_counter[0];
	open (FILE, "<$dir/acheter.html") or die "cannot open file $dir/acheter.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'buy_waiting_counter'}/$buy_waiting_counter/g;
	    s/\$ARTICLE{'price'}/$price/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'last_enchere'}/$last_enchere/g;
	    s/\$ARTICLE{'condition_de_payement'}/$payment_libelle/g;
	    s/\$ARTICLE{'mode_de_livraison'}/$condition_livraison_libelle/g;
	    s/\$ARTICLE{'ref_mode_livraison'}/$condition_livraison_ref/g;
	    s/\$ARTICLE{'ref_mode_payement'}/$payment_mode_ref/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadPageDetailBuyer {
    my $article = $query->param("article");
    my $username = $query->param("u");
    my $decrypted =  &RC4(&hex2string($username),$the_key);
    my $buyer = $query->param("buyer");
    my $id_a_paye = $query->param("id_a_paye");
    ($ARTICLE{'first_name'}, $ARTICLE{'name_per'}, $ARTICLE{'country'}, $ARTICLE{'adress_name'}, $ARTICLE{'city'}, $ARTICLE{'npa'}, $ARTICLE{'phone_number'}, $ARTICLE{'email'}) = $db->sqlSelect("prenom, nom, pays, adresse, ville, npa, no_telephone, email,","personne", "nom_utilisateur = '$buyer'");
    
    open (FILE, "<$dir/view_user_data.html") or die "cannot open file $dir/view_user_data.html";
    while (<FILE>) {	
        s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	s/\$LANG/$lang/g;
	s/\$ARTICLE{'buyer'}/$buyer/g;
	s/\$ARTICLE{'id_article'}/$article/g;
	s/\$ARTICLE{'first_name'}/$ARTICLE{'first_name'}/g;
	s/\$ARTICLE{'name_per'}/$ARTICLE{'name_per'}/g;
	s/\$ARTICLE{'country'}/$ARTICLE{'country'}/g;
	s/\$ARTICLE{'adress_name'}/$ARTICLE{'adress_name'}/g;
	s/\$ARTICLE{'city'}/$ARTICLE{'city'}/g;
	s/\$ARTICLE{'npa'}/$ARTICLE{'npa'}/g;
	s/\$ARTICLE{'id_a_paye'}/$id_a_paye/g;
	s/\$ARTICLE{'phone_number'}/$ARTICLE{'phone_number'}/g;
	s/\$ARTICLE{'email'}/$ARTICLE{'email'}/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SESSIONID/$session_id/g;
	s/\$u/$username/g;
	$content .= $_;	
    }
    print "Content-Type: text/html\n\n"; 
    print $content;
    #print "client :" .$client;
    close (FILE);	
    
}
sub loadPageUpdateArticleWaitingBuy {
	my $cookie_in = $query->cookie("USERNAME");
        my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
	my $encrypt =  &string2hex(&RC4($decypted,$the_key));
	my $content;
	my $article = $query->param("article");
	my $buyer = $query->param("buyer");
	my $id_a_paye = $query->param("id_a_paye");
	 ($ARTICLE{'first_name'}, $ARTICLE{'name_per'}, $ARTICLE{'country'}, $ARTICLE{'adress_name'}, $ARTICLE{'city'}, $ARTICLE{'npa'}, $ARTICLE{'phone_number'}, $ARTICLE{'email'},$ARTICLE{'iban'},$ARTICLE{'skype'}) = $db->sqlSelect("prenom, personne.nom, pays, personne.adresse, ville, personne.npa, no_telephone, email,iban, skype_name","personne,article,a_paye", "ref_acheteur = id_personne AND ref_article = id_article AND id_article = $article");
	open (FILE, "<$dir/update_statut_article_waiting_buy.html") or die "cannot open file $dir/update_statut_article_waiting_buy.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'buyer'}/$buyer/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'id_a_paye'}/$id_a_paye/g;
	    s/\$ARTICLE{'first_name'}/$ARTICLE{'first_name'}/g;
	    s/\$ARTICLE{'name_per'}/$ARTICLE{'name_per'}/g;
	    s/\$ARTICLE{'country'}/$ARTICLE{'country'}/g;
	    s/\$ARTICLE{'adress_name'}/$ARTICLE{'adress_name'}/g;
	    s/\$ARTICLE{'city'}/$ARTICLE{'city'}/g;
	    s/\$ARTICLE{'npa'}/$ARTICLE{'npa'}/g;
	    s/\$ARTICLE{'phone_number'}/$ARTICLE{'phone_number'}/g;
	    s/\$ARTICLE{'email'}/$ARTICLE{'email'}/g;
	    s/\$ARTICLE{'iban'}/$ARTICLE{'iban'}/g;
	    s/\$ARTICLE{'skype'}/$ARTICLE{'skype'}/g,
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$u/$decrypted/g;
	    $content .= $_;	
        }
	print "Contenst-Type: text/html\n\n"; 
	print $content;
        close (FILE);	
}
sub loadHistoriqueEnchere {
    my $article = $query->param("article");
    my $index = $userAction->loadHistoriqueIndex();
    my $table = $userAction->loadHistoriqueByIndex();
    open (FILE, "<$dir/historique.html") or die "cannot open file $dir/historique.html";    	
    my $content;
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	s/\$LANG/$lang/g;
	s/\$ARTICLE{'id_article'}/$article/g;
	s/\$ARTICLE{'historique_index'}/$index/g;
	s/\$ARTICLE{'historique_table'}/$table/g;	
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }
    $content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
    print "Content-Length: ", length($content) , "\n";
    print "Content-Encoding: gzip\n" ;
    print "Content-Type: text/html\n\n"; 
    print $content;
    close (FILE);				
}

sub loadEncherirPage {
	my $article = $query->param("article");
	my @enchere = $db->sqlSelect("MAX(prix)", "enchere", "ref_article = $article");
	my $last_enchere = $enchere[0];
	if ($last_enchere eq '') {
		@enchere = $db->sqlSelect("prix","article","id_article = $article");
		$last_enchere = $enchere[0];
	}
	open (FILE, "<$dir/encherir.html") or die "cannot open file $dir/encherir.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'last_enchere'}/$last_enchere/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				

}

sub loadSearchImmo {
	my $pays = $query->param("country");
    	my $categories = $lp->loadSearchImmoMode();
	my $countries = $lp->loadSearchImmoCountry();
	my $menu = $lp->loadSearchImmobilierMenu();
	my $toLoad;
	if ($pays eq 'Suisse') {
	   $toLoad = $lp->loadSearchImmoCanton();    
	} elsif ($pays eq 'France') {
	    $toLoad = $lp->loadSearchImmoDepartement();    
	}
	

	my $subcategories = $lp->loadSearchArtSubCategory();
	my $fabricant =   $lp->loadSearchArtFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_immo.html") or die "cannot open file $dir/search_immo.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'loyer_properties'}/$categories/g;
	    s/\$SELECT{'departement_or_canton'}/$toLoad/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'immo_type'}/$menu/g;	
	    s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$SELECT{'country'}/$countries/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchTv {
	my $subcategory = $query->param("subcategory");
	my $type_ecran;
	my $ecran_size;
	my $fabricant;
	my $pc_properties;
	my $logiciel;
	if (trim($subcategory) eq trim($SERVER{'tv'})) {
	    $type_ecran = $lp->loadSearchTvTypeEcran();
	    $ecran_size = $lp->loadSearchTvProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim($SERVER{'lecteur_dvd'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'chaines_hifi'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'ecrans_plats'})) {
    	    $type_ecran = $lp->loadSearchTvTypeEcran();
	    $ecran_size = $lp->loadSearchTvProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'lecteurs_mp3'})) {
    	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $type_ecran = $lp->loadLecteurMp3Properties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'casques_audio'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim (trim $SERVER{'enceintes'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'pc'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'ordinateurs_portable'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'mac'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'tablettes'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'souris'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'telecommandes'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'logiciel'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $logiciel = $lp->loadInfoLogicielProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'natels'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'webcam'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'cablages'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'carte_mere'})) {
	    $pc_properties = $lp->loadInfoCarteMereProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'scanners'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'photocopieurs'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'routeurs'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'antennes_satellite'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'lecteurs_biometrique'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}   elsif (trim ($subcategory) eq trim ($SERVER{'lecteurs_carte_puce'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}   elsif (trim ($subcategory) eq trim ($SERVER{'caisses_enregistreuse'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} 
	my $categories = $lp->loadSearchTvSubCategories();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_tv.html") or die "cannot open file $dir/search_tv.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'subcategory'}/$categories/g;
	    s/\$SELECT{'type_ecran'}/$type_ecran/g;
	    s/\$ARTICLE{'tv_properties'}/$ecran_size/g;
	    s/\$ARTICLE{'fabricant'}/$fabricant/g;
	    s/\$ARTICLE{'pc_properties'}/$pc_properties/g;
	    s/\$ARTICLE{'logiciel'}/$logiciel/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
    
}
sub loadSearchWine {
    	my $country = $lp->loadSearchWineCountry();
	my $type_de_vin = $lp->loadSearchWineType();
	my $region = $lp->loadSearchWineCepage();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_wine.html") or die "cannot open file $dir/search_wine.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'country'}/$country/g;
	    s/\$SELECT{'type_de_vin'}/$type_de_vin/g;
	    s/\$SELECT{'region'}/$region/g;
	 #   s/\$SELECT{'subcat'}/$subcategories/g;
	  #  s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchSport {
	my $category = $query->param("category");
    	my $categories = $lp->loadSearchSportMenu();
	my $subcategories = $lp->loadSearchSportSubMenu();
	my $properties = $lp->loadSearchSportProperties();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_sport.html") or die "cannot open file $dir/search_sport.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'sport_categories'}/$categories/g;
	    s/\$SELECT{'sport_subcategories'}/$subcategories/g;
	    s/\$ARTICLE{'sport_properties'}/$properties/g;
	    
	    s/\$ARTICLE{'used'}/$used/g;
	  #  s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchBook {
	my $category = $query->param("category");
    	my $categories = $lp->loadSearchBookCategories();
	my $properties = $lp->loadSearchBookProperties();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_book.html") or die "cannot open file $dir/search_book.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$ARTICLE{'book_properties'}/$properties/g;
	    
	    s/\$ARTICLE{'used'}/$used/g;
	  #  s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
    
}

sub loadSearchDvd {
	my $category = $query->param("category");
    	my $categories = $lp->loadSearchDvdCategories();
	my $properties = $lp->loadSearchDvdProperties() ;
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_dvd.html") or die "cannot open file $dir/search_dvd.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'dvd_categories'}/$categories/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ARTICLE{'dvd_properties'}/$properties/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchGames {
	my $category = $query->param("category");
    	my $categories = $lp->loadSearchGamesMenu();
	my $subcategories ;
	if ($category) {
	    $subcategories = $lp->loadSearchGamesSubMenu();
	}
	
	
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_games.html") or die "cannot open file $dir/search_games.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$SELECT{'subcategory'}/$subcategories/g;
	  #  s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
    
}

sub loadSearchBoat {
    	my $categories = $lp->loadSearchBoatCategory();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_boat.html") or die "cannot open file $dir/search_boat.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'used'}/$used/g;
	 #   s/\$SELECT{'subcat'}/$subcategories/g;
	  #  s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
    
}

sub loadSearchCollection {
    	my $categories = $lp->loadSearchCollectionCategory();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_collection.html") or die "cannot open file $dir/search_collection.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	 #   s/\$SELECT{'subcat'}/$subcategories/g;
	  #  s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchArt {	
    	my $categories = $lp->loadSearchArtCategory();
	my $subcategories = $lp->loadSearchArtSubCategory();
	my $fabricant =   $lp->loadSearchArtFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_art.html") or die "cannot open file $dir/search_art.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchAuto {    	
	my $subcategories = $lp->loadSearchCarSubcategories();	
	my $properties = $lp->loadAutoSearchProperties();
	my $fabricant = $lp->loadSearchCarFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_auto.html") or die "cannot open file $dir/search_auto.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'subcategory}/$subcategories/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$ARTICLE{'properties'}/$properties/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchMoto {
        my $subcategories = $lp->loadSearchMotoSubCategories();
	my $properties = $lp->loadMotoSearchProperties();
	my $fabricant = $lp->loadMotoFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_moto.html") or die "cannot open file $dir/search_moto.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'subcategory'}/$subcategories/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$ARTICLE{'properties'}/$properties/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchWatch {
    	my $categories = $lp->loadSearchWatchCategory();
	my $subcategories = $lp->loadSearchWatchSubCategory();
	my $fabricant =   $lp->loadSearchWatchFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_watch.html") or die "cannot open file $dir/search_watch.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'categories'}/$categories/g;
	    s/\$SELECT{'subcategories'}/$subcategories/g;
	    s/\$SELECT{'fabricants'}/$fabricant/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchInstruments {
    	my $categories = $lp->loadSearchInstrumentsCategory();
	my $subcategories = $lp->loadSearchInstrumentsSubCategory();
	my $fabricant =   $lp->loadSearchWatchFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_instruments.html") or die "cannot open file $dir/search_instruments.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcategory'}/$subcategories/g;
	    s/\$SELECT{'fabricants'}/$fabricant/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchJardin {
    	my $categories = $lp->loadSearchJardinCategory();
	my $subcategories = $lp->loadSearchJardinSubCategory();
	my $fabricant =   $lp->loadSearchJardinFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_jardin.html") or die "cannot open file $dir/search_jardin.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchAstro {
    	my $categories = $lp->loadSearchAstroCategories();
	my $subcategories = $lp->loadSearchAstroSubCategories();
	my $fabricant =   $lp->loadSearchBabyFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_astro.html") or die "cannot open file $dir/search_astro.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'astro_categories'}/$categories/g;
	    s/\$SELECT{'astro_subcategories'}/$subcategories/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}

sub loadSearchAnimal {
    	my $categories = $lp->loadSearchAnimalCategories();
	my $subcategories = $lp->loadSearchAnimalSubCategories();
	my $fabricant =   $lp->loadSearchAnimalFabricants();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_animal.html") or die "cannot open file $dir/search_animal.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    

}

sub loadSearchMuzik {
    	my $categories = $lp->loadSearchMuzikCategories();
	my $subcategories = $lp->loadSearchCdVinylMixTapeSubCategories();
	my $fabricant =   $lp->loadSearchCdProperties();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_cd.html") or die "cannot open file $dir/search_cd.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'cd_vinyl_mixtape'}/$categories/g;
	    s/\$SELECT{'sub_cd_vinyl_mixtape'}/$subcategories/g;
	    s/\$ARTICLE{'cd_properties'}/$fabricant/g;
	    s/\$ARTICLE{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchBaby {
    	my $categories = $lp->loadSearchBabyCategory();
	my $subcategories = $lp->loadSearchBabySubCategory();
	my $fabricant =   $lp->loadSearchBabyFabricant();
	my $used = $lp->loadUsedOrNew();
	open (FILE, "<$dir/search_baby.html") or die "cannot open file $dir/search_baby.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadSearchParfum {
    	my $categories = $lp->loadSearchParfumCategory();
	my $subcategories = $lp->loadSearchParfumSubCategory();
	my $fabricant =   $lp->loadSearchParfumFabricant();
	my $used = $lp->loadUsedOrNew();
	my $article = $query->param("article");

	open (FILE, "<$dir/search_parfum.html") or die "cannot open file $dir/search_parfum.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				

}
sub loadSearchLingerie {
	my $categories = $lp->loadSearchLingerieCategory();
	my $subcategories = $lp->loadSearchLingerieSubCategory();
	my $fabricant = $lp->loadSearchLingerieFabricant();
	my $used = $lp->loadUsedOrNew();
	my $article = $query->param("article");

	open (FILE, "<$dir/search_lingerie.html") or die "cannot open file $dir/search_lingerie.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				    
}
sub loadSearchWear {
	my $properties = $lp->loadSearchWearProperties();
	my $categories = $lp->loadSearchWearCategories();
	my $subcategories = $lp->loadSearchWearSubCategories();
	my $fabricant = $lp->loadSearchWearFabricants();
	my $used = $lp->loadUsedOrNew();
	my $article = $query->param("article");
	open (FILE, "<$dir/search_wear.html") or die "cannot open file $dir/search_wear.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$SELECT{'properties'}/$properties/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcategory'}/$subcategories/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadCommentaire {
        my $captcha = Authen::Captcha->new(height => 50); # optional. default 35);
	$captcha->expire(5 * 60);
	$captcha->data_folder('/home/alexandre/apache/site/recordz1/upload/');
        $captcha->output_folder('/home/alexandre/apache/site/recordz1/upload/');
	my $md5sum = $captcha->generate_code(5);
	my $article = $query->param("article");
	open (FILE, "<$dir/commentaire.html") or die "cannot open file $dir/commentaire.html";    	
	my $content;	
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$image/$md5sum/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
    
}
sub loadImmobilier {
    	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}

	my $u = $query->param("u");
	my $country = $lp->loadImmoCountry();
	my $country_selected = $query->param("country_name");
	my $categoriesTosearch = $lp->loadCategories();
	my $immo_menu = "";
	my $immo_menuSearch = "";
	my $dep = "";
	$immo_menu = $lp->loadImmobilierMenu();
	if (($country_selected eq 'France') && ($show_popup  eq "")) {
	    $dep = $lp->loadAddImmoDepartement();	    
	} elsif ($country_selected eq 'France' && ($show_popup  eq "true")) {
	    $dep = $lp->loadAddImmoDepartementTosearch();
	    $immo_menu = $lp->loadSearchImmobilierMenu();	    
	} elsif (($country_selected eq 'Suisse') && ($show_popup  eq "")) {	    
	    $dep = $lp->loadAddImmoDepartement2();
	} elsif (($country_selected eq 'Suisse') && ($show_popup  eq "true")) {
	    $dep = $lp->loadAddImmoDepartement2ToSearch();
	    $immo_menu = $lp->loadSearchImmobilierMenu();	    
	}
	my $pays = $query->param("country");
    	my $categories = $lp->loadSearchImmoMode();
	my $countries = $lp->loadSearchImmoCountryToPopUp(); 
	
	my $toLoad = $dep;
	my $location_ou_achat = $lp->loadImmobilierLocationOuAchat();

	open (FILE, "<$dir/immobilier.html") or die "cannot open file $dir/immobilier.html";    	
	my $selectionIndex = $tableArticle->loadImmobilierIndex();
	my $selection = $tableArticle->loadImmobilierByIndex();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $menu = $lp->loadMenu();
	my $content;	
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'country'}/$country/g;
	    s/\$SELECT{'location'}/$location_ou_achat/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SELECT{'dep'}/$dep/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$SELECT{'immo_menu'}/$immo_menu/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$SELECT{'loyer_properties'}/$categories/g;
	    s/\$SELECT{'departement_or_canton'}/$toLoad/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$SELECT{'immo_type'}/$immo_menu/g;	
	    s/\$SELECT{'auteur'}/$fabricant/g;
	    s/\$SELECT{'country'}/$countries/g;
	    s/\$SELECT{'countries'}/$countries/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
}
sub loadSport {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
    
	open (FILE, "<$dir/sport.html") or die "cannot open file $dir/sport.html";    	
	my $categories = $lp->loadSportMenu();
	my $categoriesSearch = $lp->loadSearchSportMenu();
	my $subcategoriesSearch = "";#$lp->loadSearchSportSubMenu();
	my $usedSearch = $lp->loadUsedOrNew();
	my $subcategories = $lp->loadSportSubMenu();
	my $selectionIndex = $tableArticle->loadSportIndex();
	my $selection = $tableArticle->loadSportByIndex();
	my $menu = $lp->loadMenu();
	my $content;
	my $categoriesTosearch = $lp->loadCategories();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$SELECT{'sport_menu'}/$categories/g;
	    s/\$SELECT{'sport_submenu'}/$subcategories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	        
	    $content .= $_;	
	    }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				

}
sub loadDvd {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
    
	open (FILE, "<$dir/dvd.html") or die "cannot open file $dir/dvd.html";
	my $categories = $lp->loadDvdCategories();
	my $selectionIndex = $tableArticle->loadDvdIndex();
	my $selection = $tableArticle->loadDvdByIndex();
	my $properties = $lp->loadSearchDvdProperties();
	my $menu = $lp->loadMenu();            
	my $categoriesSearch = $lp->loadSearchDvdCategories();
	my $properties = $lp->loadSearchDvdProperties();
	my $usedSearch = $lp->loadUsedOrNew();
	my $content;
	my $categoriesTosearch = $lp->loadCategories();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'dvd_menu'}/$categories/g;
	    s/\$ARTICLE{'dvd_properties'}/$properties/g;
	    s/\$SELECT{'dvd_categories'}/$categoriesSearch/g;
	    s/\$ARTICLE{'used'}/$usedSearch/g;	    
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;    
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
	
}
sub loadBook {
    	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}

    
	open (FILE, "<$dir/book.html") or die "cannot open file $dir/book.html";    	
	my $categories = $lp->loadBookCategories();
	my $selectionIndex = $tableArticle->loadBookIndex();
	my $selection = $tableArticle->loadBookByIndex();
	my $properties = $lp->loadSearchBookProperties();
	my $categoriesSearch = $lp->loadSearchBookCategories();
	my $menu = $lp->loadMenu();
	my $categoriesTosearch = $lp->loadCategories();
	my $content;
	my $used = $lp->loadUsedOrNew();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;                           
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$SELECT{'book_menu'}/$categories/g;
	    s/\$SELECT{'category_search'}/$categoriesSearch/g;
	    s/\$ARTICLE{'used'}/$used/g;	    	    
	    s/\$ARTICLE{'book_properties'}/$properties/g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    #s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);				
}
sub loadGames {
    	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}

    	my $categorySearch = $query->param("category");
    	my $categoriesSearch = $lp->loadSearchGamesMenu();
	my $subcategoriesSearch ;
	if ($categorySearch) {
	    $subcategoriesSearch = $lp->loadSearchGamesSubMenu();
	}
	
	
	my $usedSearch = $lp->loadUsedOrNew();


	my $category = $query->param("category");
	my $subcat   = $query->param("subcat");
	my $submenu;
	my $game_type;
	my $categoriesTosearch = $lp->loadCategories();
	if ($category) {
		$submenu = $lp->loadGamesSubMenu();
		my  ($catID)=$db->sqlSelect("ref_categorie", "categorie_libelle_langue,libelle, langue", "libelle.libelle = '$category' and categorie_libelle_langue.ref_libelle = libelle.id_libelle and categorie_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang'");
		if ($catID eq '29') {$game_type = $lp->loadGamesType();}
	}
	my $content;
	my $cats = $articleClass->getCat();
	my $menu = $lp->loadMenu();
	my $games_menu = $lp->loadGamesMenu();
	my $index = $tableArticle->loadGamesIndex();
	my $table = "";#$tableArticle->loadGamesByIndex();
	open (FILE, "<$dir/games.html") or die "cannot open file $dir/games.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;s/\$SELECT{'consoles_menu'}/$games_menu/g;
	    s/\$SELECT{'games_category_menu'}/$submenu/g;s/\$SELECT{'game_type'}/$game_type/g;
	    s/\$OPTIONS{'categories2'}/$cats/g;s/\$ARTICLE{'index'}/$index/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$SELECT{'category_search'}/$categoriesSearch/g;
	    s/\$SELECT{'used_search'}/$usedSearch/g;
	    s/\$SELECT{'subcategory_search'}/$subcategoriesSearch/g;	
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$ERROR{'([\w]+)'}//g;s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n"; print $content;
        close (FILE);
}
sub loadInformatique {
	open (FILE, "<$dir/informatique.html") or die "cannot open file $dir/informatique.html";    	
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
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);			
	
}
sub loadTvVideo {
        my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}    
	my $subcategory = $query->param("subcategory");
	my $type_ecran;
	my $ecran_size;
	my $fabricant;
	my $pc_properties;
	my $logiciel;
	if (trim($subcategory) eq trim($SERVER{'tv'})) {
	    $type_ecran = $lp->loadSearchTvTypeEcran();
	    $ecran_size = $lp->loadSearchTvProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim($SERVER{'lecteur_dvd'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'chaines_hifi'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'ecrans_plats'})) {
    	    $type_ecran = $lp->loadSearchTvTypeEcran();
	    $ecran_size = $lp->loadSearchTvProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'lecteurs_mp3'})) {
    	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $type_ecran = $lp->loadLecteurMp3Properties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'casques_audio'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim (trim $SERVER{'enceintes'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'pc'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'ordinateurs_portable'})) {
	    $pc_properties = $lp->loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'mac'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'tablettes'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'souris'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	} elsif (trim ($subcategory) eq trim ($SERVER{'telecommandes'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'logiciel'})) {
	    $ecran_size = $lp->loadSearchLecteurProperties();
	    $logiciel = $lp->loadInfoLogicielProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'natels'})) {
	    $pc_properties = loadInfoPcProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'webcam'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'cablages'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'carte_mere'})) {
	    $pc_properties = $lp->loadInfoCarteMereProperties();
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} elsif (trim ($subcategory) eq trim ($SERVER{'scanners'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'photocopieurs'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'routeurs'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'antennes_satellite'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}  elsif (trim ($subcategory) eq trim ($SERVER{'lecteurs_biometrique'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}   elsif (trim ($subcategory) eq trim ($SERVER{'lecteurs_carte_puce'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	}   elsif (trim ($subcategory) eq trim ($SERVER{'caisses_enregistreuse'})) {	
	    $fabricant = $lp->loadSearchTvFabricant();
	    $ecran_size = $lp->loadSearchLecteurProperties();
	} 
	my $categoriesSearch = $lp->loadSearchTvSubCategories();
	my $used = $lp->loadUsedOrNew();

	open (FILE, "<$dir/tv_video.html") or die "cannot open file $dir/tv_video.html";    	
	my $categories = $lp->loadTvOrDVD();
	my $selectionIndex = $tableArticle->loadMultimediaInformatiqueIndex();
	my $selection = $tableArticle->loadMultimediaInformatiqueByIndex();
	my $menu = $lp->loadMenu();
	my $categoriesTosearch = $lp->loadCategories();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'tv_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'tv_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'tv_video'}/$categories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$SELECT{'subcategory'}/$categoriesSearch/g;
	    s/\$SELECT{'type_ecran'}/$type_ecran/g;
	    s/\$ARTICLE{'tv_properties'}/$ecran_size/g;
	    s/\$ARTICLE{'fabricant'}/$fabricant/g;
	    s/\$ARTICLE{'pc_properties'}/$pc_properties/g;
	    s/\$ARTICLE{'logiciel'}/$logiciel/g;
	    s/\$ARTICLE{'show'}/$search/g;	    
	    s/\$SELECT{'used'}/$used/g;	    
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);			
}
sub loadBoat {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}    
    
	open (FILE, "<$dir/boat.html") or die "cannot open file $dir/boat.html";    	
	my $categories = $lp->loadBoatMenu();
	my $selectionIndex = $tableArticle->loadBoatIndex();
	my $selection = $tableArticle->loadBoatByIndex();
	my $menu = $lp->loadMenu();
	my $categoriesTosearch = $lp->loadCategories();
	my $content;
	my $categoriesSearch = $lp->loadSearchBoatCategory();
	my $fabricantSearch = $lp->loadSearchBoatFabricant();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'boat_menu'}/$categories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);		
}
sub loadWine {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}    
    
	open (FILE, "<$dir/wine.html") or die "cannot open file $dir/wine.html";
	my $categoriesTosearch = $lp->loadCategories();
	my $country = $lp->loadWineCountry();
	my $type = $lp->loadWineType();
	my $cepage = $lp->loadWineCepage();
	my $selectionIndex = $tableArticle->loadWineIndex();
	my $selection = $tableArticle->loadWineByIndex();
	my $menu = $lp->loadMenu();
    	my $countrySearch = $lp->loadSearchWineCountry();
	my $type_de_vinSearch = $lp->loadSearchWineType();
	my $regionSearch = $lp->loadSearchWineCepage();
	my $usedSearch = $lp->loadUsedOrNew();
	my $fabricantSearch = $lp->loadSearchWineFabricant();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgiloadWineTypes?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'show'}/$search/g;	    
	    s/\$SELECT{'wine_country'}/$country/g;
	    s/\$SELECT{'wine_cat'}/$cepage/g;
	    s/\$SELECT{'wine_type'}/$type/g;
	    s/\$SELECT{'country_search'}/$countrySearch/g;
	    s/\$SELECT{'type_de_vin_search'}/$type_de_vinSearch/g;
	    s/\$SELECT{'fabricant_search'}/$fabricantSearch/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);	
	
}

sub loadInstruments {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}    
	open (FILE, "<$dir/muzik_instruments.html") or die "cannot open file $dir/muzik_instruments.html";
	my $categories = $lp->loadInstrumentCategory();
	my $subcategories = $lp->loadInstrumentSubCategory();
	my $selectionIndex = $tableArticle->loadInstrumentsIndex ();
	my $selection = $tableArticle->loadInstrumentsByIndex();
	my $categoriesTosearch = $lp->loadCategories();
	my $categoriesSearch = $lp->loadSearchInstrumentsCategory();
	my $subcategoriesSearch = $lp->loadSearchInstrumentsSubCategory();
	my $fabricantSearch =   $lp->loadSearchWatchFabricant();
	my $usedSearch = $lp->loadUsedOrNew();	
	my $menu = $lp->loadMenu();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'instru_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'instru_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'instru_cat'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcategories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
            s/\$SELECT{'category_search'}/$categoriesSearch/g;
	    s/\$SELECT{'subcategory_search'}/$subcategoriesSearch/g;
	    s/\$SELECT{'fabricants_search'}/$fabricantSearch/g;
	    s/\$ARTICLE{'used_search'}/$usedSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);	
}

sub loadCollections {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}    
    	my $categoriesSearch = $lp->loadSearchCollectionCategory();
		
	my $categories = $lp->loadCollectionCategories();
	my $selectionIndex = $tableArticle->loadCollectionIndex();
	my $selection = $tableArticle->loadCollectionByIndex();
	my $categoriesTosearch = $lp->loadCategories();
	my $fabricantSearch = $lp->loadSearchCollectionFabricant();
	my $usedSearch = "";#$lp->loadUsedOrNew();
	
	my $menu = $lp->loadMenu();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	open (FILE, "<$dir/collection.html") or die "cannot open file $dir/collection.html";	
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'collection_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'collection_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'collection_cat'}/$categories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);	
}

sub loadCdVinylMixtape {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
    
	open (FILE, "<$dir/cd_vinyl_mixtape.html") or die "cannot open file $dir/cd_vinyl_mixtape.html";    	
	my $categories = $lp->loadCdVinylMixTapeCategories();
	my $subcategories = $lp->loadCdVinylMixTapeSubCategories();
	my $selectionIndex = $tableArticle->loadCdVinylMixTapeIndex();
	my $selection = $tableArticle->loadCdVinylMixTapeByIndex();
	my $categoriesTosearch = $lp->loadCategories();
    	my $categoriesSearch = $lp->loadSearchMuzikCategories();
	my $subcategoriesSearch = $lp->loadSearchCdVinylMixTapeSubCategories();
	my $fabricantSearch =   $lp->loadSearchCdProperties();
	my $usedSearch = $lp->loadUsedOrNew();	
	my $menu = $lp->loadMenu();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'cd_vinyl_mixtape'}/$categories/g;
	    s/\$SELECT{'sub_cd_vinyl_mixtape'}/$subcategories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
            s/\$SELECT{'cd_vinyl_mixtape_search'}/$categoriesSearch/g;
	    s/\$SELECT{'sub_cd_vinyl_mixtape_search'}/$subcategoriesSearch/g;
	    s/\$ARTICLE{'cd_properties_search'}/$fabricantSearch/g;
	    s/\$ARTICLE{'used_search'}/$usedSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
}
sub loadMoto {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
	
    
      	my $u = $query->param("u");
	my $categories = $lp->getMotoSubCategory();
	my $categoriesTosearch = $lp->loadCategories();
	my $subcategoriesSearch = $lp->loadSearchMotoSubCategories();
	my $fabricantSearch = $lp->loadMotoFabricant();
	my $usedSearch = $lp->loadUsedOrNew();
	my $properties = $lp->loadMotoSearchProperties();	
	open (FILE, "<$dir/moto.html") or die "cannot open file $dir/moto.html";    	
	my $selectionIndex = $tableArticle->loadMotoIndex();
	my $selection = $tableArticle->loadMotoByIndex();
	my $menu = $lp->loadMenu();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'moto_index'}/$selectionIndex/g;;
	    s/\$ARTICLE{'moto_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'moto_subcat'}/$categories/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcategory'}/$subcategoriesSearch/g;
	    s/\$SELECT{'fabricant'}/$fabricantSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$ARTICLE{'properties'}/$properties/g;	    
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
}

sub loadAnimal {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}    
	my $u = $query->param("u");
      	my $categories = $lp->getAnimalCategories();
	my $subcategories = $lp->loadAnimalSubCategory();
	my $categoriesTosearch = $lp->loadCategories();	
	my $index = $tableArticle->loadAnimalIndex();;
	my $table = $tableArticle->loadAnimalByIndex();;
	my $menu = $lp->loadMenu();
	my $categoriesSearch = $lp->loadSearchAnimalCategories();
	my $subcategoriesSearch = $lp->loadSearchAnimalSubCategories();
	my $fabricantSearch =   $lp->loadSearchAnimalFabricants();
	my $usedSearch = $lp->loadUsedOrNew();
	
	my $content;
	$ARTICLE{'image_pub'} = loadPublicite();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	open (FILE, "<$dir/animal.html") or die "cannot open file $dir/animal.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'animal_cat'}/$categories/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SELECT{'animal_subcat'}/$subcategories/g;	    
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;	    
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
	
}


sub loadJardin {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
	my $categoriesSearch = $lp->loadSearchJardinCategory();
	my $subcategoriesSearch = $lp->loadSearchJardinSubCategory();
	my $fabricantSearch =   $lp->loadSearchJardinFabricant();
	my $usedSearch = $lp->loadUsedOrNew();    
    
	my $u = $query->param("u");
	my $categories = $lp->loadHabitatJardinCategory();
	my $subcategories = $lp->loadHabitatJardinSubCategory();
      	my $categoriesTosearch = $lp->loadCategories();
	open (FILE, "<$dir/jardin.html") or die "cannot open file $dir/jardin.html";    	
	my $selectionIndex = $tableArticle->loadJardinIndex();;
	my $selection = $tableArticle->loadJardinByIndex();;
	my $menu = $lp->loadMenu();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'instru_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'instru_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;	    
	    s/\$SELECT{'jardin_category'}/$categories/g;
	    s/\$SELECT{'jardin_subcat'}/$subcategories/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;

	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;	    

	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
	
}


sub loadAutomobile {
	my $u = $query->param("u");
	my $categories = $lp->getCarCategory();
	my $subcategoriesSearch = $lp->loadSearchCarSubcategories();	
	my $propertiesSearch = $lp->loadAutoSearchProperties();
	my $fabricantSearch = $lp->loadSearchCarFabricant();
	my $usedSearch = $lp->loadUsedOrNew();
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
      	open (FILE, "<$dir/auto.html") or die "cannot open file $dir/auto.html";    	
	my $categoriesTosearch = $lp->loadCategories();
	my $selectionIndex = $tableArticle->loadAutomobileIndex();;
	my $selection = $tableArticle->loadAutomobileByIndex();;
	my $menu = $lp->loadMenu();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'auto_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'auto_table'}/$selection/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'auto_cat'}/$categories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SELECT{'subcategory}/$subcategoriesSearch/g;
	    s/\$SELECT{'fabricant'}/$fabricantSearch/g;
	    s/\$ARTICLE{'properties'}/$propertiesSearch/g;
	    s/\$ARTICLE{'used'}/$usedSearch/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
	
}

sub loadWatch {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
	
	my $categoriesSearch = $lp->loadSearchWatchCategory();
	my $subcategoriesSearch = $lp->loadSearchWatchSubCategory();
	my $fabricantSearch =   $lp->loadSearchWatchFabricant();
	my $usedSearch = $lp->loadUsedOrNew();    
	my $u = $query->param("u");
	my $categories = $lp->loadWatchCategory();
	my $subcategories = $lp->loadWatchSubCategory ();
      	open (FILE, "<$dir/watch.html") or die "cannot open file $dir/watch.html";    	
	my $selectionIndex = $tableArticle->loadWatchIndex();;
	my $categoriesTosearch = $lp->loadCategories();
	my $selection = $tableArticle->loadWatchByIndex();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $menu  = $lp->loadMenu();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'watch_menu'}/$categories/g;
	    s/\$SELECT{'watch_subcat'}/$subcategories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;	    
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
	
}

sub loadAstrologie {
      	open (FILE, "<$dir/astro.html") or die "cannot open file $dir/astro.html";
	my $categories = $lp->loadAstroCategory();
	my $subcategories = $lp->loadAstroSubCategory();
	my $selectionIndex = $tableArticle->loadAstrologieIndex();
	my $selection = $tableArticle->loadAstologieByIndex();
	my $categoriesTosearch = $lp->loadCategories();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $menu = $lp->loadMenu();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'astro_cat'}/$categories/g;
	    s/\$SELECT{'astro_subcat'}/$subcategories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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
sub loadWear {
    	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
      	open (FILE, "<$dir/wear.html") or die "cannot open file $dir/wear.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	my $categories = $lp->getWearSex();
	my $categoriesTosearch = $lp->loadCategories();
	my $wear_categories = $lp->getWearType();
	my $index = $tableArticle->loadWearIndex();
	my $table = $tableArticle->loadWearByIndex();
	my $propertiesSearch = $lp->loadSearchWearProperties();
    	my $categoriesSearch = $lp->loadSearchWearCategories();
	my $subcategoriesSearch = $lp->loadSearchWearSubCategories();
	my $fabricantSearch = $lp->loadSearchWearFabricants();
	my $usedSearch = $lp->loadUsedOrNew();
	
	my $content;
	$ARTICLE{'image_pub'} = loadPublicite();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcategory'}/$subcategoriesSearch/g;
    	    s/\$SELECT{'fabricant'}/$fabricantSearch/g;
	    s/\$SELECT{'properties'}/$propertiesSearch/g;
	    s/\$SELECT{'used'}/$usedSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$SELECT{'wear_sex'}/$categories/g;
	    s/\$ARTICLE{'index_table'}/$index/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$ARTICLE{'news'}/$table/g;
	    s/\$SELECT{'wear_category'}/$wear_categories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
}

sub loadParfum {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
	my $u = $query->param("u");
    	open (FILE, "<$dir/parfum.html") or die "cannot open file $dir/parfum.html";    	
	my $selectionIndex = $tableArticle->loadParfumIndex();
	my $selection = $tableArticle->loadParfumByIndex();
	my $menu = $lp->loadMenu();
	my $categoriesTosearch = $lp->loadCategories();
	my $categories = $lp->loadParfumCategory();
	my $subcategories = $lp->loadParfumSubCategory();
	my $categoriesSearch = $lp->loadSearchParfumCategory();
	my $subcategoriesSearch = $lp->loadSearchParfumSubCategory();
	my $fabricantSearch =   $lp->loadSearchParfumFabricant();
	my $usedSearch = $lp->loadUsedOrNew();
    
  	my $article = $query->param("article");
	my $index = $tableArticle->loadParfumIndex();
	my $table = $tableArticle->loadParfumByIndex();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;	    
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'parfum_menu'}/$categories/g;
	    s/\$SELECT{'sub_menu'}/$subcategories/g;
	    s/\$ARTICLE{'index'}/$selectionIndex/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'table'}/$selection/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$SELECT{'used'}/$usedSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$u/$u/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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
sub loadArtAndDesign {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
	
    	open (FILE, "<$dir/art_design.html") or die "cannot open file $dir/art_design.html";    	
	my $categories = $lp->loadArtCategory();
	my $categoriesTosearch = $lp->loadCategories();
	my $subcategories = $lp->loadArtSubCategory();
	my $selectionIndex = $tableArticle->loadArtAndDesignIndex();;
	my $selection = $tableArticle->loadArtAndDesignByIndex();
	my $menu = $lp->loadMenu();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $categoriesSearch = $lp->loadSearchArtCategory();
	my $subcategoriesSearch = $lp->loadSearchArtSubCategory();
	my $fabricantSearch =   $lp->loadSearchArtFabricant();
	my $usedSearch = $lp->loadUsedOrNew();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'art_cat'}/$categories/g;
	    s/\$SELECT{'art_subcat'}/$subcategories/g;	    
	    s/\$ARTICLE{'art_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'art_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'auteur'}/$fabricantSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
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

sub loadBaby {
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}
    
    	open (FILE, "<$dir/bebe.html") or die "cannot open file $dir/bebe.html";    	
	my $categories = $lp->getBabyCategory();
	my $categoriesTosearch = $lp->loadCategories();
	my $subcategories = $lp->getBabySubCategory();
	my $selectionIndex = $tableArticle->loadArticleBabyIndex();;
	my $selection = $tableArticle->loadBabyByIndex();;
	my $menu = $lp->loadMenu();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $categoriesSearch = $lp->loadSearchBabyCategory();
	my $subcategoriesSearch = $lp->loadSearchBabySubCategory();
	my $fabricantSearch = $lp->loadSearchBabyFabricant();
	my $usedSearch= "";#$lp->loadUsedOrNew();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'bb_cat'}/$categories/g;
	    s/\$SELECT{'bb_subcat'}/$subcategories/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'bb_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'bb_table'}/$selection/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'fabricant'}/$fabricantSearch/g;
	    s/\$SELECT{'used'}/$usedSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;	    
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;		
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
    
}

sub loadLingerie {
	my $article = $query->param("article");
	my $categoriesSearch = $lp->loadSearchLingerieCategory();
	my $subcategoriesSearch = $lp->loadSearchLingerieSubCategory();
	my $fabricantSearch = $lp->loadSearchLingerieFabricant();
	my $usedSearch= $lp->loadUsedOrNew();
	my $show_popup = $query->param("show_popup");
	my $search;
	if ($show_popup  eq "true") {
	    #code
	    $search .= "block";
	} else {
	    $search .= "none";
	}

	my $u = $query->param("u");
    	open (FILE, "<$dir/lingerie.html") or die "cannot open file $dir/lingerie.html";
	my $categoriesTosearch = $lp->loadCategories();
	my $categories = $lp->loadLingerieCategory();
	my $subcategories = $lp->loadLingerieSubCategory();
	my $selectionIndex = $tableArticle->loadLingerieIndex();;
	my $selection = $tableArticle->loadLingerieByIndex();;
	my $menu = $lp->loadMenu();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'art_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'art_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'lingerie_cat'}/$categories/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$SELECT{'lingerie_subcat'}/$subcategories/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$SELECT{'category'}/$categoriesSearch/g;
	    s/\$SELECT{'subcat'}/$subcategoriesSearch/g;
	    s/\$SELECT{'fabricant'}/$fabricantSearch/g;
	    s/\$ARTICLE{'show'}/$search/g;
	    s/\$SELECT{'used'}/$usedSearch/g;	    
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
    
}
sub loadRegister {
   open (FILE, "<$dir/register.html") or die "cannot open file $dir/register.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	my $categories_account = $lp->loadRegisterTypeAccount();
	my $countries = $lp->loadRegisterCountry2();
	my $time = $lp->loadRegisterTime();
	my $categoriesTosearch = $lp->loadCategories();
	my $price = $lp->loadRegisterPrice();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;    
	    s/\$ACCOUNT_TYPE/$categories_account/g;
	    s/\$COUNTRY/$countries/g;
	    s/\$SELECT{'time'}/$time/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SELECT{'price'}/$price/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);
    
}

sub loadAbout {
    	open (FILE, "<$dir/about.html") or die "cannot open file $dir/about.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $categoriesTosearch = $lp->loadCategories();
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	$ARTICLE{'image_pub'} = loadPublicite();
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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

sub loadMyAccount {
	my $u = $query->param("u");
	
	my $encrypt =  &string2hex(&RC4($decypted,$the_key));
	my $categoriesTosearch = $lp->loadCategories();
	my $cookie_in = $query->cookie("USERNAME"); 
	my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
	if($decrypted) 
	{ 
	  
	 
	($VALUE{'username'})= $db->sqlSelect("nom_utilisateur",
					     "personne","nom_utilisateur = '$decrypted'");	
	if ($VALUE{'username'}) {
	
	    open (FILE, "<$dir/myaccount.html") or die "cannot open file $dir/myaccount.html";    	
	    my $selectionIndex = $articleClass->loadArticleSelection();;
	    my $selection = $articleClass->viewArticleSelectionByIndex();;
	    my $menu = $lp->loadMenu();
	    my $content;
	    $ARTICLE{'image_pub'} = loadPublicite();

	    
	    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    while (<FILE>) {	
		s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
		s/\$LANG/$lang/g;
		s/\$ERROR{'([\w]+)'}//g;
		s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
		s/\$ARTICLE{'best_offers_table'}/$selection/g;
		s/\$ARTICLE{'main_menu'}/$menu/g;
		s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
		s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
		s/\$u/$encrypt/g;
		s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
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
	    
	}}
	else {
	    print "Location: $host/cgi-bin/recordz.cgi?lang=$lang&page=login&session=$session_id\n\n";
	}
}
sub loadPersonalData {
    	open (FILE, "<$dir/personal_data.html") or die "cannot open file $dir/personal_data.html";    	
	my $menu = $lp->loadMenu();
	my $content;
	$session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});
        my $test = $session->param("username");
	my $username = $query->param("u");
	my $categoriesTosearch = $lp->loadCategories();
	my $cookie_in = $query->cookie('USERNAME');
	my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
	if($decrypted) 
	{ 

#	if ($username) {
	    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		($VALUE{'first_name'},$VALUE{'name_per'},
		 $VALUE{'adress_name'}, $VALUE{'city'},		 
		 $VALUE{'npa'}, $VALUE{'phone_number'},
		 $VALUE{'email'},$VALUE{'user_password'})= $db->sqlSelect("prenom, nom,adresse,ville, npa, no_telephone, email,mot_de_passe",
					     "personne","nom_utilisateur = '$decrypted'");	
    		open (FILE, "<$dir/personal_data.html") or die "cannot open file $dir/personal_data.html";
	    
		my $menu = $lp->loadMenu();
		my $cats = $articleClass->getCat();
		while (<FILE>) {
		    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
		    s/\$VALUE{'first_name'}/$VALUE{'first_name'}/g;
		    s/\$VALUE{'name_per'}/$VALUE{'name_per'}/g;
		    s/\$OPTIONS{'categories'}/$cats/g;
		    s/\$ARTICLE{'main_menu'}/$menu/g;
		    s/\$ARTICLE{'user_password'}/$VALUE{'user_password'}/g;
		    s/\$VALUE{'adress_name'}/$VALUE{'adress_name'}/g;
		    s/\$VALUE{'city'}/$VALUE{'city'}/g;
		    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
		    s/\$VALUE{'npa'}/$VALUE{'npa'}/g;
		    s/\$VALUE{'phone_number'}/$VALUE{'phone_number'}/g;
		    s/\$VALUE{'email'}/$VALUE{'email'}/g;
		    s/\$LANG/$lang/g;
		    s/\$ARTICLE{'search'}//g;
		    s/\$u/$encrypt/g;
		    s/\$ERROR{'all_label'}/$ERROR{'all_label'}/g;
		    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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
	} else {
		loadLogin();
	}
}


sub loadMyEnchere {
    	open (FILE, "<$dir/myenchere.html") or die "cannot open file $dir/myenchere.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	my $categoriesTosearch = $lp->loadCategories();
	my $username = $query->param("u");
	my $content;
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    #s/\$SELECT{'depot'}/$string3/g;
	    #s/\$IMG_NEW/$img_p/g;
	    #s/\$ARTICLE{'best_offers_index'}/$string1/g;	    
	    #s/\$ARTICLE{'best_offers_table'}/$string2/g;
	    #s/\$OPTIONS{'categories'}/$cats/g;
	    #s/\$ARTICLE{'search'}//g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    #s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$u/$username/g;
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

sub loadPublicite {
        my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my ($y, $m, $d, $hh, $mm, $ss) = (localtime)[5,4,3,2,1,0]; $y += 1900; $m++;
    if ($m < 10) {
	 $m = "0$m";
    }
    $lang = $query->param("lang") ;
    my $iso_now = "$y-$m-$d";
    my $dt = DateTime->last_day_of_month( year => $year+1900, month => $mon+1 );
	    while ( $dt->day_of_week >= 6 ) {
		$dt->subtract( days => 1 )
		}
	    $enchere_date_end =  $dt->ymd;

        my $enchere_duration_rest =  $lp->timeDiff("$iso_now + 30","$enchere_date_end"); 
	my ($c) = $db->sqlSelectMany("pochette,nom,id_article","article","pub = 1 AND pub_date_start <= '$iso_now' AND pub_date_end >= '$iso_now' ORDER BY Rand() LIMIT 0,4");
	my $i = 0;
	while( ($ARTICLE{'image_url'},$ARTICLE{'nom'},$ARTICLE{'id_article'})=$c->fetchrow()) {
	    $ARTICLE{'image_pub'}.= "<img src='$ARTICLE{'image_url'}'</img>&nbsp;&nbsp;<a href=\"$host/cgi-bin/recordz.cgi?lang=$lang&action=detailother&article=$ARTICLE{'id_article'}\"</a>$ARTICLE{'nom'}&nbsp;&nbsp;";	    
	    $i += 1;
	}
	$ARTICLE{'image_pub'} .= "<br/>";
return $ARTICLE{'image_pub'};
}

sub loadMainPage {
   print "Content-Type: text/html\n\n";
   print "loadMain";
}
sub loadMainPage2 {
	my $type_p = "";
	if ($query->param("saw") ne "") {
	    $type_p = $query->param("saw");
	}
	
    	$type_p = $query->param("saw");
	my $string1 = "";
	my $string2 = "";
	
	if ($type_p eq 'lasthour') {
	    $string1 = $tableArticle->loadARTICLELastHour();
	    $string2 = $tableArticle->viewARTICLELastHourByIndex();
	    #$img_p = "<img src=\"../images/last_hour_$lang.gif\" alt=\"\"/>";
	}elsif ($type_p eq 'onlyench') {
	    $string1 = $tableArticle->viewARTICLEOnlyEnchhopIndex();
	    $string2 = $tableArticle->loadARTICLEOnlyEnchByIndex();
	    #$img_p = "<img src=\"../images/les_encheres_$lang.gif\" alt=\"\"/>";
	}elsif ($type_p eq 'onlynew') {
    	    $string1 = $tableArticle->viewARTICLEFromShopIndex();
	    $string2 = $tableArticle->loadARTICLEFromShopByIndex();
	    #$img_p = "<img src=\"../images/des_boutiques_$lang.gif\" alt=\"\"/>";	    	
	} else {
	    $string1 = $articleClass->loadArticleSelection();;
	    $string2 = $articleClass->viewArticleSelectionByIndex();;
    	}
  	my $u = $query->param("u");
    	open (FILE, "<$dir/main.html") or die "cannot open file $dir/main.html";    	
	my $categories = $lp->loadCategories();
	my $menu = $lp->loadMenu();
	my $content;
	$ARTICLE{'image_pub'} = loadPublicite();
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$categories/g;
	    s/\$ARTICLE{'best_offers_index'}/$string1/g;
	    s/\$ARTICLE{'best_offers_table'}/$string2/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$ARTICLE{'names'}/$ARTICLE{'names'}/g;
	    #s/\$u/$u/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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
	
	  




sub loadLogin {
    	open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	
	my $categoriesTosearch = $lp->loadCategories();
	my $content;
	$ARTICLE{'image_pub'} = loadPublicite();
        my $captcha = Authen::Captcha->new(height => 150); # optional. default 35);
	$captcha->expire(5 * 60);
	$captcha->data_folder('/home/alexandre/apache/site/recordz1/upload/');
        $captcha->output_folder('/home/alexandre/apache/site/recordz1/upload/');
	my $md5sum = $captcha->generate_code(5);
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
	    s/\$image/$md5sum/g;
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

sub hex2string {
 my($instring) = @_;
 my($retval,$strlen,$posx);
 $strlen = length($instring);
 for ($posx = 0; $posx < $strlen; $posx=$posx+2) {
  $retval .= chr(hex(substr($instring,$posx,2)));
 }
 return($retval);
}


sub login {
    my  $username = $query->param('user_name') ;
    my $code = $query->param("capmd5");
    my $inline = $query->param("inline");
    my $captcha = Authen::Captcha->new();
    $captcha->data_folder('/home/alexandre/apache/site/recordz1/upload/');
    my $newc = _untaint(md5_hex($inline)); # remove 0-1
    my $md5    = _untaint(md5_hex($code)); # remove 0-
    my $code2 = chop ($code);
    print "md5 $md5";
    print "new captcha $code<br/>";
    if ($newc eq $code) {
    my $u = $query->param("u");
    my $char = "'";
    my  $userpassword = $query->param('user_password');
    $user_assword=~ s/\'//;
    my  $string ="";
    my $encrypted;
    #print "Content-Type: text/html\n\n";
   my  ($user_name,$user_password,$level)= ();
   ($user_name,$user_password,$level)=$db->sqlSelect("nom_utilisateur , mot_de_passe,level",
					     "personne", "nom_utilisateur = '$username' AND mot_de_passe='$userpassword'");
    
	
	if ($user_name && $user_password) {
            my $content;	   
	    $session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});
            $session->expire('+2h');   	    
	    my  $id = $session->id();
    my $encrypted =&string2hex(&RC4($username,$the_key));
	    $session->param( "username", "$user_name");
	    $cookie = CGI::Cookie->new(-name => 'USERNAME',
-value => $encrypted,
-expires => '+3M',
-domain => 'localhost',
-path => '/',
-secure => 1);
	    
	    my $cookie_data = $query->cookie('USERNAME') || 'No Cookie Set';
	    print "Content-Type: text/html\n";
	    print "<h2>Cookie Data: $cookie_data</h2>\n";
	    
	    $session->param( "level", "$level");
	    $session->param("ip", "$current_ip");
	    $session->flush();
	    
	    $articleClass->clearBasket($user_name);
	    my $string4 = $articleClass->weekNews ();
	   my $menu = $lp->loadMenu();
	   my $cats = $articleClass->getCat();
	   my $url = $session->param("url");
	   if ($url) {
		print "Content-Type: text/html\n";
		print "Location: $url\n\n";
		$session->param("url","");			
	   }else {
	    if ($username) {
	    }
	    
	    open (FILE, "<$dir/myaccount.html") or die "cannot open file $dir/myaccount.html";	    	
	    while (<FILE>) {	    
		s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
		s/\$LANG/$lang/g;
		s/\$ERROR{'([\w]+)'}//g;
		s/\$ARTICLE{'main_menu'}/$menu/g;
		s/\$OPTIONS{'categories'}/$cats/g;
		s/\$ARTICLE{'week_news'}/$string4/g;
		s/\$ARTICLE{'news'}/$string/g;
		s/\$LINK{'add_deal'}/$b/g;
		s/\$u/$encrypted/g;
		s/\$SESSIONID/$session_id/g;
		s/\$ARTICLE{'search'}//g;
		$content .= $_;	
	    }
		#$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; 				
		#print "Content-Length: ", length($content) , "\n";
		#print "Content-Encoding: gzip\n" ;		
		print $query->header(-cookie=>$cookie);
		print $content;
	        close (FILE);	    
	   }
	}
    else {
	my $content;
	open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";
	$LINK{'admin'} = "";
	my $string4 = $articleClass->weekNews ();
	my $menu = $lp->loadMenu();
        my $cats = $articleClass->getCat();
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'login_error_label'}/$SERVER{'login_error_label'}/;	    
	    s/\$ERROR{'email_error_label'}//g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$LINK{'admin'}/$LINK{'admin'}/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'week_news'}/$string4/g;	    
	    $content .= $_;	
	}
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
    }
    }else {
	loadLogin();	
    }        

}


sub loadAddArticle {
    open (FILE, "<$dir/add_other2.html") or die "cannot open file $dir/add_other2.html";    	
    #my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );     
    #my  $username  =$session->param("username");
    my $maincat = $query->param("category");
    my $subcat = $query->param("subcat");
    my $entities = '&amp;';
    $subcat =~ s/[&]/$entities/ge;			      

    my $load = $query->param("isencher");
    my $name =$query->param("name");
    my $article =$query->param("article");;
    my $country = $query->param("country");
    my $lieu;
    my $categoriesTosearch = $lp->loadCategories();
    my $departement = $query->param("departement");
    my $u = $query->param("u");
    my $dimension ;
    my $level = 2;#$session->param("level");
    if ($level eq '2') {$LINK{'admin'} = "<a href=\"javascript:void(0)\" class=\"menulink\"  onclick=\"window.open('/cgi-bin/recordz.cgi?lang=$lang&amp;page=cms_manage_article&amp;session=$session_id;','MyWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=800,height=600,left=20,top=20')\">Admin</a>";      }
    else {$LINK{'admin'} = ""; }
    #if ($username) {
	#my  $dir = "C:/indigoperl/apache/htdocs/recordz/";
	my  $string = $lp->getCategoryGo ();
	my $menu = $lp->loadMenu();
	my  $string4;
	my $type_ecran;
	my $payement;
	my $livraison;
	my $informatique_properties;
	my $properties;
	my $fabricant;
	my $isenchere;
	my $carp ;
	my $quantity;
	my $location_or_buy;
	my $location_place;
	if ($maincat) {
	    $string4 = $lp->loadSubCategoriesOther();
	    $string4 =~ s/[&]/$entities/ge;			      
	    }
	my $res = $query->param("isencher");
	if ($res eq 'yes' or $res eq 'Yes' or $res eq 'oui' or $res eq 'Oui' or $res eq 'ya' or $res eq 'Ya') {
		$properties = $lp->loadEnchereProperties();
	}
	$isenchere = $lp->getIsEnchere();
	my  ($subcatID)=$db->sqlSelect("ref_subcategorie", "subcategorie_libelle_langue, langue, libelle", "libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my  ($catID)=$db->sqlSelect("ref_categorie", "categorie_libelle_langue,  langue, libelle", "libelle.libelle = '$maincat' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my $wine_country;
	
	if ($subcatID eq '12') {
		$type_ecran = $lp->loadTypeEcran();
		$dimension = $lp->loadTvDimension();
	}
	if ($catID ne '21' and $catID ne '25' and $catID ne '9'  and $catID ne '38') {		
		$fabricant = $lp->loadFabricant();

	}
	if ($catID eq '9') {
	    $fabricant = $lp->loadEditor();
	}
	
	if ($catID eq '25') {
	    $location_or_buy = $lp->loadIsBuyOrLocation();
	    $location_place = $lp->loadCityLocation();
	    #code
	}
	
	$payement = $articleClass->getConditionPayement();
	$livraison = $articleClass->getConditionLivraison();
	my $wine_region;
	my $cepage;
	my $wine_type;
	my $autor;
	my $year_fabrication;
	if ($catID eq '9') {$autor = $lp->loadAutor();}
	if ($catID eq '27') {
		#pays		
		$wine_country = $lp->loadAddWineCountry();
		$string4= "";
		$wine_region = $lp->loadAddWineRegion();
		$cepage = $lp->loadAddWineCepage();
		$wine_type = $lp->loadAddWineType();
		$year_fabrication = $lp->loadWineYear();
	}
	my $used;
	if ($load eq "Non" || $load eq "No" || $load eq "Nein" || $load eq "Ni") {
	  $quantity = $lp->loadQuantity();
	}
	
	if ($catID ne '5') {		
		$used = $lp->loadUsedOrNew();
	}
	
	if ($catID eq '5' or $catID eq '6') {
		$carp = $lp->getCarProperties();
		$used = $lp->loadUsedOrNew();
	}
	my $game_type;
	if ($catID eq '29') {
	    $game_type = $lp->loadAddGamesType();
	}
	
	if ($subcatID eq '75' or $subcatID eq '78'  or $subcatID eq '79'  or $subcatID eq '80') {
	    $informatique_properties = $lp->loadInfoPcProperties();}
	my $dvd_properties;
	if ($catID eq '38') {
	    $dvd_properties = $lp->loadDvdProperties();
	}
	my $offshore_properties;
	if ($catID eq '94') {
	    $offshore_properties = $lp->loadOffshoreProperties();}
	my $size;
	if ($subcatID eq '311' or $subcatID eq '1' or $subcatID eq '2' or $subcatID eq '3' or $subcatID eq '4' or $subcatID eq '6' or $subcatID eq '28' or $subcatID eq '29' or $subcatID eq '30' or $subcatID eq '32') {
	    $size = $lp->loadWearSize($ARTICLE{'size'});
	}
	my $content;my $cats = $articleClass->getCat();
	my $test = "";
	my $test2 = "";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;
	    s/\$ERROR{'name_value_required'}/$test/g;
	    s/\$ERROR{'description_value_required'}/$test2/g;
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'condition_payement'}/$payement/g;
	    s/\$SELECT{'condition_livraison'}/$livraison/g;
	    s/\$ARTICLE{'informatique_properties'}/$informatique_properties/g;
	    s/\$SELECT{'isenchere'}/$isenchere/g;
	    s/\$SELECT{'offshore_properties'}/$offshore_properties/g;
	    s/\$SELECT{'type_ecran'}/$type_ecran/g;
	    s/\$LINK{'admin'}/$LINK{'admin'}/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'dvd_properties'}/$dvd_properties/g;
	    s/\$SELECT{'wine_country'}/$wine_country/g;
	    s/\$SELECT{'cepage'}/$cepage/g;
	    s/\$ARTICLE{'year_fabrication'}/$year_fabrication/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$SELECT{'location_place'}/$location_place/g;
	    s/\$SELECT{'lieu'}/$lieu/g;
	    s/\$SELECT{'auto_properties'}/$carp/g;
	    s/\$SELECT{'dimension'}/$dimension/g;
	    s/\$ARTICLE{'name'}/$name/g;
	    s/\$ARTICLE{'autor'}/$autor/g;
	    s/\$ARTICLE{'size'}/$size/g;
	    s/\$SELECT{'game_type'}/$game_type/g;
	    s/\$SELECT{'quantity'}/$quantity/g;
	    s/\$SELECT{'enchere_fabricant'}/$fabricant/g;
	    #s/\$ARTICLE{'description'}/$description/g;
	    #s/\$ARTICLE{'price'}/$price/;
	    s/\$SELECT{'location_or_buy'}/$location_or_buy/g;
	    s/\$SELECT{'wine_region'}/$wine_region/g;
	    s/\$SELECT{'wine_type'}/$wine_type/g;
	    s/\$u/$u/g;
	    s/\$SELECT{'subcat'}/$string4/g;
	    s/\$SELECT{'dimension'}//g;
	    s/\$SELECT{'enchere_properties'}/$properties/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$OPTIONS{'category'}/$string/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n"; 
	print $content;
	
        close (FILE);    
    }
 #   else {
#	login();
#    }

sub detailOther {
	my $error = shift || '';
   $lang = $query->param("lang") ;	
	my $article = $query->param("article");	
	my $nb_article = $query->param("nb_article");
	my @enchere = $db->sqlSelect("prix","article","id_article = $article");
	my $price = $enchere[0];
	
	my @payment_mode = $db->sqlSelect("ref_condition_payement","article","id_article = $article");
	my $payment_mode_ref = $payment_mode[0];
	my @payment = $db->sqlSelect("libelle.libelle","condition_payement_libelle_langue,libelle,langue","ref_condition_payement = '$payment_mode_ref' AND condition_payement_libelle_langue.ref_libelle = libelle.id_libelle AND condition_payement_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my $payment_libelle = $payment[0];
	
	my @condition_livraison_mode = $db->sqlSelect("ref_condition_livraison","article","id_article = $article");
	my $condition_livraison_ref = $condition_livraison_mode[0];
	my @condition_livraison = $db->sqlSelect("libelle.libelle","condition_livraison_libelle_langue,libelle,langue","ref_condition_livraison = $condition_livraison_ref AND condition_livraison_libelle_langue.ref_libelle = libelle.id_libelle AND condition_livraison_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my $condition_livraison_libelle = @condition_livraison[0];
	my @buy_waiting_counter = $db->sqlSelect("quantite", "article", "id_article = $article");
	my $buy_waiting_counter = @$buy_waiting_counter[0];
    $error = $query->param("error");
    #if ($error) {$error = "Plus petit";}
    my  $article = $query->param ('article');
    #$article=~ s/[^A-Za-z0-9 ]//;
    my $option = $query->param("option");
    my $viewcommentaire = $query->param("viewcommentaire");
    my $u = $query->param("u");
    my $index;my $table;
    my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
    my  $username = $session->param("username");
    my $b;
    my $user_password = $query->param("password");
    if ($user_password ) {
	#code
    }
    	my $article = $query->param("article");
	my @enchere = $db->sqlSelect("MAX(prix)", "enchere", "ref_article = $article");
	my $last_enchere = $enchere[0];
	if ($last_enchere eq '') {
		@enchere = $db->sqlSelect("prix","article","id_article = $article");
		$last_enchere = $enchere[0];
	}

    my $images = $articleClass->getImagesForDetails();
    if ($viewcommentaire eq '1') {
	$index = $articleClass->loadCommentaireIndex();
	$table = $articleClass->viewCommentaireByIndex();}
    my $enchere;
    my  @f = $db->sqlSelect("enchere ", "article","id_article= '$article'");my  $is_enchere = $f[0];
    my $links;
    my $counter = $articleClass->getArticleDetailCount();
    my $enchere_count = $articleClass->getArticleEnchereCount();
    my $car_properties;
    my  @xy = $db->sqlSelect("ref_categorie ", "article","id_article= '$article'");
    my  $ref_categorie = $xy[0];
    my  @country = $db->sqlSelect("ref_pays ", "article","id_article= '$article'");
    my  $ref_coutry = $country[0];
    my $enchere_duration_rest;
    my $enchere_counter_table;
       
    my $param_immobilier = " ,nb_piece,surface_habitable, superficie_terrain, annee_construction, article.ref_canton, lieu, article.adresse, article.npa, ref_location_ou_achat, ref_departement";
    my $param_immobilier_to_add .= $param_immobilier;
    my $tsable_immobilier;
    my $ref_immobilier;
    my $content;
    my $quantity;
    my $quantity_wanted; my $style;
    my $encherereur;my $enchereprice;my $deliver_mode;my $payement_mode;my $last_offer;
    my  ($enchere_time_end)=$db->sqlSelect(" enchere_date_fin ", "article", "id_article = '$article'");
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my ($y, $m, $d, $hh, $mm, $ss) = (localtime)[5,4,3,2,1,0]; $y += 1900; $m++;
    
    if ($m < 10) {
	 $m = "0$m";
    }
    
    my $iso_now = "$y-$m-$d $hh:$mm:$ss";
    $enchere_duration_rest =  $lp->timeDiff("$enchere_time_end","$iso_now");        
    open (FILE, "<$dir/detail_other.html") or die "cannot open file $dir/detail_other.html";
	$session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});

    my $string4 = $articleClass->weekNews ();my $menu = $lp->loadMenu();my  %ARTICLE = (); my $cats = $articleClass->getCat();
    my $immobilier_properties;my $fabricant;my $dimension;my $payement_and_deliver_mode;my $informatique_properties;
    
    ($ARTICLE{'id_article'},$ARTICLE{'name'},$ARTICLE{'author'}, $ARTICLE{'label'},
     $ARTICLE{'price'}, $ARTICLE{'date_stock'},$ARTICLE{'ref_categorie_libelle'},$ARTICLE{'pochette'},
     $ARTICLE{'vendeur'},$ARTICLE{'end_enchere'},$ARTICLE{'ref_subcategorie'},$ARTICLE{'dimension'},
     $ARTICLE{'processeur'},$ARTICLE{'ram'},$ARTICLE{'disque_dur'},$ARTICLE{'subcategorie.ref_libelle'},
     $ARTICLE{'quantity_counter'},$ARTICLE{'ref_country'},$ARTICLE{'longueur'},$ARTICLE{'largeur'},
     $ARTICLE{'consomation'},$ARTICLE{' nb_cheveaux '},$ARTICLE{'acteurs'},$ARTICLE{'duree'},
     $ARTICLE{'realisateur'},$ARTICLE{'size'},
     $ARTICLE{'ref_cepage'},$ARTICLE{'ref_pays_region_vin'},$ARTICLE{'ref_type_de_vin'},$ARTICLE{'provenance'},
     $ARTICLE{'marque'},$ARTICLE{'year'},$ARTICLE{'size'},$ARTICLE{'ref_etat'},		     
     $ARTICLE{'wat'},$ARTICLE{'nb_cylindre'},$ARTICLE{'nb_piece'},$ARTICLE{'surface_habitable'},
     $ARTICLE{'superficie_terrain'},$ARTICLE{'annee_construction'},$ARTICLE{'ref_canton'},$ARTICLE{'lieu'},
     $ARTICLE{'adresse'},$ARTICLE{'npa'}, $ARTICLE{'ref_location_ou_achat'},$ARTICLE{'ref_departement'} )= $db->sqlSelect("DISTINCT id_article,article.nom,
						            auteur,label,prix, date_stock,
							    categorie_libelle_langue.ref_categorie,pochette,personne.nom_utilisateur,enchere_date_fin,
							    article.ref_subcategorie,dimension,processeur,ram,
							    disque_dur,subcategorie_libelle_langue.ref_subcategorie,article.quantite,article.ref_pays,
							    longueur,largeur,consomation, nb_cheveaux,
							    acteurs,duree,realisateur,taille,
							    ref_cepage, ref_pays_region_vin,
							    ref_type_de_vin,ref_provenance,marque,article.annee,
							    taille,article.ref_etat,wat,nb_cylindre
							    $param_immobilier_to_add",
							    "article,met_en_vente,categorie_libelle_langue,personne,subcategorie_libelle_langue ",
                                                            "ref_article = id_article  and id_article ='$article' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND met_en_vente.ref_article = id_article AND met_en_vente.ref_vendeur = id_personne AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie");
    
    my $button_visite = '';
    if ($ARTICLE{'ref_etat'} eq '') {
	$ARTICLE{'ref_etat'} .= "0"
    }
    my $button;
    if ($ref_categorie eq '25') {
	#print "Content-Type: text/html\n\n";
	#print "$ARTICLE{'surface_habitable'},$ARTICLE{'nb_piece'},$ARTICLE{'superficie_terrain'},$ARTICLE{'annee_construction'},$ARTICLE{'ref_canton'},$ARTICLE{'lieu'}, $ARTICLE{'ref_libelle'},$ARTICLE{'npa'}, $ARTICLE{'ref_location_ou_achat'},$ARTICLE{'ref_departement'}";
      $immobilier_properties =  $articleClass->getImmoProperties($ARTICLE{'nb_piece'},$ARTICLE{'surface_habitable'}, $ARTICLE{'superficie_terrain'},$ARTICLE{'annee_construction'},$ARTICLE{'ref_canton'},$ARTICLE{'lieu'}, $ARTICLE{'adresse'},$ARTICLE{'npa'}, $ARTICLE{'ref_location_ou_achat'},$ARTICLE{'ref_departement'} );
      
      $button_visite .= $lp->loadButtonEncherir($ARTICLE{'id_article'});
      $button_visite .= "<input type=\"button\" value=\"$SERVER{'ask_visit'}\" onclick=\"window.open('/cgi-bin/ask_visit.pl?lang=$lang&amp;page=askvisit&article=$article;','MySearchWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=790,height=550,left=0,top=0')\"></input>";
            #$string .= "<input type=\"button\" value=\"Enchérir\" onclick=\"window.open('/cgi-bin/recordz.cgi?lang=$lang&amp;page=encherir&amp;session=$session_id&article=$article_id;','MySearchWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=590,height=250,left=0,top=0')\"></input>";
    }
    
    my $value;if ($is_enchere eq '1') {
	$value = 1;
	$button = $lp->loadButtonEncherir($ARTICLE{'id_article'});
	} else {
	$button = $lp->loadButtonAcheter($ARTICLE{'id_article'});
    }	
    my $msn;
    
    my $skype_link; if ($ARTICLE{'skype'}) {$skype_link = $lp->loadSkypeLink($ARTICLE{'skype'}); }
    my $wine_properties;my $size;
    if ($ref_categorie eq '398' ) {
	
	$fabricant = $lp->loadFabricantProperties($ARTICLE{'marque'},"Label",$value);    }
	elsif ($ref_categorie eq '1' or  $ref_categorie eq '2' or  $ref_categorie eq '3' or  $ref_categorie eq '6' or $ref_categorie eq '7' or $ref_categorie eq '13') {		    		
	    $fabricant = $lp->loadFabricantProperties($ARTICLE{'marque'},'',$value);
	    $size = "";
	
    }elsif ($ref_categorie eq '27') {$wine_properties = $lp->loadWineProperties ($ARTICLE{'ref_cepage'},$ARTICLE{'ref_pays_region_vin'},$ARTICLE{'ref_type_de_vin'},$ARTICLE{'provenance'},$ARTICLE{'year'});}
    my $auteur;
    if ($ref_categorie eq '9') {$auteur = $lp->loadAuteur($ARTICLE{'author'},$ARTICLE{'year'}, $ARTICLE{'marque'}); }
    my $dvd_properties;
   if ($ref_categorie eq '38') {
	$dvd_properties = $lp->loadDvdProperties ($ARTICLE{'acteurs'},$ARTICLE{'realisateur'},$ARTICLE{'year'},$ARTICLE{'duree'});
	my  @xyt = $db->sqlSelect("libelle.libelle ", "subcategorie_libelle_langue,article, libelle","article.id_article= '$article' AND subcategorie_libelle_langue.ref_subcategorie = article.ref_subcategorie and subcategorie_libelle_langue.ref_libelle = libelle.id_libelle");
	my  $subcatname= $xyt[0];$dvd_properties .= $lp->loadDvdGenre ($subcatname);
    }
    
    if ($ref_categorie eq '11') {
    }else {
	if ($ref_categorie ne '13' and $ref_categorie ne '14' and $ref_categorie ne '15' and $ref_categorie ne '21' and $ref_categorie ne '25' and $ref_categorie ne '9' and $ref_categorie ne '38') {
	    $fabricant = $lp->loadFabricantProperties($ARTICLE{'marque'},'',$value);}
	    $payement_and_deliver_mode = $lp->loadPayementModeProperties ();	   
    }
    my $nb_cylindre;
    if ($is_enchere ne '1') {
	#code
    
    
    if ($ref_categorie ne '8' and $ref_categorie ne '25') {
	$quantity = $lp->loadQuantity($ARTICLE{'quantity_counter'});
	#if ($ARTICLE{'quantity_counter'} > 1 and $is_enchere eq '0') {
	#    $quantity_wanted = $lp->loadQuantityWanted();
	#}
    }}
    
    if ($ref_categorie eq '5') {$nb_cylindre = "<tr><td>$SERVER{'nb_cylindre'}</td><td><input type=\"text\" name=\"nb_cylindre\" value=\"$ARTICLE{'nb_cylindre'}\"></td></tr>";    }
    if ($is_enchere eq '0') {if ($ARTICLE{'quantity_counter'} > 1) {
	$last_offer = $lp->loadLastBuyerOfThisArticle();}
	}else {

		$last_offer = $articleClass->loadEnchereLastOffer();
		$enchere = $lp->loadMakeEnchere();
		$enchere_counter_table = $articleClass->getEnchereCounter();
		$enchereprice = $articleClass->getLastEnchereTable();	        
		$encherereur= $articleClass->getLastEnchereurDetail();;		
	}    
    if ($ARTICLE{'ref_subcategorie'} eq '1' or $ARTICLE{'ref_subcategorie'} eq '2' or $ARTICLE{'ref_subcategorie'} eq '3' or $ARTICLE{'ref_subcategorie'} eq '4' or $ARTICLE{'ref_subcategorie'} eq '6' or $ARTICLE{'ref_subcategorie'} eq '28' or $ARTICLE{'ref_subcategorie'} eq '29' or $ARTICLE{'ref_subcategorie'} eq '30' or $ARTICLE{'ref_subcategorie'} eq '32') {$size = $lp->loadWearSize($ARTICLE{'size'});}
    my $wat;
    if ($ARTICLE{'ref_subcategorie'} eq '14') { $wat = $lp->loadWat($ARTICLE{'wat'});};
    if ($ARTICLE{'ref_subcategorie'} eq '12') { $dimension = $lp->loadDimensionOther("$ARTICLE{'dimension'}");}
    if ($ref_categorie  eq '94') { $dimension = $lp->loadDetailOffshoreProperties($ARTICLE{'longueur'},$ARTICLE{'largeur'},$ARTICLE{'consomation'},$ARTICLE{' nb_cheveaux '});}    
    if ($ARTICLE{'ref_subcategorie'} eq '311') {$dimension = $lp->loadSnowboardSize($ARTICLE{'size'});}
    if ($ARTICLE{'ref_subcategorie'} eq '75' or $ARTICLE{'ref_subcategorie'} eq '17' or $ARTICLE{'ref_subcategorie'} eq '18') {
	$informatique_properties = $lp->loadDetailInfoPcProperties($ARTICLE{'processeur'},
							      "$ARTICLE{'disque_dur'}",
							      $ARTICLE{'ram'});
    }
    
    if ($ref_categorie eq '37') {$style = $lp->loadStyle($ARTICLE{'subcat_name'});}
    if ($ref_categorie eq '5') {$car_properties = $lp->getCurrentCarProperties();}my $used;
    if ($ref_categorie eq '37') {$car_properties = $lp->getCurrentMotoProperties();}
    if ($ref_categorie ne '16' and $ref_categorie ne '27') {
	my  @xytz = $db->sqlSelect("libelle.libelle ", "etat_libelle_langue, libelle, langue","ref_etat= $ARTICLE{'ref_etat'} and etat_libelle_langue.ref_libelle = libelle.id_libelle");
	my  $usedname= $xytz[0];
	$used = $lp->loadUsedOrNewDetail($usedname);
    }
    
    
    my $indexLastBuyers = $userAction->loadHistoriqueLastBuyersIndex();
    my $tableLastBuyers = $userAction->loadHistoriqueLastBuyersByIndex();
    my $categoriesTosearch = $lp->loadCategories();
    my @xyz = $db->sqlSelect("libelle.libelle ", "categorie_libelle_langue,article, libelle, langue","article.id_article= '$article' AND categorie_libelle_langue.ref_categorie = $ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle and categorie_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang'");
    my $categorie_libelle = $xyz[0];
    if ($ref_categorie eq '25') {
	$button = "";
	#code
    }
    if ($ARTICLE{'label'} eq "") {
	$ARTICLE{'label'} = " ";
	#code
    }
    my $indexHistorique = $userAction->loadHistoriqueIndex();
    my $tableHistorique = $userAction->loadHistoriqueByIndex();
    
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;
	s/\$LANG/$lang/g;
	s/\$ARTICLE{'immobilier_properties'}/$immobilier_properties/g;
	s/\$ERROR{'quantity'}/$error/g;
	s/\$ARTICLE{'payement_and_deliver_mode'}/$payement_and_deliver_mode/g;
	s/\$ARTICLE{'id_article'}/$ARTICLE{'id_article'}/g;
	s/\$ARTICLE{'category'}/$categorie_libelle/g;
	s/\$ARTICLE{'counter'}/$counter/g;
	s/\$LINK{'enchere'}/$links/g;
	s/\$OPTIONS{'categories'}/$cats/g;
	s/\$OPTIONS{'categories2'}/$categoriesTosearch/g;
	s/\$ARTICLE{'etat'}/$used/g;
	s/\$ARTICLE{'dvd_properties'}/$dvd_properties/g;
	s/\$ARTICLE{'informatique_properties'}/$informatique_properties/g;
	s/\$ARTICLE{'max_enchere'}/$enchereprice/g;
	s/\$ARTICLE{'enchere_last_offer'}/$last_offer/g;
	s/\$ARTICLE{'dimension'}/$dimension/g;
	s/\$ARTICLE{'week_news'}/$string4/g;
	s/\$ARTICLE{'wat'}/$wat/g;
	s/\$ARTICLE{'images'}/$images/g;
	s/\$ARTICLE{'nb_cylindre'}/$nb_cylindre/g;
	s/\$ARTICLE{'size'}/$size/g;
	s/\$ARTICLE{'style'}/$style/g;
	s/\$ARTICLE{'quantity_wanted'}/$quantity_wanted/g;
	s/\$ARTICLE{'quantity_counter'}/$ARTICLE{'quantity_counter'}/g;
	s/\$ARTICLE{'deliver_mode'}/$deliver_mode/g;
	s/\$ARTICLE{'payement_mode'}/$payement_mode/g;
	s/\$ARTICLE{'end_enchere'}/$ARTICLE{'end_enchere'}/g;
	s/\$enchere_duration_rest/$enchere_duration_rest/g;
	s/\$ARTICLE{'vendeur'}/$ARTICLE{'vendeur'}/g;
	s/\$ARTICLE{'enchere'}/$enchere/g;
	s/\$ARTICLE{'wine_properties'}/$wine_properties/g;
	s/\$ARTICLE{'index'}/$index/g;
	s/\$ARTICLE{'skype'}/$skype_link/g;
	s/\$ARTICLE{'autor'}/$auteur/g;
	s/\$ARTICLE{'table'}/$table/g;
	s/\$ARTICLE{'quantity'}/$quantity/g;
	s/\$ARTICLE{'enchere_price_detail'}/$enchereprice/g;
	s/\$ARTICLE{'name'}/$ARTICLE{'name'}/g;
	s/\$ARTICLE{'last_enchere_detail'}/$encherereur/g;
	s/\$ARTICLE{'enchere_properties_counter'}/$enchere_counter_table/g;
	s/\$ARTICLE{'car_properties'}/$car_properties/g;
	s/\$ARTICLE{'main_menu'}/$menu/g;
	s/\$ARTICLE{'fabricant'}/$fabricant/g;
	s/\$LINK{'admin'}/$LINK{'admin'}/g;
	s/\$ARTICLE{'counter_enchere'}/$enchere_count/g;
	s/\$ARTICLE{'description'}/$ARTICLE{'label'}/g;
	s/\$SESSIONID/$session_id/g;
	s/\$ARTICLE{'price'}/$ARTICLE{'price'}/g;
	s/\$ARTICLE{'date_stock'}/$ARTICLE{'date_stock'}/g;
	s/\$ARTICLE{'image_url'}/$ARTICLE{'pochette'}/g;
	s/\$BUTTON{'action'}/$button/g;
	s/\$BUTTON{'ask_visit'}/$button_visite/g;
	s/\$ARTICLE{'buy_waiting_counter'}/$buy_waiting_counter/g;
	s/\$ARTICLE{'price'}/$price/g;
	s/\$ARTICLE{'id_article'}/$article/g;
	s/\$image/$md5sum/g;	
	s/\$ARTICLE{'last_enchere'}/$last_enchere/g;
	s/\$ARTICLE{'condition_de_payement'}/$payment_libelle/g;
	s/\$ARTICLE{'mode_de_livraison'}/$condition_livraison_libelle/g;
	s/\$ARTICLE{'ref_mode_livraison'}/$condition_livraison_ref/g;
	s/\$ARTICLE{'ref_mode_payement'}/$payment_mode_ref/g;
	#s/\$ARTICLE{'image_url2'}/upload/$ARTICLE{'id_article''}/$ARTICLE{'id_article'}
	s/\$u/$u/g;
	s/\$LINK{'add_deal'}/$b/g;
	s/\$ARTICLE{'index_last_buyers'}/$indexLastBuyers/g;
	s/\$ARTICLE{'table_last_buyers'}/$tableLastBuyers/g;
	s/\$ARTICLE{'last_enchere'}/$last_enchere/g;
	s/\$ARTICLE{'historique_index'}/$indexHistorique/g;
	s/\$ARTICLE{'historique_table'}/$tableHistorique/g;
	$content .= $_;	
    }
	#$content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n";
	print $content;	
        close (FILE);    
}


sub loadProfilDealer {
	my $dealer = $query->param("username");
	my $option = $query->param("enchere");
	my $option2 = $query->param("option");
	my $string = '';
	my $string2 = '';
	my $img_buy = '';
	my $eval_deal_view = '';
	my $eval_deal_deal = '';
	my $img_deal = '';
	my $evalarticle_index = '';
	my $evalarticle_table = '';
	my $show_article_table = '';
	my $show_article_index= '';
	if ($option eq '0'  or ($option eq '1')) {
		$string =  $articleClass->doDealerIndex($option,$dealer);
		$string2 = $articleClass->doDealerIndexed($option,$dealer);		
	}
	if ($option2 eq "evalbuy") {
		$img_buy = $imageManipulation->generateGraphicBuy($dealer);
		$eval_deal_view = $articleClass->evalDealView();
	}elsif ($option2 eq "evaldeal") {
		$img_deal = $imageManipulation->generateGraphicDeal($dealer);
		$eval_deal_deal = $articleClass->evalDealDeal();
	}elsif ($option2 eq "evalarticle") {
	    $evalarticle_index = $articleClass->evalArticleIndex();
	    $evalarticle_table = $articleClass->evalArticleTable();
	}elsif ($option2 eq "showbuyedarticle") {
	    $show_article_index = $articleClass->showArticleIndex();
	    $show_article_table = $articleClass->showArticleByIndex();

	}open (FILE, "<$dir/profil_vendeur.html") or die "cannot open file $dir/profil_vendeur.html";
	my $menu = $lp->loadMenu();
	my $string4 = "sdfsdf";#weekNews ();	
	my $cats = $articleClass->getCat();
	# remettre en place l'utilisateur de la session
	#SELECT count( * )FROM personne, met_en_vente, article WHERE nom_utilisateur = 'alexandre'AND met_en_vente.ref_vendeur = id_personneAND met_en_vente.ref_article = article.id_articleAND article.enchere = '1'
	
	($ARTICLE{'enchere_open_count'})= $db->sqlSelect("count(*)", "personne,met_en_vente, article","nom_utilisateur = '$dealer' AND met_en_vente.ref_vendeur = id_personne AND met_en_vente.ref_article = article.id_article AND article.enchere = '1' AND article.vendu = '0'");	
	($ARTICLE{'enchere_closed_count'})= $db->sqlSelect("count(*)", "personne,met_en_vente, article","nom_utilisateur = '$dealer' AND met_en_vente.ref_vendeur = id_personne AND met_en_vente.ref_article = article.id_article AND article.enchere = '1' AND article.vendu = '1'");	
	($ARTICLE{'direct_deal_open'})= $db->sqlSelect("count(*)", "personne,met_en_vente, article","nom_utilisateur = '$dealer' AND met_en_vente.ref_vendeur = id_personne AND met_en_vente.ref_article = article.id_article AND article.enchere = '0' AND article.vendu = '0'");	
	($ARTICLE{'direct_deal_closed'})= $db->sqlSelect("count(*)", "personne,met_en_vente, article","nom_utilisateur = '$dealer' AND met_en_vente.ref_vendeur = id_personne AND met_en_vente.ref_article = article.id_article AND article.enchere = '0' AND article.vendu = '1'");	
	($ARTICLE{'have_buy_count'})= $db->sqlSelect("count(*)", "personne,evaluation_achat","nom_utilisateur = '$dealer' AND ref_acheteur = id_personne ");	
	($ARTICLE{'have_deal_count'})= $db->sqlSelect("count(*)", "personne,evaluation_vente","nom_utilisateur = '$dealer' AND ref_vendeur = id_personne ");	
	($ARTICLE{'eval_article_count'}) = $db->sqlSelect("count(*)", "personne,evaluation_article","nom_utilisateur = '$dealer' AND ref_vendeur = id_personne ");	
	($ARTICLE{'ville'})= $db->sqlSelect("ville", "personne,met_en_vente, article","nom_utilisateur = '$dealer' AND met_en_vente.ref_vendeur = id_personne AND met_en_vente.ref_article = article.id_article AND article.enchere = '1' AND article.vendu = '1'");	
	($ARTICLE{'counter_buy'}) = $db->sqlSelect("count(*)"," a_paye", "a_paye.ref_statut = '7' and a_paye.ref_acheteur = (SELECT id_personne FROM personne WHERE nom_utilisateur = '$dealer')");    
	my $content;
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
    
	    my $b;
	    if ($username) {
		
	    }
	our $index = "";
	my $img = "";
	my $categoriesTosearch = $lp->loadCategories();
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'dealer'}/$dealer/g;
	    s/\$ARTICLE{'username'}/$username/g;
	    s/\$OPTIONS{'categories2'}/$categoriesTosearch/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$ARTICLE{'graphic_buy'}/$img_buy/g;
	    s/\$ARTICLE{'graphic_deal'}/$img_deal/g;
	    s/\$ARTICLE{'have_deal_count'}/$ARTICLE{'have_deal_count'}/g;
	    s/\$ARTICLE{'have_buy_count'}/$ARTICLE{'have_buy_count'}/g;
	    s/\$ARTICLE{'enchere_open_count'}/$ARTICLE{'enchere_open_count'}/g;
	    s/\$ARTICLE{'enchere_closed_count'}/$ARTICLE{'enchere_closed_count'}/g;
	    s/\$ARTICLE{'direct_deal_closed'}/$ARTICLE{'direct_deal_closed'}/g;
	    s/\$ARTICLE{'counter_buy'}/$ARTICLE{'counter_buy'}/g;
	    s/\$ARTICLE{'eval_article_count'}/$ARTICLE{'eval_article_count'}/g;
	    s/\$ARTICLE{'direct_deal_open'}/$ARTICLE{'direct_deal_open'}/g;
	    s/\$ARTICLEs{'ville'}/$ARTICLE{'ville'}/g;;
	    s/\$ARTICLE{'index'}/$string/g;
	    s/\$ARTICLE{'table'}/$string2/g;
	    s/\$ARTICLE{'search'}//g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    #s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$LINK{'admin'}/$LINK{'admin'}/g;
	    s/\$ARTICLE{'evaldealview'}/$eval_deal_view/g;
	    s/\$ARTICLE{'evalarticleindex'}/$evalarticle_index/g;						
	    s/\$ARTICLE{'evalarticletable'}/$evalarticle_table/g;
	    s/\$ARTICLE{'evaldealdeal'}/$eval_deal_deal/g;
	    s/\$ARTICLE{'show_article_index'}/$show_article_index/g;
	    s/\$ARTICLE{'show_article_table'}/$show_article_table/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;	
        close (FILE);
	
}



BEGIN {
    use Exporter ();
  
    @LoadPage::ISA = qw(Exporter);
    @LoadPage::EXPORT      = qw(loadPage login detailOther);
    @LoadPage::EXPORT_OK   = qw();
}
1;