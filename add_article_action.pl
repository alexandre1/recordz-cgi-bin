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
addOtherArticle();

sub addOtherArticleDEBUG { 
    my $file = $query->param('image');
    my $fileSize = -s $query->upload('image');;
    if ($fileSize > 1024000) {
        print "Content-Type: text/html\n\n";
        print "to big : $fileSize";
    }else {
        $file=~m/^.*(\\|\/)(.*)/;
        my $name = "testFileNewArticle.jpg";
        open(LOCAL, ">$imgdir/$name") or print 'error';
        my $file_handle = $query->upload('image');                                
        binmode LOCAL;
        while(<$file_handle>) {        
            print LOCAL;
     }
        close($file_handle);           
        close(LOCAL);
        }
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
sub addOtherArticle {
	
	my  $category = $query->param("category");
	my  $name = $query->param("name");
	my  $country = $query->param("country");
	my  $fabricant = $query->param("fabricant") ;
	my  $description = $query->param("editor1");
	$description =~ s/'/'''/g;
	my  $price = $query->param("price");
	my $lang = $query->param("lang");
	my  $subcat = $query->param("subcat");
	my $km = $query->param("km");if (!$km) { $km = 0;}
	my $nb_cylindre = $query->param("nb_cylindre");if (!$nb_cylindre) {$nb_cylindre = 0;}
	my $horse = $query->param("horse");if (!$horse){$horse = 0;}
	my $year_fabrication = $query->param("year_fabrication");	
	if (!$year_fabrication) {$year_fabrication = '0000';}
	my $year_service = $query->param("year_service");
	if (!$year_service) { $year_service = '0000-00-00 00:00:00';}
	my $type_essence = $query->param("type_essence");
	my $year2 = $query->param ("year");
	my $condition_payement = $query->param("condition_payement");
	my $condition_livraison = $query->param("condition_livraison");
	my $canton = $query->param("departement");
	my $departement = $query->param("departement");
	my $city = $query->param("city");
	my $adress = $query->param("adress");
	my $nbr_piece = $query->param("nbr_piece");if (!$nbr_piece) { $nbr_piece = 0;}
	my $habitable_surface = $query->param("habitable_surface");
	my $terrain_surface = $query->param("terrain_surface");
	my $date_construction = $query->param("date_construction");
	if (!$habitable_surface) {$habitable_surface = '0.00';}
	my $is_location_or_buy = $query->param("is_location_or_buy");
	$price =~ s/[^A-Za-z0-9 ]//;
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} ); 
	my  $user  = $query->param("u");
	my $cookie_in = $query->cookie("USERNAME");
	my $decrypted =  &RC4(&hex2string($cookie_in),$the_key);
	my $level = $session->param("level");
	my $option_main_page = $query->param("option_main_page");
	my $option_main_cat = $query->param("option_main_cat");
	my $option_pack_photo = $query->param("option_pack_photo");
	my $type_ecran = $query->param("type_ecran");
	my $is_enchere = $query->param("is_enchere");
	my $enchere_date_start = $query->param("enchere_date_start");
	if (!$enchere_date_start) { $enchere_date_start = '0000-00-00 00:00:00';}	
	my $enchere_date_end= $query->param("enchere_end_day");
	if (!$enchere_date_end) { $enchere_date_end = '0000-00-00 00:00:00';}	
	my $dimension = $query->param("dimension");my $enchere;
	my $processor = $query->param("processor");
	if (!$processor) { $processor = '0.00';}
	my $ram = $query->param("ram");
	my $hard_driver = $query->param("hard_drive");
	my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
	my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon,$mday;
	my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
	my $speed_box = $query->param("speed_box");
	my $with_clima = $query->param("with_clima");
	my $with_cima_value;my $speed_box_value;
	my $provenance = $query->param ("wine_country");
	my $quantity = $query->param("quantity");
	my $id_provenance;
	my $longueur = $query->param("longueur");	
	if (!$longueur) { $longueur = 0;}
	my $largeur = $query->param("largeur");
	if (!$largeur) { $largeur = 0;}
	my $conso = $query->param("conso");
	if (! $conso) {$conso = 0;}    
	my $acteurs   = $query->param("actor");
	my $duree =  $query->param("duration");
	my $realisateur  = $query->param("realisator");
	my $game_type = $query->param("game_type");
        my $region = $query->param("wine_country");
	my $cepage = $query->param("cepage");
        my $wine_type = $query->param("wine_type");
        my $autor = $query->param("autor");
        my $size = $query->param("size");
	my $code_postal = $query->param("code_postal");
        my $used = $query->param("used");
	my $error = 0;
	if ($name eq "") {
	    $ERROR{'name_value_required'} = $ERROR{'name_value_required'};
	    $error = "1";
	}
	
	if ($name eq "") {
	    $ERROR{'name_value_required'} = $ERROR{'name_value_required'};
	    $error = "1";
	}
	if ($error eq "1") {
	    loadAddArticle();
	    return 1;
	}else { 	
        # ajouter italien
	if ($is_enchere eq "Yes" or ($is_enchere eq "Oui") or ($is_enchere eq "Ya")) {	$enchere = 1;}
	else {
	    $enchere = 0;
	if ($quantity eq "") {
	    $ERROR{'name_value_required'} = "coucou";
	    $error = 1;
	}

            # reformater si date américaine
	    ;my $dt = DateTime->last_day_of_month( year => $year+1900, month => $mon+1 );
	    while ( $dt->day_of_week >= 6 ) {
		$dt->subtract( days => 1 )
		} 
	    $enchere_date_end =  $dt->ymd ." $time ";}
	if ($with_clima) {
            if ($with_clima eq 'Yes' or $with_clima eq 'Oui' or $with_clima eq 'Ya') {
                $with_cima_value = 1;
            }else {
                $with_cima_value = 0;
                }
            }else {
                $with_cima_value = 0;
            }
	my $id_region;my $id_wine_country;my $essence_or_diesel;my $used_or_new;
	if ($type_essence) {                                                                                   
	    ($essence_or_diesel)=$mydb->sqlSelect("ref_type_essence", "  type_essence_libelle_langue, libelle", "libelle = '$type_essence' AND type_essence_libelle_langue.ref_libelle = libelle.id_libelle");}else { $essence_or_diesel = 0;}
	my $id_country;
	if ($country) {
	    $id_country = $mydb->sqlSelect("id_pays_present", " pays_present", "nom = '$country'");
	}
        else {$id_country = '0';}
	if ($used) {($used_or_new)=$mydb->sqlSelect("ref_etat", " etat_libelle_langue,libelle,langue", "libelle.libelle = '$used' AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND libelle.id_libelle = etat_libelle_langue.ref_libelle");}else {$used_or_new = 2; }
	if ($provenance) {($id_provenance)=$mydb->sqlSelect("id_pays_present", "pays_present", "nom = '$provenance'");
	    }else {$id_provenance = 0;}
	if (!$ram) { $ram = 0;}
	if ($region) {($id_region)=$mydb->sqlSelect("id_pays_region_vin","pays_region_vin,pays_present","ref_pays = id_pays_present AND pays_present.nom = '$provenance' AND pays_region_vin.nom= '$region' ");} else {$id_region = 0;}
	
	
	my $id_cepage;my $id_type_de_vin;
        if ($cepage) {
         ($id_cepage) = $mydb->sqlSelect("id_cepage","pays_region_vin,cepage","ref_pays_region_vin = id_pays_region_vin AND pays_region_vin.nom = '$region' AND cepage.nom= '$cepage'");}else {$id_cepage = 0;
                                                                                                                                                                                              }
    	
	my  ($subcatID);
        if ($wine_type) {
	$id_type_de_vin = $mydb->sqlSelect("ref_type_de_vin","type_de_vin_libelle_langue, libelle, langue",
				    "type_de_vin_libelle_langue.ref_libelle = libelle.id_libelle AND  libelle.libelle = '$wine_type' AND type_de_vin_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_vin_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
			  $subcatID = '0';
	}else {$id_type_de_vin = 0;

}
	
        my $id_departement;
	if ($speed_box) {($speed_box_value)=$mydb->sqlSelect("ref_boite_de_vitesse", "boite_de_vitesse_libelle_langue, libelle", "libelle.libelle= '$speed_box' AND boite_de_vitesse_libelle_langue.ref_libelle = libelle.id_libelle");}else { $speed_box_value = 0;}	
	if ($departement) {($id_departement)=$mydb->sqlSelect("id_departement", "departement", "nom = '$departement'");} else {$id_departement = 0;}
	if ($level eq '2') {$LINK{'admin'} = "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&amp;page=cms_manage_article;\" class=\"menulink\" >Admin</a>";}
	else {$LINK{'admin'} = "";}
	#if ($username) {
		my  ($userID)=$mydb->sqlSelect("id_personne", "personne", "nom_utilisateur = '$decrypted'");

		my ($ref_genre);
		my  $categorie_id = getCategoryID($category);

		my ($game_typeID);
                if ($categorie_id eq '6' or $categorie_id eq '7') {($subcatID)=$mydb->sqlSelect("ref_subcategorie", "subcategorie, subcategorie_libelle_langue, libelle, langue", "libelle.libelle = '$subcat' and subcategorie_libelle_langue.ref_categorie = '$categorie_id' AND  subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'") if ($subcatID eq '');}else {($subcatID)=$mydb->sqlSelect("ref_subcategorie", "subcategorie_libelle_langue, libelle, langue", "libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'") if ($subcatID eq '');}
		my $type_ecran_id;
                if ($type_ecran) {($type_ecran_id)=$mydb->sqlSelect("id_type_ecran", "type_ecran, type_ecran_libelle_langue, libelle", "libelle.libelle = '$type_ecran' AND type_ecran.id_type_ecran = type_ecran_libelle_langue.ref_type_ecran AND type_ecran_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND libelle.id_libelle = type_ecran_libelle_langue.ref_libelle");
							     }else {$type_ecran_id = 0;}
		if ($game_type) {($game_typeID)=$mydb->sqlSelect("id_type_de_jeux", "type_de_jeux, type_de_jeux_libelle_langue, libelle", "libelle.libelle = '$game_type' AND type_de_jeux.id_type_de_jeux = type_de_jeux_libelle_langue.ref_type_de_jeux AND type_de_jeux.ref_libelle = libelle.id_libelle");}
		else {$game_typeID = '0';}
		my ($condition_payement_ref)  = $mydb->sqlSelect("ref_condition_payement", "condition_payement_libelle_langue, libelle, langue", "libelle.libelle= '$condition_payement' AND condition_payement_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND condition_payement_libelle_langue.ref_libelle = libelle.id_libelle");
		my ($condition_livraison_ref) = $mydb->sqlSelect("ref_condition_livraison", "condition_livraison_libelle_langue, libelle, langue", "libelle.libelle = '$condition_livraison'  AND condition_livraison_libelle_langue.ref_libelle = libelle.id_libelle AND condition_livraison_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
		my ($ref_canton);
		
		if ($canton)
		{($ref_canton) = $mydb->sqlSelect("id_canton", "canton_$lang", "nom = '$canton'");
		    
		    }else {
		    $ref_canton = 0;
													 }
		my ($is_location_or_buy_ref);
		
		if ($is_location_or_buy) {(
					   $is_location_or_buy_ref) = $mydb->sqlSelect("ref_location_ou_achat", "location_ou_achat_libelle_langue, libelle, langue", "libelle.libelle= '$is_location_or_buy' AND location_ou_achat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND location_ou_achat_libelle_langue.ref_libelle = libelle.id_libelle");
					
		    }else {$is_location_or_buy_ref = 0;
																																					  }
		if (!$quantity) {$quantity = 1;	}
		if ($autor eq '') {
		    $autor = $fabricant;
	    
		}
		my  $file = $query->param('image');

                my $fileSize = -s $query->upload('image');;
                    if ($fileSize > 1024000) {	
                    $ERROR{'name_value_required'} = "Le fichier est trop grand";
		    loadAddArticle();
		    return 1;
		}else {		
		        #print "Content-Type: text/html\n\n";
          #print "START : $enchere_date_start "
          #print "FIN : $enchere_date_end "
		$mydb->sqlInsert("article",
			    marque 		=> "$fabricant",
			    nom			=> "$name",
			    auteur		=> "$autor",
			    ref_type_de_jeux    => "$game_typeID",
			    label		=> "$description",
			    nb_km		=> "$km",
			    prix		=> "$price",
			    nb_cheveaux 	=> "$horse",
			    lang		=> "$lang",
			    ref_condition_payement => "$condition_payement_ref",
			    ref_condition_livraison => "$condition_livraison_ref",
			    ref_subcategorie 	=> "$subcatID",
			    pochette		=> "",
			    presound		=> "",
			    ref_genre		=> "0",
			    taille		=> "$size",
			    nb_cylindre		=> "$nb_cylindre",
			    etat		=> '0',
			    essence_ou_diesel => "$essence_or_diesel",
			    ref_location_ou_achat => "$is_location_or_buy_ref",
			    ref_categorie	=> "$categorie_id",
			    owned		=> '0',
			    lieu		=> "$city",
			    adresse		=> "$adress",
			    nb_piece 		=> "$nbr_piece",
			    surface_habitable 	=> "$habitable_surface",
			    superficie_terrain 	=> "$terrain_surface",
			    premiere_immatriculation => "$year_service",
			    annee 		  => "$year_fabrication",
			    ref_statut		  => '3',
			    ref_pays		  => "$id_country",
			    ref_type_ecran        => "$type_ecran_id",
			    ref_canton		  => "$ref_canton",
			    date		  => "$date $time",
			    enchere	  	  => "$enchere",
			    enchere_date_debut    => "$enchere_date_start",
			    enchere_date_fin      => "$enchere_date_end",
			    processeur		  => "$processor",
			    ram 		  => "$ram",
			    ref_departement       => "$id_departement",
			    ref_boite_de_vitesse  => "$speed_box_value",
			    clima                 => "$with_cima_value",
			    ref_provenance      => "$id_provenance",
			    quantite		=> "$quantity",
			    longueur		=> "$longueur",
			    largeur		=> "$largeur",
			    consomation		=> "$conso",
			    acteurs		=> "$acteurs",
			    npa                 => "$code_postal",
			    duree		=> "$duree",
			    realisateur		=> "$realisateur",
			    annee		=> "$year",
			    ref_cepage          => "$cepage",
			    ref_type_de_vin     => "$id_type_de_vin",
			    annee_construction    => "$date_construction",
			    ref_pays_region_vin => "$id_region",
			    ref_etat		=> "$used_or_new",
			    disque_dur	        => $hard_driver
		   );
		my  @d = $mydb->sqlSelect("id_article", "article","date='$date $time'");
		my  $ref_article = $d[0];
		
		$mydb->sqlInsert("met_en_vente",
			ref_vendeur		=> "$userID",
			ref_article		=> "$ref_article",
			date_stock		=> "$date",
			page_principale 	=> "off",
			page_categorie 		=> "on",
			notre_selection 	=> '1',
			pack_photo		=> "$option_pack_photo"
		);
		#alertUserAVinyWishIsArrived();
		uploadImage($ref_article);
		my  $url = "../upload/thumb.".$ref_article.".jpg";
		$mydb->sqlUpdate("article", "id_article = $ref_article",(pochette => $url));
		loadMainPage();
	}
	}
}

sub uploadImage {
    my  $name = shift || '';
    my  $file = $query->param('image');	
    
    open(LOCAL, ">$imgdir/$name.jpg") or print 'error';
    my $file_handle = $query->upload('image');                                
    binmode LOCAL;
    while(<$file_handle>) {        
	print LOCAL;
 }
    close($file_handle);           
    close(LOCAL);
    #createImageMagickThumb("$name.jpg");	
    $t = new Image::Thumbnail(
        size       => "135x135",
        create     => 1,
        module	   => "Image::Magick",
        input      => "$imgdir/$name.jpg",
        outputpath => "$imgdir/thumb.$name.jpg");

}


sub createImageMagickThumb {

    my  $filename = shift || '';
	my $t = new Image::Thumbnail(
        size       => "100x100",
        create     => 1,
        module	   => "Image::Magick",
        input      => "$imgdir/$filename",
        outputpath => "$imgdir/thumb.$filename");
}
sub createThumb {
    my  $filename = shift || '';
    open (IN, "$imgdir/$filename") or die "Could not open $imgdir/$filename !)";
    my  $srcImage = GD::Image->newFromJpeg(*IN);
    close IN;
    my  ($thumb,$x,$y) = Image::GD::Thumbnail::create($srcImage,50);
    open (OUT,">$imgdir/thumb.$filename.jpg") or die "Could not save ";
    binmode OUT;
    print OUT $thumb->jpeg;
    close OUT;
}

sub getCategoryID {
    my  $category = shift || '';   
    my  ($c)= $mydb->sqlSelectMany("ref_categorie","categorie_libelle_langue, libelle, langue","libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");	
    my  $string = "";my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "$OPTIONS{'category'}";}
    return $string;    
}


