#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use Comment;
use CGI;
use CGI::Cookie;
use Time::HiRes qw(gettimeofday);
use Article;
use CGI::Lite ();
use DBI;
use MyDB;
use LoadProperties;
use ImageManipulation;
use Digest::MD5 qw(md5_hex);
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

sub showImage {
    
    my  $image = $query->param('article');
    my  $URL = "../upload/$image.jpg";
    my $content;
    open (FILE, "<$dir/show_image.html") or die "cannot open file $dir/show_image.html";
    while (<FILE>) {
        s/\$ARTICLE_URL/$URL/g;
        $content .= $_;
    }
        print "Content-Type: text/html\n\n";
        print $content;
    close (FILE);    
    return 1;
}

sub loadError {
    if (defined $query) { 
    $lang = lc($query->param("lang"));
		open (FILE, "<$dirError/$lang.error.conf") or die "cannot open file $dirError/$lang.error.conf";    
		while (<FILE>) {
			(my  $label, my  $value) = split(/=/);
			$ERROR{$label} = $value;	
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
		$lang = lc($query->param("lang"));		
		open (FILE, "<$dirLang/$lang.conf") or die "cannot open file $dirLang/$lang.conf";    		
		while (<FILE>) {		open (FILE, "<$dirLang/$lang.conf") or die "cannot open file $dirLang/$lang.conf";    		
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
		$img_buy = "";#$imageManipulation->generateGraphicBuy($dealer);
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
	($ARTICLE{'counter_buy'}) = $db->sqlSelect("count(*)"," a_paye", "a_paye.ref_statut = '7' and a_paye.ref_acheteur = (SELECT id_personne FROM personne WHERE nom_utilisateur = '$dealer')");
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