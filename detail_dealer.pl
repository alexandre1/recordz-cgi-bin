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
loadProfilDealer();

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
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=immo\" class=\"menulink\" >$SERVER{'real_estate'}</a></li>";
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
sub loadProfilDealer {
   loadLanguage();
	my $dealer = $query->param("username");
   my $cookie_in = $query->cookie("USERNAME");
   my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
   my $id_personne = '';
   my $id_visiteur = '';
   ($id_personne)= $db->sqlSelect("id_personne", "personne", "nom_utilisateur = '$dealer'");
   ($id_visiteur)= $db->sqlSelect("id_personne", "personne", "nom_utilisateur = '$decrypted'");
   if ($id_visiteur) {
   if ($dealer ne $decrypted) {
       $db->sqlInsert("visiteur",								
							ref_personne	=> $id_personne,
							ref_visiteur => $id_visiteur
						);
			
   }}
	my $option = $query->param("enchere");
	my $option2 = $query->param("option");
   my $list = $query->param("list");
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
   my $view_comment_index = '';
   my $view_comment_table = '';
   my $show_list_visiteurs_index = '';
   my $show_list_visiteurs_table = '';
	if ($option eq '0'  or ($option eq '1')) {
		$string =  $articleClass->doDealerIndex($option,$dealer);
		$string2 = $articleClass->doDealerIndexed($option,$dealer);		
	}
	if ($option2 eq "evalbuy") {
		$img_buy = $imageManipulation->generateGraphicBuy($dealer);
		$eval_deal_view = $articleClass->evalDealView();
	}elsif ($option2 eq "evaldeal") {
		$img_deal = $imageManipulation->generateGraphicDeal($dealer);
		$eval_deal_deal = $articleClass->evalDealView();
	}elsif ($option2 eq "evalarticle") {
	    $evalarticle_index = $articleClass->evalArticleIndex();
	    $evalarticle_table = $articleClass->evalArticleTable();
	}elsif ($option2 eq "showbuyedarticle") {
	    $string = showArticleIndex();
	    $show_article_table = $articleClass->showArticleByIndex();

	}elsif ($option2 eq "viewcomments") {
	    $show_article_index = $articleClass->viewCommentIndex();
	    $show_article_table = $articleClass->viewCommentTable();
   }elsif ($list eq "1") {
	    $show_list_visiteurs_index = $articleClass->showVisiteursIndex();
	    $show_list_visiteurs_table = $articleClass->showVisiteursTable();
   }
   open (FILE, "<$dir/profil_vendeur.html") or die "cannot open file $dir/profil_vendeur.html";
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
	($ARTICLE{'counter_buy'}) = $db->sqlSelect("count(id_a_paye)"," a_paye,personne", "a_paye.ref_statut = '7' and a_paye.ref_acheteur = (SELECT id_personne FROM personne WHERE nom_utilisateur = '$dealer')  and a_paye.ref_acheteur = id_personne");
   ($ARTICLE{'counter_comments'}) = $db->sqlSelect("count(*)"," commentaire,personne", "commentaire.ref_emetteur = (SELECT id_personne FROM personne WHERE nom_utilisateur = '$dealer') AND id_personne = commentaire.ref_emetteur");    
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
       s/\$ARTICLE{'counter_comments'}/$ARTICLE{'counter_comments'}/g;
       s/\$ARTICLE{'comment_index'}/$show_article_index/g;
       s/\$ARTICLE{'comment_table'}/$show_article_table/g;
       s/\$ARTICLE{'visiteur_index'}/$show_list_visiteurs_index/g;
       s/\$ARTICLE{'visiteur_table'}/$show_list_visiteurs_table/g;
       
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;	
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

sub showArticleIndex {
    my $option = $query->param("enchere");
    my $dealer = $query->param("username");
    my $vendu = $query->param("vendu");
    my  $from = "article";
    my  $where;
    my $string;
    #doDealerIndex
    my  $total = '0';
    
my  ($c)= $mydb->sqlSelect("COUNT(DISTINCT a_paye.ref_acheteur,pochette,article.nom,id_article,id_a_paye,a_paye.quantite,a_paye.montant)",
			   "article,personne,a_paye,met_en_vente",
			   "a_paye.ref_article = id_article AND a_paye.ref_acheteur = id_personne  AND nom_utilisateur = '$dealer' and a_paye.ref_statut = '7' AND a_paye.ref_acheteur = id_personne AND a_paye.ref_article = id_article");	
    
	 $total = $c;
	
    
	$min_index += 40;	
	my $string = "";
	my $first_page = 0;
	my $nb_page = 0;
	my $min_index = $query->param("min_index");
	if (not defined $min_index) {
		$min_index = 0;
	}
	my $count_per_page = 40;
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
	my $index = 0;
#	$string .= "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1\" ><-\"First page\"-></a>&#160;&nbsp;";				
	$string .= "<a href=\"/cgi-bin/detail_dealer.pl?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$dealer&amp;option=showbuyedarticle&amp;min_index0&max_index=40&amp;previous_page=0&amp;index_page=0\ class=\"menulink2\" >First page</a>&#160;&nbsp;";				
	my $counter = ($total / $count_per_page); #Should be get from db;
	
	if (($index_page -1) > 0) {
		$previous_page = $previous_page - 1;
		$index_page--;
		$index--;
		$min_index = $min_index -40;
		$max_index = $max_index -40;
		#$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$dealer&enchere=$option&min_index=$min_index&max_index=$max_index\"  class=\"menulink2\" ><-$i-></a>&#160;&nbsp;";		
		$string .= "<a href=\"/cgi-bin/detail_dealer.pl?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$dealer&enchere=$option&min_index=$min_index&max_index=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_page&amp;option=showbuyedarticle&amp;\" class=\"menulink2\" ><-\"$i\"-></a>&#160;&nbsp;";				
	}
	for my $index ($min_index..$counter) {						
		$next_page = $min_index + 40;
		if ($index_page < $count_per_page) {
			if (($index_page % $count_per_page) > 0) {							
				$string .= "<a href=\"/cgi-bin/detail_dealer.pl?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$dealer&enchere=$option&min_index=$min_index&max_index=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_page&amp;option=showbuyedarticle&amp;\" class=\"menulink2\"  ><-$index_page-></a>&#160;&nbsp;";				
			}
		}		
		$index_page++;
		$index++;
		$counter--;
		$min_index += 40;;						
		$max_index += 40;;					
	}
	$string .= "<a href=\"/cgi-bin/detail_dealer.pl?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$dealer&enchere=$option&min_index=$min_index&max_index=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_page&amp;option=showbuyedarticle&amp;\" class=\"menulink2\"  ><-\"Next\"-></a>&#160;&nbsp;";				
	return $string;
}
