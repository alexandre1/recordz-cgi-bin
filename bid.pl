#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use CGI;
use Time::HiRes qw(gettimeofday);
use Article;
use DBI;
use MyDB;
use LoadProperties;
use ImageManipulation;
use Image::Thumbnail;

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
enchere();


sub enchere {
	my $article = $query->param("article");
	#$article = s/^[0-9]//g;
	my $username = $query->param("username");
	my $password = $query->param("password");
	my $enchereprice= $query->param("enchereprice");
	my $price = $query->param("price");
	
	
	my  ($user_name,$user_password,$level)= ();
	 ($user_name,$user_password,$level)=$db->sqlSelect("nom_utilisateur , mot_de_passe,level",
					     "personne", "nom_utilisateur = '$username' AND mot_de_passe='$password'");
    
	
	if ($user_name && $user_password) {
		my ($userID)=$db->sqlSelect("id_personne", "personne", "nom_utilisateur = '$username'");
		my ($vendeurID)=$db->sqlSelect("id_personne", "personne,met_en_vente", "id_personne = ref_vendeur AND ref_article = $article");
		
		if ($userID ne $vendeurID) {
			
			($ARTICLE{'counter'},$ARTICLE{'enchere_date_fin'})=$db->sqlSelect("nbr_enchere,enchere_date_fin", "article", "id_article = '$article'");
			$ARTICLE{'counter'} += 1;			
			$db->sqlUpdate("article","id_article = $article",(nbr_enchere => $ARTICLE{'counter'}));
			my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
			my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;	
			my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
			my  @date_time = split(/ /, $ARTICLE{'enchere_date_fin'});			
			my  $enchere_date_end = $date_time[0];
			my  $enchere_time_end = $date_time[1];			

			if ($enchere_date_end >= $date and $enchere_time_end  >= $enchere_time_end) {
				if ($enchereprice > $price) {
					#recherche de la plus haute enchere is c est pas la première enchère
					if ($ARTICLE{'counter'} ne '1') {
						($ARTICLE{'max_enchere'})=$db->sqlSelect("MAX(prix)", "enchere", "ref_article = '$article'");
					    } else {					    
						my @price_list =$db->sqlSelect("prix", "article", "id_article = '$article'");
						#print "price $price_list[0]";
						$ARTICLE{'max_enchere'} = $price_list[0];
					    }
						if ($enchereprice > $ARTICLE{'max_enchere'}) {												
								        
							
							$db->sqlInsert("enchere",
									ref_enchereur		=> $userID,
									ref_article		=> $article,
									prix			=> $enchereprice,
									date_enchere		=> "$date $time"
								);
#								detailOther();

#								print "Location:http://avant-garde.no-ip.biz/cgi-bin/recordz.cgi?lang=$lang&action=detailother&article=$article\n\n";
							detailOther();

									
						} else {
							print "Content-Type: text/html\n\n";
							print "<link href=\"/css/main.css\" rel=\"stylesheet\" type=\"text/css\" />";
							print "$SERVER{'price_to_low'}";
							print "<br/>";
							print "<br/>";
							print "<input type=\"button\" name=\"close\" value=\"Fermer\" onClick=\"window.close(); \"</input>";		
							print "&nbsp;";
							print "&nbsp;";
							print "<input type=\"button\" name=\"back\" value=\"Retour\" onClick=\"window.history.back(1); \"</input>";		

						}																	
				} else {
							print "Content-Type: text/html\n\n";
							print "<link href=\"/css/main.css\" rel=\"stylesheet\" type=\"text/css\" />";
							print "$SERVER{'price_to_low'}";
							print "<br/>";
							print "<br/>";
														print "<input type=\"button\" name=\"close\" value=\"Fermer\" onClick=\"window.close(); \"</input>";		
							print "&nbsp;";
							print "&nbsp;";
							print "<input type=\"button\" name=\"back\" value=\"Retour\" onClick=\"window.history.back(1); \"</input>";		

				}
			}else {
				#enchere terminé
				print "Content-Type: text/html\n\n";
				print "enchere pas possible car fin d enchere <br/>";
			}
		} else {
			#triche
			print "Content-Type: text/html\n\n";
			print "impossible d'enchérir un article vous appartenant<br/>";
		}
	} else {
	    	print "Content-Type: text/html\n\n";
		print "Veuillez-vous enregistrer<br/>";
	    }	
}

