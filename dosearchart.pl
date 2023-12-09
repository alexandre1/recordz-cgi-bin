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
searchSport();

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



sub arrondi {
     my  $n = shift;
     $n = int($n + 0.5);
     if ($n < 1) {
	$n = 1;
     }
     
     return $n;
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



sub doSearchSport {
    my $category = $query->param('category');
    
    my $subcategory = $query->param('subcategory');
    
    my $fabricant = $query->param('fabricant');
    
    my $valeur = $query->param('valeur');
    $valeur  =~ s/\'/\'\'/g;
    my $buy_price_min = $query->param ("price_min");
    $buy_price_min  =~ s/\'/\'\'/g;
    my $buy_price_max = $query->param("price_max");
    $buy_price_max =~ s/\'/\'\'/g;
    
    my $string;    
    my  $select = "DISTINCT article.nom,id_article,marque,prix, categorie_libelle_langue.ref_categorie, pochette";
    my  $from = "article,categorie_libelle_langue";
    my  $where;
    if ($category) {$where .= "article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_categorie = (SELECT libelle.libelle FROM categorie_libelle_langue, langue, libelle WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";}    
    if ($subcategory) {
	$from .= ",subcategorie_libelle_langue";
	if ($where ne '') {
	    $where .= " AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie AND subcategorie_ref_subcategorie = (SELECT libelle.libelle FROM subcategorie_libelle_langue, langue, libelle WHERE libelle.libelle = '$subcategory' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";
	}    
	else {
	    $where .= " article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie AND subcategorie_libelle.ref_subcategorie = (SELECT libelle.libelle FROM subcategorie_libelle_langue, libelle, langue WHERE subcategorie_libelle.ref_libelle = libelle.id_libelle AND subcategorie_libelle.ref_subcategorie.ref_langue = langue.id_langue AND langue.key = '$lang')";
	}
    }
    if ($fabricant) {$where .= " AND article.marque = '$fabricant'";}
    if ($buy_price_min) {$where .= " AND article.prix >= '$buy_price_min'";}
    if ($buy_price_max) {$where .= " AND article.prix <= '$buy_price_max'";}
    if ($valeur) {$where .= " AND article.nom LIKE '%$valeur%'";}
    
    my  $total = '0';
    
    my  ($d)=$db->sqlSelect("count(article.nom)", $from, $where ." AND ref_statut = '3'");

    my $total = $d;
		
	
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
	
	$string .= "<a href=\"/cgi-bin/dosearchart.pl?lang=$lang&amp;action=dosearchcollection&amp;min_index=0&amp;session=$session_id&category=$category&price_min=$buy_price_min&price_max=$buy_price_max&max_index=40\" ><-First-></a>";		

	if (($index_page -1) > 0) {
		$previous_page = $previous_page - 1;
		$index_page--;
		$index--;
		$min_index = $min_index -40;
		$max_index = $max_index -40;
		
		$string .= "<a href=\"/cgi-bin/dosearchart.pl?lang=$lang&amp;action=dosearchcollection&amp;min_index=$min_index&amp;session=$session_id&category=$category&price_min=$buy_price_min&price_max=$buy_price_max\" ><-Previous-></a>";		
	}
	for my $index ($min_index..$counter) {						
		$next_page = $min_index + 40;
		if ($index_page < $count_per_page) {
			if (($index_page % $count_per_page) > 0) {							
				$string .= "<a href=\"/cgi-bin/dosearchart.pl?lang=$lang&amp;action=dosearchcollection&amp;min_index=$min_index&amp;session=$session_id&category=$category&price_min=$buy_price_min&price_max=$buy_price_max\" ><-$index_page-></a>";		

			}
		}		
		$index_page++;
		$index++;
		$counter--;
		$min_index += 40;;						
		$max_index += 40;;					
	}	
	$string .= "<a href=\"/cgi-bin/dosearchart.pl?lang=$lang&amp;action=dosearchcollection&amp;min_index=$min_index&amp;session=$session_id&category=$category&price_min=$buy_price_min&price_max=$buy_price_max\" ><-Next-></a>";		
	return $string;

}
#load search index result
sub doSearchSportIndexed {
    loadLanguage();
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");    
    my $fabricant = $query->param("fabricant");
    my $valeur = $query->param("valeur");
    my $buy_price_min = $query->param ("price_min");
   # $buy_price_min =~ s/[^\w ]//g;    
    my $buy_price_max = $query->param("price_max");
  #  $buy_price_max =~ s/[^\w ]//g;
    my $taille = $query->param("taille");	    
    my $used = $query->param("used");
    my $string;    
    my $select = "DISTINCT article.nom,id_article, prix,pochette,marque";
    my  $from = "article, langue";
    my  $where = "id_article = id_article ";
    my $ref_cat;
    my $ref_subcat;
    my $add;
    if ($category) {
            my  @cat = $db->sqlSelect("ref_categorie","categorie_libelle_langue, libelle, langue","libelle.libelle = '$category' and  categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang'");
	    $ref_cat = $cat[0];
	    $where .= " AND article.ref_categorie = $ref_cat AND categorie_libelle_langue.ref_categorie = $ref_cat and  article.ref_categorie = $ref_cat";
	    $from .= ", categorie_libelle_langue ";
    }
    if ($subcategory) {
            my  @sub_cat = $db->sqlSelect("ref_subcategorie","subcategorie_libelle_langue, libelle, langue","libelle.libelle = '$subcategory' and  subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue and langue.key = '$lang'");
	    $ref_subcat = $sub_cat[0];
	    $where .= " AND subcategorie_libelle_langue.ref_subcategorie = $ref_subcat AND  article.ref_subcategorie = $ref_subcat";
	    $from .= ", subcategorie_libelle_langue";
    }
    
    if ($taille) {$where .= " AND article.taille = '$taille'";}
    
    if ($valeur) {$where .= " AND article.nom LIKE '%$valeur%'";}    
    
    if ($fabricant) {if ($fabricant ne '---------') {$where .= " AND article.marque = '$fabricant'";}}
    if ($buy_price_min) {$where .= " AND article.prix >= '$buy_price_min'";	}
    if ($buy_price_max) {$where .= " AND article.prix <= '$buy_price_max'";	}
    if ($valeur) {$where .= " AND article.nom LIKE '%$valeur%'";}
         if ($used) {
	$from .= ",etat_libelle_langue";
	if ($where ne ''){
		$where .= " AND article.ref_etat = etat_libelle_langue.ref_etat AND etat_libelle_langue.ref_etat = (SELECT ref_etat FROM etat_libelle_langue WHERE libelle.libelle = '$used' AND etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";
	}else {
		$where .= " article.ref_etat = etat_libelle_langue.ref_etat AND etat_libelle_langue.ref_etat = (SELECT ref_etat FROM etat_libelle_langue WHERE libelle.libelle = '$used' AND etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";
	}
    }
    my  $total = '0';  
    my  ($d)= $db->sqlSelectMany($select, $from, $where ." AND ref_statut = '3'");
    my  $index_start = $query->param ("min_index") ;$index_start=~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index") ; $index_end=~ s/[^A-Za-z0-9 ]//;
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;    
    if (!$index_start ) {$index_start = 0;}if (!$index_end ) {$index_end = 40;}
    $string = "<table style=\"border-radius: 25px;border: 2px solid #6100C1;padding: 20px;\" width=\"555\" border=\"0\"><tr style=\"border-radius: 25px;border: 2px solid #6100C1;padding: 20px;\" width=\"555\" border=\"0\"><td align=\"left\" width=\"51\">$SERVER{'image'}</td><td align=\"left\" width=\"151\">$SERVER{'article_name_label'}</td><td align=\"left\">$SERVER{'fabricant'}</a></td><td align=\"left\">$SERVER{'article_price_label'}</td></tr>";
    my  ($c)= $db->sqlSelectMany($select, $from, $where ." LIMIT $index_start, $index_end");
    while( ($ARTICLE{'name'},$ARTICLE{'id_article'},$ARTICLE{'price'},$ARTICLE{'image'},$ARTICLE{'fabricant'})=$c->fetchrow()) {
	$string .= "<tr><td align=\"left\"><img alt=\"\" alt=\"\" src=\"$ARTICLE{'image'}\"></td><td align=\"left\"><a href=\"/cgi-bin/detail.pl?lang=$lang&amp;action=detailother&amp;article=$ARTICLE{'id_article'}&amp;$session_id\" class=\"menulink\" >$ARTICLE{'name'}</a></td><td align=\"left\">$ARTICLE{'fabricant'}</td><td align=\"left\">$ARTICLE{'price'}</td><td align=\"left\">$ARTICLE{'depot'}</td></tr>";
    }
    $string .="</table>";    
    return $string;
}

sub searchSport {
    my $category = $query->param('category');
   # $category  =~ s/[^\w ]//g;    
    my $subcategory = $query->param('subcategory');
   # $category  =~ s/[^\w ]//g;    
    my $fabricant = $query->param('fabricant');
   # $fabricant =~ s/[^\w ]//g;    
    my $valeur = $query->param('valeur');
   # $valeur  =~ s/[^\w ]//g;    
    my $buy_price_min = $query->param ("price_min");
   # $buy_price_min  =~ s/[^\w ]//g;
    my $buy_price_max = $query->param("price_max");
   # $buy_price_max  =~ s/[^\w ]//g;
    my $content;
    $session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});
    my $level = $session->param("level");
	if ($level eq '2') {
	    $LINK{'admin'} = "<a href=\"javascript:void(0)\" class=\"menulink\"  onclick=\"window.open('/cgi-bin/recordz.cgi?lang=$lang&amp;page=cms_manage_article&amp;session=$session_id;','MyWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=800,height=600,left=20,top=20')\">Admin</a>";
	}
	else {
	    $LINK{'admin'} = "";
	}
    
    
    my  $string =  doSearchSport ($category, $subcategory,$fabricant, $valeur);
    my  $string2 = doSearchSportIndexed ($category, $subcategory,$fabricant, $valeur);
    
    my $categories = $lp->loadCategories();
    open (FILE, "<$dir/dosearchjardin.html") or die "cannot open file $dir/dosearchjardin.html";
    my $menu = loadMenu();
    #my $cats = getCat();
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	s/\$LANG/$lang/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$ARTICLE{'index_table'}/$string/g;	
	#s/\$ARTICLE{'news'}//g;
	s/\$OPTIONS{'categories'}/$categories/g;
	s/\$LINK{'admin'}/$LINK{'admin'}/g;
	s/\$SESSIONID/$session_id/g;
	s/\$ARTICLE{'main_menu'}/$menu/g;
	s/\$ARTICLE{'search'}/$string2/g;
	$content .= $_;	
    }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);		
}