sub loadMainPage {
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
	}elsif ($type_p eq 'onlyench') {
	    $string1 = $tableArticle->viewARTICLEOnlyEnchhopIndex();
	    $string2 = $tableArticle->loadARTICLEOnlyEnchByIndex();
	}elsif ($type_p eq 'onlynew') {
   	    $string1 = $tableArticle->viewARTICLEFromShopIndex();
	    $string2 = $tableArticle->loadARTICLEFromShopByIndex();
	} else {
	    $string1 = $articleClass->loadArticleSelection();;
	    $string2 = $articleClass->viewArticleSelectionByIndex();;
   	}
    
        open (FILE, "<$dir/main.html") or die "cannot open file $dir/main.html";    	
	my $categories = loadCategories();
	my $menu = loadMenu();
	my $content;
    
	while (<FILE>) {	
	    s/\$LABEL\{'([\w]+)'\}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$OPTIONS{'categories'}/$categories/g;
	    s/\$ARTICLE{'best_offers_index'}/$string1/g;
	    s/\$ARTICLE{'best_offers_table'}/$string2/g;        
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    $content .= $_;	
        }

	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
    close (FILE);
}


sub loadAddArticle {
    open (FILE, "<$dir/add_other2.html") or die "cannot open file $dir/add_other2.html";    	
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
		$lang = lc ($lang);
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