sub loadHistoriqueByIndex {
    my $article = $query->param("article");
    my  $cat = shift || '';
    my  $type = shift  || '';
    my  $depot = $query->param("depot") ;
    $depot=~ s/[^A-Za-z0-9 ]//;
    my  $index_start = $query->param ("min_index");
    $index_start=~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index");
    $index_end =~ s/[^A-Za-z0-9 ]//;
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
        my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);

    my  $string = "";
    my  $add;
    my  $add2;
    my  $dep;
    
    if (!$index_start ) {
	$index_start = 0;
    }
    if (!$index_end ) {
	$index_end = 40;
    }

    if ($cat) {
	$add = "AND genre.genre = '$cat'";
    } else {
	$add = "";
    }
    if ($type) {
	$add2 = "AND id_categorie = '$type'";
    } else {
	$add2 = "";		
    }

    if ($depot) {
	$dep = "AND ref_depot = (SELECT id_depot FROM depot WHERE ville = '$depot')";
    }

    my  ($c)= $db->sqlSelectMany("nom_utilisateur,prix,date_enchere",
		        "enchere, personne",
		       "ref_article = $article and ref_enchereur = id_personne LIMIT $index_start, $index_end");	
    

    my $i = 0;
    my $j = 0;
    $string .= "<table>";
    while( ($ARTICLE{'nom_utilisateur'},$ARTICLE{'prix'},$ARTICLE{'date_enchere'})=$c->fetchrow()) {
	#$string .= " <label>&nbsp;&nbsp;$ARTICLE{'genre'}</label>";
	my $de = $ARTICLE{'nom_utilisateur'};
	$string .= "<td align=\"left\" width=\"253px\" height=\"100px\" style=\"background-image:url(../images/table_article_decoration.jpg);background-position:right bottom;background-repeat: no-repeat;\">&nbsp;&nbsp;&nbsp;<a href=\"javascript:;\" onClick=\"Lvl_P2P('/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$ARTICLE{'nom_utilisateur'}',true,0500)\">$ARTICLE{'nom_utilisateur'}</a><br/>&nbsp;&nbsp;&nbsp;$ARTICLE{'prix'}<br/>&nbsp;&nbsp;&nbsp;$ARTICLE{'date_enchere'}</td>";
	$i += 1;$j += 1;
	if ($i eq 1) {$string .= "<td align=\"left\" width=\"10px\"></td>";$i = 0;}
	if ($j eq 2) {$string .= "</tr>";$string .= "<tr>";$string .= "</tr>";$string .= "<tr>";$string .= "</tr>";$string .= "<tr>";$j = 0;}
    }
    $string .= "<table>";
    return $string;
    
}

sub detailOther {
   $lang = $query->param("lang");
   loadLanguage();
	my $error = shift || '';
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

    my $string4 = $articleClass->weekNews ();my $menu = loadMenu();my  %ARTICLE = (); my $cats = $articleClass->getCat();
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
      $button_visite .= "<input type=\"button\" value=\"$SERVER{'ask_visit'}\" onclick=\"window.open('/cgi-bin/recordz.cgi?lang=$lang&amp;page=askvisit&article=$article;','MySearchWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=790,height=550,left=0,top=0')\"></input>";
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
    
    
    my $indexLastBuyers = loadHistoriqueLastBuyersIndex();
    my $tableLastBuyers = loadHistoriqueLastBuyersByIndex();
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
    my $indexHistorique = loadHistoriqueIndex();
    my $tableHistorique = loadHistoriqueByIndex();
    
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
sub loadHistoriqueLastBuyersIndex {
    my $article = $query->param("article");
    my  $cat = shift || '';
    my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    my  $depot = $query->param("depot");
    $depot =~ s/[^A-Za-z0-9 ]//;
    
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;
    my  $add2;
    my  $dep;
    
    if ($cat) {
	$add = "AND genre.genre = '$cat'";
    } else {
	$add = "";
    }
    if ($type) {
	$add2 = "AND id_categorie = '$type'";
    } else {
	$add2 = "";		
    }
    if ($depot) {
	$dep = "AND ref_depot = (SELECT id_depot FROM depot WHERE ville = '$depot')";
    }

    my  ($c)= $db->sqlSelectMany("ref_article",
			   "a_paye",
			   "ref_article = $article AND ref_enchere = 'NULL'");	
	
	while( ($ARTICLE{'nom_utilisateur'},$ARTICLE{'question'},$ARTICLE{'texte'},$ARTICLE{'date'})=$c->fetchrow()) {
	    $total +=1;
	}

    my  $nb_page = arrondi ($total / 4, 1);
    my  $min_index = '0';
    my  $max_index = '40';
    
    #print "Content-Type: text/html\n\n";
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	#my $x =
	my $j;
	#print "valeur de i $i <br />";
	if ($i <= 9) {
		$j = "0$i";
	}else {
		$j = $i;
	}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=historique&amp;article=$article&amp;min_index=$min_index&amp;max_index=$max_index&cat=$cat&depot=$depot\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }
        
return $string;    
}

