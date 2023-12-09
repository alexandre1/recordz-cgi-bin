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


loadPage();
#print "Content-Type: text/html\n\n";
#print "test 12 ok";

sub loadPage {
    our $page = '';
    $page = $query->param("page");
    
    if ($page eq 'art_design') {
       loadArtAndDesign();
       return 1;
    }
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


sub loadMenu {
	my $string = "";
	$string .=  "<li><a href=\"/cgi-bin/a.pl?lang=$lang&amp;page=art_design\" class=\"menulink\" >$SERVER{'art'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/b.pl?lang=$lang&amp;page=parfum\" class=\"menulink\" >$SERVER{'parfum_cosmetik'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/c.pl?lang=$lang&amp;page=wear_news\" class=\"menulink\" >$SERVER{'fashion'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/d.pl?lang=$lang&amp;page=lingerie\" class=\"menulink\" >$SERVER{'lingerie'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/e.pl?lang=$lang&amp;page=baby\" class=\"menulink\" >$SERVER{'baby'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/f.pl?lang=$lang&amp;page=animal\" class=\"menulink\" >$SERVER{'animal'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/g.pl?lang=$lang&amp;page=watch\" class=\"menulink\" >$SERVER{'watch_jewels'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/h.pl?lang=$lang&amp;page=jardin\" class=\"menulink\" >$SERVER{'Habitat_et_jardin'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/i.pl?lang=$lang&amp;page=auto\" class=\"menulink\" >$SERVER{'car'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/j.pl?lang=$lang&amp;page=moto\" class=\"menulink\" >$SERVER{'moto'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/immo.pl?lang=$lang&amp;page=immo\" class=\"menulink\" >$SERVER{'real_estate'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/l.pl?lang=$lang&amp;page=cd_vinyl_mixtap\" class=\"menulink\" >$SERVER{'cd_music'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/m.pl?lang=$lang&amp;page=intruments\" class=\"menulink\" >$SERVER{'music_instrument'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/n.pl?lang=$lang&amp;page=collection\" class=\"menulink\" >$SERVER{'collections'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/o.pl?lang=$lang&amp;page=wine\" class=\"menulink\" >$SERVER{'wine'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/p.pl?lang=$lang&amp;page=boat\" class=\"menulink\" >$SERVER{'boat'}</a></li>";		
	$string .=  "<li><a href=\"/cgi-bin/q.pl?lang=$lang&amp;page=tv_video\" class=\"menulink\" >$SERVER{'tv_video_camera'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/r.pl?lang=$lang&amp;page=games\" class=\"menulink\" >$SERVER{'games'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/s.pl?lang=$lang&amp;page=book\" class=\"menulink\" >$SERVER{'book'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/t.pl?lang=$lang&amp;page=dvd\" class=\"menulink\" >$SERVER{'dvd_k7'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/u.pl?lang=$lang&amp;page=sport\" class=\"menulink\" >$SERVER{'sport'}</a></li>";
	return $string;
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
    $lang = $query->param("lang");
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

sub hex2string {
 my($instring) = @_;
 my($retval,$strlen,$posx);
 $strlen = length($instring);
 for ($posx = 0; $posx < $strlen; $posx=$posx+2) {
  $retval .= chr(hex(substr($instring,$posx,2)));
 }
 return($retval);
}


        

