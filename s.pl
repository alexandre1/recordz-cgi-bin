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

sub loadPage {
    our $page = '';
    $page = $query->param("page");
    
    if ($page eq 'book') {
							loadBook();
       return 1;
    }
}


sub loadBook {
	$lang = $query->param("lang");		
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
	my $selectionIndex = loadIndex();
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

        

sub loadIndex {
    $lang = $query->param("lang") ;		
    my  $cat = shift || '';
    my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    my  $depot = $query->param("depot");
    $depot =~ s/[^A-Za-z0-9 ]//;
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;
    my $from;
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
    my  $add2;
    
    my $ref_cat;
    my $ref_subcat;
    if ($subcat) {
            my  @sub_cat = $db->sqlSelect("ref_subcategorie","subcategorie_libelle_langue, libelle, langue","libelle.libelle = '$subcat' and  subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang'");
	    $ref_subcat = $sub_cat[0];
	    $add .= " AND subcategorie_libelle_langue.ref_subcategorie = $ref_subcat AND  article.ref_subcategorie = $ref_subcat";
	    $from .= ", subcategorie_libelle_langue";
    }
	
    if ($add eq "") {
	$add2 .= " AND article.ref_categorie = 9";
    }	

    my  ($c)= $db->sqlSelect("count(id_article)",
			   "article,met_en_vente, categorie_libelle_langue $from",
			   "ref_article = id_article AND ref_statut = '3' AND  enchere_date_fin > '$date% ' AND quantite > 0 $add $add2");	
	
	
 	
    my $counter = $c;
	my $total = $c;
		
	
	my $first_page = 0;
	my $count_per_page = 40;
	my $counter = ($total / $count_per_page); #Should be get from db;
	my $min_index = $query->param("min_index");
    my $next_page = $query->param("next_page");
	if (not defined $min_index) {
		$min_index = 0;
	}
	my $content = "";
	my $max_index = $query->param("max_index");	
	if (not defined $max_index) {		
		$max_index = 40;
	} else {
		#$max_index = round ($counter / 40, 1);#Number of objects displayed per page.
	}		
	my $last_page = $nb_page - 1;
	my $n2 = 0;

	my $index_page = $query->param("index_page");
	if (not defined $index_page) {
		$index_page = 0;
	}
	my $previous_page = $query->param("previous_page");	
	if (not defined $previous_page) {
		$index_page = 0;
		$previous_page = 0;
	}
	                    #http://localhost/cgi-bin/b.pl?lang=fr&page=parfum&u=&session=&category=Art%20et%20design&subcat=Peintures
		$string .= "<a href=\"/cgi-bin/s.pl?subcat=$subcat&category=$category&amp;min_index=0&amp;max_index=40&amp;index_page=$index_page&amp;page=book&amp;lang=$lang&amp;page=main&amp;session=$session_id&amp;min_index_our_selection=0&amp;max_index_our_selection=40&amp;min_inde=$min_index&amp;max_index=$max_index\" ><-First page-></a>&#160;&nbsp;";				
	
	if (($index_page -1) > 0) {
		$previous_page = $previous_page - 1;
		$index_page--;
		$index--;
		$min_index = $min_index -40;
		$max_index = $max_index -40;
		$string .= "<a href=\"/cgi-bin/s.pl?subcat=$subcat&amp;category=$category&amp;lang=$lang&amp;page=book&amp;session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_page&amp;previous_page=$previous_page&amp;min_index=$min_index&amp;max_index=$max_index\" ><-Previous-></a>&#160;&nbsp;";				
	}
	for my $index ($min_index..$counter -1) {						
		$next_page = $min_index + 40;
		if ($index_page < $count_per_page) {
			if (($index_page % $count_per_page) > 0) {							
				$string .= "<a href=\"/cgi-bin/s.pl?subcat=$subcat&amp;category=$category&amp;lang=$lang&amp;page=book&amp;session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_page&amp;previous_page=$previous_page&amp;index_page=$index_page&amp;min_index=$min_index&amp;max_index=$max_index\"\" ><-$index_page-></a>&#160;&nbsp;";								

			}
		}		
		$index_page++;
		$index++;
		$counter--;
		$min_index += 40;;						
		$max_index += 40;;					
	}	
	$string .= "<a href=\"/cgi-bin/s.pl?lsubcat=$subcat&amp;category=$category&amp;lang=$lang&amp;page=book&amp;session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index&amp;min_index=$min_index&amp;max_index=$max_index&amp;previous_page=$previous_page&amp;next_page=$next_page\" ><-Next-></a>&#160;&nbsp;";				      
    return $string;     
}