sub loadHistoriqueLastBuyersByIndex {
    my $article = $query->param("article");
    my  $cat = shift || '';
    my  $type = shift  || '';
    my  $depot = $query->param("depot") ;
    $depot=~ s/[^A-Za-z0-9 ]//;
    my  $index_start = $query->param ("min_index");
    $index_start=~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index");
    $index_end =~ s/[^A-Za-z0-9 ]//;
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
        my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);

    my  $string = "";
    my  $add;
    my  $add2;
    my  $dep;
    
    if (!$index_start ) {
	$index_start = 0;
    }
    if (!$index_end ) {
	$index_end = 5;
    }

    if ($cat) {
	$add = "AND genre.genre = '$cat'";
    } else {
	$add = "";
    }
    if ($type) {
	$add2 = "AND id_categorie = '$type'";
    } else {
	$add2 = "";		
    }

    if ($depot) {
	$dep = "AND ref_depot = (SELECT id_depot FROM depot WHERE ville = '$depot')";
    }

    my  ($c)= $db->sqlSelectMany("DISTINCT id_a_paye, nom_utilisateur,prix,date_payement",
		        "a_paye, personne, article",
		       "ref_article = $article and ref_acheteur = id_personne and a_paye.ref_acheteur = id_personne and a_paye.ref_article = id_article and date_payement <> '0000-00-00 00:00:00' LIMIT $index_start, $index_end");	
    

    my $i = 0;
    my $j = 0;
    $string .= "<table>";
    while( ($ARTICLE{'id_article'},$ARTICLE{'nom_utilisateur'},$ARTICLE{'prix'},$ARTICLE{'date_enchere'})=$c->fetchrow()) {
	#$string .= " <label>&nbsp;&nbsp;$ARTICLE{'genre'}</label>";
	my $de = $ARTICLE{'nom_utilisateur'};
	$string .= "<td align=\"left\" width=\"253px\" height=\"100px\" style=\"background-image:url(../images/table_article_decoration.jpg);background-position:right bottom;background-repeat: no-repeat;\">&nbsp;&nbsp;&nbsp;<a href=\"javascript:;\" onClick=\"Lvl_P2P('/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=profil_vendeur&username=$ARTICLE{'nom_utilisateur'}',true,0500)\">$ARTICLE{'nom_utilisateur'}</a><br/>&nbsp;&nbsp;&nbsp;$ARTICLE{'prix'}<br/>&nbsp;&nbsp;&nbsp;$ARTICLE{'date_enchere'}</td>";
	$i += 1;$j += 1;
	if ($i eq 1) {$string .= "<td align=\"left\" width=\"10px\"></td>";$i = 0;}
	if ($j eq 2) {$string .= "</tr>";$string .= "<tr>";$string .= "</tr>";$string .= "<tr>";$string .= "</tr>";$string .= "<tr>";$j = 0;}
    }
    $string .= "<table>";
    return $string;
    
}

sub loadHistoriqueIndex {
    my $article = $query->param("article");
    my  $cat = shift || '';
    my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    my  $depot = $query->param("depot");
    $depot =~ s/[^A-Za-z0-9 ]//;
    
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;
    my  $add2;
    my  $dep;
    
    if ($cat) {
	$add = "AND genre.genre = '$cat'";
    } else {
	$add = "";
    }
    if ($type) {
	$add2 = "AND id_categorie = '$type'";
    } else {
	$add2 = "";		
    }
    if ($depot) {
	$dep = "AND ref_depot = (SELECT id_depot FROM depot WHERE ville = '$depot')";
    }

    my  ($c)= $db->sqlSelectMany("id_enchere",
			   "enchere",
			   "ref_article = $article");	
	
	while( ($ARTICLE{'nom_utilisateur'},$ARTICLE{'question'},$ARTICLE{'texte'},$ARTICLE{'date'})=$c->fetchrow()) {
	    $total +=1;
	}

    my  $nb_page = arrondi ($total / 4, 1);
    my  $min_index = '0';
    my  $max_index = '40';
    
    #print "Content-Type: text/html\n\n";
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	#my $x =
	my $j;
	#print "valeur de i $i <br />";
	if ($i <= 9) {
		$j = "0$i";
	}else {
		$j = $i;
	}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=historique&amp;article=$article&amp;min_index=$min_index&amp;max_index=$max_index&cat=$cat&depot=$depot\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }
        
return $string;    
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
    my  ($c)= $mydb->sqlSelectMany("libelle.libelle","categorie_libelle_langue,libelle,langue","categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");	
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

sub hex2string {
 my($instring) = @_;
 my($retval,$strlen,$posx);
 $strlen = length($instring);
 for ($posx = 0; $posx < $strlen; $posx=$posx+2) {
  $retval .= chr(hex(substr($instring,$posx,2)));
 }
 return($retval);
}


