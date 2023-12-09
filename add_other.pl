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
loadAddArticle();

sub loadAddArticle {
    open (FILE, "<$dir/add_other2.html") or die "cannot open file $dir/add_other2.html";    	
    my $maincat = $query->param("category");
    my $subcat = $query->param("subcat");
    my $entities = '';
    $subcat .= $entities;

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
	    #$string4 =~ s/[&]/$entities/ge;			
	    }
		
	my $res = $query->param("isencher");
	if ($res eq 'yes' or $res eq 'Yes' or $res eq 'oui' or $res eq 'Oui' or $res eq 'ya' or $res eq 'Ya') {
		$properties = $lp->loadEnchereProperties();
	}
	$isenchere = $lp->getIsEnchere();
	my  ($subcatID)=$db->sqlSelect("ref_subcategorie", "subcategorie_libelle_langue, langue, libelle", "libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my  ($catID)=$db->sqlSelect("ref_categorie", "categorie_libelle_langue,  langue, libelle", "libelle.libelle = '$maincat' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	
	if ($catID eq '100') {
		$string4 = $lp-> loadSubCategoriesOtherInformatic();
	}
	
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
	
	if ($subcatID eq '75' or $subcatID eq '76' or $subcatID eq '77')   {
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

