sub loadPage2234234 {
    
    my  $page = $query->param('page') ;
    #$page=~ s/[^A-Za-z0-9 ]//;
    my  $cat = $query->param ('cat');
    $cat =~ s/[^A-Za-z0-9 ]//;
    my  $type = $query->param ('type') ;
    $type=~ s/[^A-Za-z0-9 ]//;
    my $menu = loadMenu();
    if (!$page) { $page = 'main';}
    my  $string1= "";
    my  $string2= "";
    my  $test = "";
    my  $string3 = "";
    my $cats = getCat();
    
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    
    my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );
    my $level = $session->param("level");
    my $best_offers;
    if ($page eq 'vinyl') {
	 #$SELECT{'depot'}

	my $string4 = weekNews ();
	$string1 = loadArticleNews($cat,$type);
	
	$string3 = getSelectArticleDepot();
	open (FILE, "<$dir/$page.html") or die "cannot open file $dir/$page.html";    	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'depot'}/$string3/g;
	    s/\$ARTICLE{'index_table'}/$string1/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;	
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'news'}/$string2/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'search'}//g;	    
	    s/\$LINK{'admin'}/$LINK{'admin'}/g;
	    s/\$ARTICLE{'week_news'}/$string4/g;
	    $content .= $_;
	    
        }
	$content = Compress::Zlib::memGzip($content);
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n";
	
	print $content;	
        close (FILE);
	return 1;
	}
    elsif ($page eq 'add_ARTICLE') {
	open (FILE, "<$dir/add_ARTICLE.html") or die "cannot open file $dir/add_ARTICLE.html";
	my $depot = getDepot();
	my $string4 = weekNews ();
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'depot'}/$depot/g;
	    s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$ARTICLE{'index_table'}/$string1/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'news'}/$string2/g;	    
	    s/\$ARTICLE{'search'}//g;	    
	    s/\$LINK{'admin'}/$LINK{'admin'}/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;

        close (FILE);
	return 1;

    }
    elsif ($page eq 'sport') {
	loadSport();
	return 1;
    }
    elsif ($page eq 'show_image') {
	showImage();
	return 1;
    }
    elsif ($page eq 'add_other3') {
	addOtherArticle();
	return 1;
	}
    elsif ($page eq 'sucess_payed') {
	sucessPayed();
	return 1;
    }
    elsif ($page eq 'charity') {
	loadCharity();
	return 1;
    }
    elsif ($page eq 'update_statut_article_paypayl') {
	loadUpdateArticlePayPal();
	return 1;
    }
    elsif ($page eq 'jardin') {
	loadHabitatJardin();
	return 1;
    }
    elsif ($page eq 'calendrier') {
	loadCalendrier();
	return 1;
    }

    elsif ($page eq 'games') {
	loadGames();
	return 1;
    }
    elsif ($page eq 'astro') {
	loadAstro();
	return 1;
    }

    elsif ($page eq 'search_art') {
	loadSearchArt();
	return 1;
    }
    elsif ($page eq 'search_animal') {
	loadSearchAnimal();
	return 1;
    }
    elsif ($page eq "search_instruments") {
	loadSearchInstruments();
    }
	   
    elsif ($page eq 'search_collection') {
	loadSearchCollection();
    }
    elsif ($page eq 'search_calendar') {
	loadSearchCalendar();
	return 1;
    }
    elsif ($page eq 'search_jardin') {
	loadSearchJardin();
	return 1;
    }
    elsif ($page eq 'search_baby') {
	loadSearchBaby();
	return 1;
    }

    elsif ($page eq 'search_parfum') {
	loadSearchParfum();
	return 1;
    }
    #search_lingerie
    elsif ($page eq 'search_lingerie') {
	loadSearchLingerie();
	return 1;
    }
    elsif ($page eq 'collection') {
	loadCollection ();
	return 1;
    }
    #animaux
    elsif ($page eq 'animal') {
	loadAnimal ();
	return 1;
    }
    elsif ($page eq 'longer') {
	loadLonger ();
	return 1;
    }
    
    elsif ($page eq 'intruments') {
	loadInstrument ();
	return 1;
    }
    elsif ($page eq 'preferences') {
	loadPreferences();
	return 1;
    }
    elsif ($page eq 'lingerie') {
	loadLingerie();
	return 1;
    }
    elsif ($page eq 'fondation') {
	loadFondation();
    }
    elsif ($page eq 'tarifs') {
	loadTarif();
	return 1;
    }
    elsif ($page eq 'analyze'){
	loadAnalyze ();
	return 1;
    }
    elsif ($page eq 'cigares') {
	loadCigares();
	return 1;
    }
    elsif ($page eq 'chocolat') {
	loadChocolat();
	return 1;
    }
    elsif ($page eq 'caviar') {
	loadCaviar ();
	return 1;
    }
    elsif ($page eq 'parfum') {
	loadParfum();
	return 1;
    }
    elsif ($page eq 'art_design') {
	loadArtAndDesign();
	return 1;
    }
    elsif ($page eq 'moto') {
	loadMoto();
	return 1;
    }
    elsif ($page eq 'baby') {
	loadBaby();
	return 1;
    }    
    elsif ($page eq 'watch') {
	loadWatch();
	return 1;
    }
    elsif ($page eq 'boat') {
	loadBoat();
	return 1;
    }
    elsif ($page eq 'dvd') {
	loadDvd();
	return 1;
    }elsif ($page eq 'book') {
	loadBook();
	return 1;
    }
    elsif ($page eq 'evalproduct') {
	loadEvalProduct();
	return 1;
    }
    elsif ($page eq 'last_buyers') {
	loadLastBuyers ();
	return 1;
    }
    elsif ($page eq 'wine') {
	loadWine();
	return 1;
    }
    elsif ($page eq 'search_info') {
	loadSearchInfo();
	return 1;
    }
    #search_dvd
    elsif ($page eq 'search_dvd') {
	loadSearchDVD();
	return 1;
    }
    elsif ($page eq 'search_sport') {
	loadSearchSport();
	return 1;
    }
    elsif ($page eq 'search_book') {
	loadSearchBook();
	return 1;
    }
    elsif ($page eq 'search_boat') {
	loadSearchBoat();
    }
    elsif ($page eq 'search_games') {
	loadSearchGames();
    }
    elsif ($page eq 'search_wine') {
	loadSearchWine();
    }
    elsif ($page eq 'search_watch') {
	loadSearchWatch();	
    }
    elsif ($page eq 'search_cigares') {
	loadSearchCigares();	
    }
    elsif ($page eq 'about') {
	loadAbout();
	return 1;
    }
    elsif ($page eq 'natel') {
	loadNatel ();
	return 1;
    }
    elsif ($page eq 'cd_vinyl_mixtap') {
	loadCdVinylMixTape();
	return 1;
    }
    elsif ($page eq 'search_auto') {
	loadSearchAuto ();
	return 1;
    }
    elsif ($page eq 'search_moto') {
	loadSearchMoto ();
	return 1;
    }

    elsif ($page eq 'search_cd') {
	loadSearchCd();
	return 1;
    }
    elsif ($page eq 'search_wear') {
	loadSearchWear();
	return 1;
    }
    elsif ($page eq 'search_tv') {
	loadSearchTv();
	return 1;
    }
    elsif ($page eq 'deal_again') {
	loadDealAgain();
	return 1;
    }	
    elsif ($page eq 'update_statut_payed') {
	loadUpdateStatutPayed();
	return 1;
    }
    elsif ($page eq 'update_statut_have_receive') {
	loadUpdateStatutReceived();
	return 1;
    }
    elsif ($page eq 'update_statut_article_waiting_buy') {
	loadUpdateStatutWaitingBuy();
	return 1;
    }
    elsif ($page eq 'update_statut_article_payed') {
	loadUpdateStatutArticlePayed();
	return 1;
    }
    elsif ($page eq 'myaccount' or $page eq 'login') {
	open (FILE, "<$dir/$page.html") or die "cannot open file $dir/$page.html";    
	my $string4 = weekNews ();
	my $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'depot'}/$string3/g;
	    s/\$ARTICLE{'index_table'}/$string1/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'news'}/$string2/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g; 
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'search'}//g;	    

	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;	
        close (FILE);
	return 1;
    }
    elsif ($page eq 'immo') {
	loadImmo();
	return 1;
    }

    elsif ($page eq 'commentaire') {
	loadCommentaire();
	return 1;
    }
    elsif ($page eq 'historique'){
	loadHistorique();
	return 1;
    }
    elsif ($page eq 'auto') {
	loadAutoPage();
	return 1;
    }
    elsif ($page eq 'mybuy') {
	loadMyBuy();
	return 1;
    }
    elsif ($page eq 'askvisit') {
	askVisit();
	return 1;
    }


    elsif ($page eq 'wear_news') {
	displayWear();
	return 1;
    }

    elsif ($page eq 'search_immo') {
	loadSearchImmo();
	return 1;
    }
    
    elsif ($page eq 'add_deal') {
	loadOther();
	return 1;	
    }
    elsif ($page eq 'matos_news') {
	loadMatosMain();
	return 1;
    }
    elsif ($page eq 'add_other') {
	loadOther();
	return 1;
    }
    elsif ($page eq 'mydeal') {
	displayMyDealList();
	return 1;
    }    
    elsif ($page eq 'mix_tape') {
	loadMixTape();
	return 1;
    }
    elsif ($page eq 'tv_video') {
	loadTvVideo();
	return 1;
    }
    elsif ($page eq 'informatique') {
	loadInformatique();
	return 1;
    }
    elsif ($page eq 'profil_vendeur') {
	loadDealerProfil();
	return 1;
    }
    elsif ($page eq 'myench') {
	loadMyEnchere();
	return 1;
    }
    elsif ($page eq 'deal') {
	loadMyEnchereDeal();
	return 1;
    }
    if ($page eq 'personal_data') {
	#$CGI::Session::MySQL::TABLE_NAME = 'sessions';
        loadMyAccount();
	return 1;
    }elsif ($page eq 'main') {
	my $type_p = $query->param("saw");
	my $img_p;
	print "coucou";
	if ($type_p eq 'lasthour') {
	    $string1 = loadARTICLELastHour();
	    $string2 = viewARTICLELastHourByIndex();
	    $img_p = "<img src=\"../images/last_hour_$lang.gif\" alt=\"\"/>";
	}elsif ($type_p eq 'onlyench') {
	    $string1 = viewARTICLEOnlyEnchhopIndex();
	    $string2 = loadARTICLEOnlyEnchByIndex();
	    $img_p = "<img src=\"../images/les_encheres_$lang.gif\" alt=\"\"/>";
	}elsif ($type_p eq 'onlynew') {
    	    $string1 = viewARTICLEFromShopIndex();
	    $string2 = loadARTICLEFromShopByIndex();
	    $img_p = "<img src=\"../images/des_boutiques_$lang.gif\" alt=\"\"/>";	    	
	}else {
	    $string1 = loadARTICLENews($cat,$type);			    
	    $string2 = viewARTICLENewsByIndex($cat,$type);
	    $img_p = "<img src=\"../images/tous_les_articles_$lang.gif\" alt=\"\"/>";
	    
	}
	
	my $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	open (FILE, "<$dir/main.html") or die "cannot open file $dir/main.html";    
	my $string4 = "sdfsdf";#weekNews ();
	my $selectionIndex = loadARTICLESelection();;
	my $selection = viewARTICLESelectionByIndex();;
        
	
	my $content;
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'depot'}/$string3/g;
	    s/\$IMG_NEW/$img_p/g;
	    s/\$ARTICLE{'best_offers_index'}/$string1/g;	    
	    s/\$ARTICLE{'best_offers_table'}/$string2/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'search'}//g;
	    s/\$ARTICLE{'our_selection_index'}/$selectionIndex/g;
	    s/\$ARTICLE{'our_selection_table'}/$selection/g;
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
	#print "client :" .$client;
        close (FILE);

    }	
}

sub getDepot {
    my  ($c)= sqlSelectMany("ville","depot");
    my  $cat = $query->param("cat");
    $cat=~ s/[^A-Za-z0-9 ]//;
    my  $type = $query->param("type");
    $type =~ s/[^A-Za-z0-9 ]//;
    #my  $depot = $query->param("type");
    my  $string .= "<select name=\"depot\" onchange=\"go();\">";
    
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option>$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
    	
}

sub getSelectArticleDepot {
    my  ($c)= sqlSelectMany("ville","depot");
    my  $cat = $query->param("cat");
    $cat=~ s/[^A-Za-z0-9 ]//;
    my  $type = $query->param("type");
    $type =~ s/[^A-Za-z0-9 ]//;
    #my  $depot = $query->param("type");
    my  $string .= "<select name=\"navi\" onchange=\"go();\">";
    $string .= "<option>------</option>"; 
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&amp;cat=$cat&amp;type=$type&amp;depot=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
    	
}

sub loadSport {
	my $category = $query->param("category");my $submenu;
	if ($category) {$submenu = loadSportSubMenu();}
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $sport_menu = loadSportMenu();
	my $index = loadSportIndex();
	my $table = loadSportByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	open (FILE, "<$dir/sport.html") or die "cannot open file $dir/sport.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;s/\$SELECT{'sport_menu'}/$sport_menu/g;
	    s/\$SELECT{'sport_submenu'}/$submenu/g;s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$ARTICLE{'index'}/$index/g;s/\$ARTICLE{'table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g;s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
        close (FILE);	
}


sub showImage {
    
    my  $image = $query->param('image');
    my  $URL = "../upload/$image.jpg";
    my $content;
    open (FILE, "<$dir/show_image.html") or die "cannot open file $dir/show_image.html";
    while (<FILE>) {s/\$ARTICLE{'url_image'}/$URL/g;$content .= $_;}
        print "Content-Type: text/html\n\n";
        print $content;
    close (FILE);    
    return 1;
}


sub showImage2 {
    
    my  $image = $query->param('image');my  $URL = "../upload/$image";my $content;
    open (FILE, "<$dir/show_image.html") or die "cannot open file $dir/show_image.html";
    while (<FILE>) {s/\$ARTICLE{'url_image'}/$URL/g;$content .= $_;}
    $content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
    close (FILE);    
}


sub loadUpdateArticlePayPal {
	my $price_v = $query->param("price");
	my $name_a = $query->param("name");
	my $article = $query->param("article");
	my $id_a_livre = $query->param("id_a_livre");
       	open (FILE, "<$dir/update_statut_article_paypal.html") or die "cannot open file $dir/update_statut_article_paypal.html";
	my $content;		
	my $string2 = getCountry();
	my $cats = getCat();
	my $menu = loadMenu();
	$session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});
	my $username = $session->param("username");  
	my  ($user_name,$id_personne,$first_name,$name,$adress,$city,$npa,$email,$phone_number)=sqlSelect("nom_utilisateur,prenom,nom,adresse,ville,npa,email,no_telephone", "personne",
				       "nom_utilisateur = '$username'");
        my  ($montant,)= sqlSelect("montant,a_paye.quantite",
	    			    "article,personne,a_paye,condition_payement_libelle_langue,condition_livraison_libelle_langue",
				   "ref_article = id_article AND id_article = $article AND a_paye.ref_statut = '8' AND a_paye.ref_condition_payement = ref_condition_payement AND a_paye.ref_condition_livraison  =  ref_condition_livraison AND ref_condition_livraison <> 8 ");	
	
	my $url;
	#my $crypt = MyCrypt->new( debug => 0 );
	$url .= "http://avant-garde.no-ip.biz/cgi-bin/recordz.cgi?lang=$lang&session=$session_id&page=sucess_payed&";
	#my $enc   = $crypt->encrypt("username=$username&article=$article", 'secret234234');
	#$url .= $enc;
	while (<FILE>) {
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'register_itemname'}/$name_a/g;
	    s/\$ARTICLE{'register_id'}/$article/g;
	    s/\$ARTICLE{'register_amount'}/$montant/g;
	    s/\$ARTICLE{'register_firstname'}/$first_name/g;
	    s/\$URL/$url/g;
	    s/\$ARTICLE{'register_lastname'}/$name/g;
	    s/\$ARTICLE{'register_adress'}/$adress/g;
	    s/\$ARTICLE{'register_city'}/$city/g;
	    s/\$ARTICLE{'register_npa'}/$npa/g;
	    s/\$ARTICLE{'register_email'}/$email/g;
	    s/\$ARTICLE{'register_phone'}/$phone_number/g;
	    s/\$COUNTRY/$string2/g;
	    s/\$ARTICLE{'register_username'}/$username/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
	}
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);	    	    	
}


sub loadSearchAnimal {
	my $content;
	my $categories = loadSearchAnimalCategory();
	my $category = $query->param("category");
	my $subcat;	
	my $subcats = $query->param("subcat");
	my $author;
	if ($category) {$subcat = loadSearchAnimalSubCategory();}

	open (FILE, "<$dir/search_animal.html") or die "cannot open file $dir/search_animAy.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'auteur'}/$author/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);
    
}
sub loadSearchArt {
	my $content;
	my $categories = loadSearchArtCategory();
	my $category = $query->param("category");
	my $subcat;	
	my $subcats = $query->param("subcat");
	my $author;
	if ($category) {$subcat = loadSearchArtSubCategory();}
	if ($subcats) {$author =  loadSearchArtSubAuthor();}
	open (FILE, "<$dir/search_art.html") or die "cannot open file $dir/search_art.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'auteur'}/$author/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);
}


sub loadSearchWatch {
    my $content;    
    my $categories = loadSearchWatchCategory();
    my $subcats;
    my $fabricants;
    $subcats = loadSearchWatchSubCategory ();
    $fabricants = loadSearchWatchFabricant();
    my $properties = loadSearchWatchProperties ();
    my $used = loadSearchUsed();
    open (FILE, "<$dir/search_watch.html") or die "cannot open file $dir/search_watch.html";    
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SELECT{'subcategories'}/$subcats/g;
	s/\$SELECT{'categories'}/$categories/g;
	s/\$SELECT{'fabricants'}/$fabricants/g;
	s/\$ARTICLE{'properties'}/$properties/g;	
	s/\$ARTICLE{'used'}/$used/g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }
    print "Content-Type: text/html\n\n";
    print $content;
    close (FILE);

    
}

sub loadSearchWear {} {
    my $content;    
    my $categories = $lp->loadSearchWearCategories();
    my $subcategories  = $lp->loadSearchWearSubCategories();
    my $fabricants = $lp->loadSearchWearFabricants();
    my $properties = $lp->loadSearchWearProperties ();
    my $used ;#= $lp->loadSearchUsed();
    open (FILE, "<$dir/search_wear.html") or die "cannot open file $dir/search_wear.html";    
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	s/\$ERROR{'([\w]+)'}//g;	
	s/\$SELECT{'subcategory'}/$subcategories/g;
	s/\$SELECT{'category'}/$categories/g;
	s/\$SELECT{'fabricant'}/$fabricants/g;
	s/\$SELECT{'properties'}/$properties/g;	
	s/\$ARTICLE{'used'}/$used/g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }
    print "Content-Type: text/html\n\n";
    print $content;
    close (FILE);
}

sub loadSearchCigares {
    my $content;    
    my $categories = loadSearchCigaresCategories();
    my $subcats = loadSearchCigaresSubCategories();
    my $fabricants = loadSearchCigaresFabricant();
    my $properties = loadSearchCigaresProperties ();
    my $used = loadSearchUsed();
    open (FILE, "<$dir/search_cigares.html") or die "cannot open file $dir/search_cigares.html";    
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SELECT{'subcategories'}/$subcats/g;
	s/\$SELECT{'categories'}/$categories/g;
	s/\$SELECT{'fabricants'}/$fabricants/g;
	s/\$ARTICLE{'properties'}/$properties/g;
	s/\$ARTICLE{'used'}/$used/g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }
    print "Content-Type: text/html\n\n";
    print $content;
    close (FILE);
}

sub loadCigares {
	my $content;
	my $menu = loadMenu();	
	my $cats = getCat();
	my $cigares_cat = loadCigaresCategories();
	my $index = loadCigaresIndex();
	my $table = loadCigaresByIndex();
	my $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my $username = $session->param("username");
         if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
        }


	open (FILE, "<$dir/cigares.html") or die "cannot open file $dir/cigares.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$SELECT{'cigares_menu'}/$cigares_cat/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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


sub loadAstro {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my $content;
    my $cats = getCat();
    my $menu_cat = loadAstroCategory ();
    my $subcats;
    my $index = loadAstroIndex();
    my $table = loadAstroByIndex();
    if ($category ) {
	#$subcat = loadAstroSubCategory();	
    }
    my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
    my  $username = $session->param("username");
    my $b;

    if ($username) {
	my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	if ($type_de_compte eq '2') {
	    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	}
    }
    
    my $menu = loadMenu();
    open (FILE, "<$dir/astro.html") or die "cannot open file $dir/astro.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'astro_cat'}/$menu_cat/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n"; print $content;
        close (FILE);
    
}

sub loadGames {       
	my $category = $query->param("category");my $subcat   = $query->param("subcat");
	my $submenu;my $game_type;
	if ($category) {
		$submenu = loadGamesSubMenu();
		my  ($catID)=sqlSelect("id_categorie", "categorie_$lang", "nom = '$category'");
		if ($catID eq '29') {$game_type = loadGamesType();}
	}
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $games_menu = loadGamesMenu();
	my $index = loadGamesIndex();
	my $table = loadGamesByIndex();
	open (FILE, "<$dir/games.html") or die "cannot open file $dir/games.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;s/\$SELECT{'consoles_menu'}/$games_menu/g;
	    s/\$SELECT{'games_category_menu'}/$submenu/g;s/\$SELECT{'game_type'}/$game_type/g;
	    s/\$OPTIONS{'categories'}/$cats/g;s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;s/\$ERROR{'([\w]+)'}//g;s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n"; print $content;
        close (FILE);
}

sub loadCalendrier {
	my $category = $query->param("category");
	my $submenu;	
	if ($category) {$submenu = getMotoSubCategory();}
	my $content;
	my $cats = getCat();
	my $subcats = getCalendrierSearchSubCategory();
	my $menu = loadMenu();
	my $sport_menu = getCalendrierCategory();
	my $index = loadCalendrierIndex();
	my $table = loadCalendrierByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/calendrier.html") or die "cannot open file $dir/calendrier.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'calendrier_cat'}/$sport_menu/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SELECT{'calendrier_subcat'}/$subcats/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'index'}/$index/g; s/\$ARTICLE{'table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g; s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
        close (FILE);			
}

sub loadSearchInstruments {
    my $content;
    my $category = loadSearchInstrumentsCategory();
    my $cat = $query->param("category");
    my $fab = loadFabricant();
    if ($cat) {
	$fab = loadSearchInstrumentsFabricant();
    }
    open (FILE, "<$dir/search_instruments.html") or die "cannot open file $dir/search_instruments.html";
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SELECT{'category'}/$category/g;
	s/\$SELECT{'fab'}/$fab/g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }
    print "Content-Type: text/html\n\n";
    print $content;
    close (FILE);    

}

sub loadSearchCollection {
    my $content;
    my $category = loadSearchCollectionCategory();
    my $cat = $query->param("category");
    my $subcat;
    if ($cat) {
	$subcat = loadSearchCollectionSubCategory ();
    }
    loadSearchCollectionFabricant();
    open (FILE, "<$dir/search_collection.html") or die "cannot open file $dir/search_collection.html";
    while (<FILE>) {	
	s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	s/\$ERROR{'([\w]+)'}//g;
	s/\$SELECT{'category'}/$category/g;
	s/\$SELECT{'subcat'}/$subcat/g;
	s/\$SESSIONID/$session_id/g;
	$content .= $_;	
    }
    print "Content-Type: text/html\n\n";
    print $content;
    close (FILE);    
}

sub loadSearchCalendar {
	my $content;
	my $categories = loadSearchCalendarCategory();
	my $category = $query->param("category");my $subcat;
	if ($category) {
	    $subcat = loadSearchCalendarSubCategory();
	}
	my $author;
	open (FILE, "<$dir/search_calendar.html") or die "cannot open file $dir/search_calendar.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);	
    
}

sub loadSearchJardin {
	my $content;
	my $categories = loadSearchJardinCategory();
	my $category = $query->param("category");my $subcat;
	if ($category) {
	    $subcat = loadSearchJardinSubCategory();
	}
	my $fabricants = loadSearchJardinFabricants();
	my $used = loadSearchJardinUsed();
	my $valeur = loadSearchJardinValeur();
	open (FILE, "<$dir/search_jardin.html") or die "cannot open file $dir/search_jardin.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SELECT{'auteur'}/$fabricants/g;
	    s/\$ARTICLE{'valeur'}/$valeur/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);	
}

sub loadSearchBaby {
	my $content;
	
	my $categories = loadSearchBabyCategory();
	my $category = $query->param("category");my $subcat;
	if ($category) {
	    $subcat = loadSearchBabySubCategory();
	}
	my $fab;
	if ($subcat) {
	    $fab = loadSearchBabyFabricant();
	}
	
	my $author;
	my $used = loadSearchGamesUsed();
	open (FILE, "<$dir/search_baby.html") or die "cannot open file $dir/search_baby.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SELECT{'fab'}/$fab/g;
	    s/\$SELECT{'used'}/$used/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);	
}

sub loadSearchParfum {
	my $content;
	my $categories = loadSearchParfumCategory();
	my $category = $query->param("category");
	my $fab;
	my $subcat = $query->param("subcategory");	
	if ($category) {
	    $subcat = loadSearchParfumSubCategory();
	}
	if ($subcat) {
	   $fab =  loadSearchParfumFabricant();
	}
	my $author;
	open (FILE, "<$dir/search_parfum.html") or die "cannot open file $dir/search_parfum.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SELECT{'auteur'}/$fab/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);	
}

sub loadSearchLingerie {
	my $content;
	my $categories = loadSearchLingerieCategory();
	my $category = $query->param("category");
	my $subcategory = $query->param("subcat");
	my $subcat;my $fabricant;
	
	if ($category) {
	    $subcat = loadSearchLingerieSubCategory();
	}
	if ($subcat) {
	    $fabricant = loadSearchLingerieFabricant ();
	}
	my $author;
	open (FILE, "<$dir/search_lingerie.html") or die "cannot open file $dir/search_lingerie.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'category'}/$categories/g;
	    s/\$SELECT{'subcat'}/$subcat/g;
	    s/\$SELECT{'fabricant'}/$fabricant/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);	
    
}

sub loadCollection {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $categories = loadCollectionCategory();
	my $index = loadCollectionIndex ();
	my $table = loadCollectionByIndex ();;
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	open (FILE, "<$dir/collection.html") or die "cannot open file $dir/collection.html";    	
	while (<FILE>) {		    
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$ARTICLE{'collection_index'}/$index/g;
	    s/\$ARTICLE{'collection_table'}/$table/g;
	    s/\$SELECT{'collection_cat'}/$categories/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
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
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $categories = loadAnimalCategory();my $sub;
	if ($query->param("category")) {$sub = loadAnimalSubCategory ();}
	my $index = loadAnimalIndex();
	my $table = loadAnimalByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/animal.html") or die "cannot open file $dir/animal.html";    	
	while (<FILE>) {		    
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'animal_cat'}/$categories/g;
	    s/\$SELECT{'animal_subcat'}/$sub/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$ARTICLE{'animal_index'}/$index/g;
	    s/\$ARTICLE{'animal_table'}/$table/g; 
	    s/\$SELECT{'collection_cat'}/$categories/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    $content .= $_;	
	}
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);	        
}

sub loadLonger {
    my $account = $query->param("account_type");
    my $time_r = $query->param("time");
    my $time;
    my $price;
    my  ($d)= sqlSelect("id_type_de_compte","type_de_compte_$lang","nom = '$account'");
    if ($d eq '2' or $d eq '3' or $d eq '4' or $d eq '5') {
	$time = loadRegisterLongerTime();
    }
    if ($time) {
	$price = loadRegisterLongerPrice();
    }
    my  $cat = loadRegisterLongerTypeAccount();
    my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );     
    my $username = $session->param("username");
    my $ip = $session->param("ip");
    my $content;
    my $year  ;
    my $month ;
    my $year_add;
    my $month_add;
    my $day_add;
    my $date_end;
    my $tmp;
    if ($username && ($ip eq $current_ip)) {
       
       ($VALUE{'ref_type_de_compte'},$VALUE{'date_expiration'})= sqlSelect("ref_type_compte,date_expiration",
					 "personne","nom_utilisateur = '$username'");	
       ($VALUE{'account'}) = sqlSelect("nom","type_de_compte_$lang","id_type_de_compte = $VALUE{'ref_type_de_compte'}");
       if ($query->param("account_type")) {
	$tmp = $VALUE{'date_expiration'};
       }
       $year  = substr($tmp,0,4);
       $month = substr($tmp,5,2);     
       &Date_Init("TZ=US/Eastern");
       if ($time_r  eq '12 mois' or $time_r eq '12 month' or $time_r eq '12 monat' or $time_r eq 'mese') {    
	    $date_end  =  &DateCalc($tmp, "+ 1 year" );
	    $year_add  = substr($date_end,0,4);
	    $month_add = substr($date_end,4,2);
	    $day_add   = substr($date_end,6,2);
	    $date_end = "$year_add-$month_add-$day_add";
       }else {
	    $date_end =  &DateCalc($tmp,  "+ 1 month");	    
	    $year_add  = substr($date_end,0,4);
	    $month_add = substr($date_end,4,2);
	    $day_add   = substr($date_end,6,2);
	    $date_end = "$year_add-$month_add-$day_add";
	}       	  
	open (FILE, "<$dir/longer.html") or die "cannot open file $dir/longer.html";
	while (<FILE>) {
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$SELECT{'cat'}/$cat/g;
	    s/\$SELECT{'time'}/$time/g;
	    s/\$SELECT{'date_start'}/$VALUE{'date_expiration'}/g;
	    s/\$SELECT{'date_end'}/$date_end/g;
      	    s/\$SELECT{'price'}/$price/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$LANG/$lang/g;
	    $content .= $_;	
	}
	print "Content-Type: text/html\n\n"; 
	print $content;

    close (FILE);    
	
    }
}

sub loadInstrument {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	my $categories = loadInstrumentCategory();
	my $index      = loadInstrumentIndex ();
	my $table      = "";#loadInstrumentByIndex ();
	open (FILE, "<$dir/muzik_instruments.html") or die "cannot open file $dir/muzik_instruments.html";    	
	while (<FILE>) {		    
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'instru_index'}/$index/g;
	    s/\$ARTICLE{'instru_table'}/$table/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$SELECT{'instru_cat'}/$categories/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
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


sub loadFondation {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $categories = loadCollectionCategory();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/fondation.html") or die "cannot open file $dir/fondation.html";    	
	while (<FILE>) {		    
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'collection_cat'}/$categories/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
	}
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);	    
}

sub loadLingerie {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $categories = loadLingerieCategory();
	my $index = loadLingerieIndex ();
	my $table = loadLingerieByIndex ();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/lingerie.html") or die "cannot open file $dir/lingerie.html";    	
	while (<FILE>) {		    
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$SELECT{'lingerie_cat'}/$categories/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
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


sub loadTarif {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
         if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
        }
	
	open (FILE, "<$dir/tarifs.html") or die "cannot open file $dir/tarifs.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;

	    s/\$ARTICLE{'search'}//g;
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

sub loadAnalyze {
    my $content;
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
         if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
        }

    open (FILE, "<$dir/analyze.html") or die "cannot open file $dir/analyze.html";
    while (<FILE>) {
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    $content .= $_;	
    }
    	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);
}


sub loadChocolat {
	my $content;
	my $menu = loadMenu();	
	my $cats = getCat();
	my $chocolat_menu = loadChocolatMenu();
	my $index = loadChocolatIndex();
	my $table = loadChocolatByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
         if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
        }


	open (FILE, "<$dir/chocolat.html") or die "cannot open file $dir/chocolat.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$SELECT{'chocolat_menu'}/$chocolat_menu/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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

sub loadCaviar {
	my $content;
	my $menu = loadMenu();	
	my $cats = getCat();
	my $cigares_cat = loadCigaresCategories();
	my $index = loadCaviarIndex();
	my $table = loadCaviarByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
         if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		    $LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
        }	
	open (FILE, "<$dir/caviar.html") or die "cannot open file $dir/caviar.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ARTICLE{'index'}/$index/g;   s/\$ARTICLE{'table'}/$table/g;
	    s/\$SELECT{'cigares_menu'}/$cigares_cat/g;    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$OPTIONS{'categories'}/$cats/g;    s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'} /$LINK{'add_deal'}/g;
	    s/\$ERROR{'([\w]+)'}//g; $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
        close (FILE);					
}

sub loadParfum {
	my $content;
	my $menu = loadMenu();	
	my $cats = getCat();
	my $parfum_menu = loadParfumCategory();
	my $cat = $query->param ("category");
	my $sub;
	if ($cat) {
		$sub = loadParfumSubCategory();
	}
	my $index = loadParfumIndex();
	my $table = loadParfumByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/parfum.html") or die "cannot open file $dir/parfum.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'parfum_menu'}/$parfum_menu/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$SELECT{'sub_menu'}/$sub/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ERROR{'([\w]+)'}//g;
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
	my $category = $query->param("category");my $submenu;	
	if ($category) {$submenu = getArtAndDesignSubCategory();}
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $sport_menu = getArtAndDesignCategory();
	my $index = loadArtIndex();
	my $table = loadArtByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/art_design.htlm") or die "cannot open file $dir/art_design.htlm";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'art_cat'}/$sport_menu/g;
	    s/\$SELECT{'art_subcat'}/$submenu/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'art_index'}/$index/g;s/\$ARTICLE{'art_table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g;s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    $content .= $_;	
        }
	print "Content-Type: text/html\n\n";
	print $content;
        close (FILE);		
}

sub loadMoto {
	my $category = $query->param("category");my $submenu;	
	if ($category) {$submenu = getMotoSubCategory();}
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $sport_menu = getMotoCategory();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}

	my $index = loadMotoIndex();
	my $table = loadMotoByIndex();
	open (FILE, "<$dir/moto.html") or die "cannot open file $dir/moto.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g; s/\$SELECT{'moto_cat'}/$sport_menu/g;
	    s/\$SELECT{'moto_subcat'}/$submenu/g;s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'moto_index'}/$index/g; s/\$ARTICLE{'moto_table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g; s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
        close (FILE);			
}

sub loadBaby {
	my $category = $query->param("category");my $submenu;	
	if ($category) {$submenu = getBabySubCategory();}
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $sport_menu = getBabyCategory();
	my $index = loadBabyIndex();
	my $table = loadBabyByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/bebe.html") or die "cannot open file $dir/bebe.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g; s/\$SELECT{'bb_cat'}/$sport_menu/g;
	    s/\$SELECT{'bb_subcat'}/$submenu/g;s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'bb_index'}/$index/g; s/\$ARTICLE{'bb_table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g; s/\$SESSIONID/$session_id/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
        close (FILE);			
    
}

sub loadWatch {
	my $content;
	my $category = loadWarchCategory();
	my $menu = loadMenu();
	my $cats = getCat();
	my $subcat;
	my $cat = $query->param("category");
	if ($cat) {
		$subcat = loadWarchSubCategory ();
	}
	my $index = loadWatchAndJewelsIndex();
	my $table = loadWatchAndJewelsByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	
	open (FILE, "<$dir/watch.html") or die "cannot open file $dir/watch.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'watch_subcat'}/$subcat/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SELECT{'watch_menu'}/$category/g;
	    s/\$ERROR{'([\w]+)'}//g;
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

sub loadBoat {
	my $content;
	my $cats = getCat();
	my $menu = loadBoatMenu();
	my $menu2 = loadMenu();
	my $index = loadBoatIndex();
	my $table = loadBoatByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }

	
	open (FILE, "<$dir/boat.html") or die "cannot open file $dir/boat.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu2/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$SELECT{'boat_menu'}/$menu/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'search'}//g;
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

sub loadDvd {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $dvd_menu = loadDvdCategories();
	my $index = loadDvdIndex();
	my $table = loadDvdByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	open (FILE, "<$dir/dvd.html") or die "cannot open file $dir/dvd.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'dvd_menu'}/$dvd_menu/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'search'}//g;
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

sub loadBook {
	my $content;
	my $cats = getCat();
	my $menu = loadMenu();
	my $dvd_menu = loadBookCategories();
	my $index = loadBookIndex();
	my $table = loadBookByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	open (FILE, "<$dir/book.html") or die "cannot open file $dir/book.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$SELECT{'book_menu'}/$dvd_menu/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$SESSIONID/$session_id/g;
	    s/\$ARTICLE{'search'}//g;
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


sub loadEvalProduct {
	my $content;
	my $article = $query->param("article");
	my $buyer = $query->param("article");
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");
	my $b;
	if ($username) {
	    my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
	    if ($type_de_compte eq '2') {
		$b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	    }
	}
	my $userID = getUserID($username);
    	open (FILE, "<$dir/evalproduct.html") or die "cannot open file $dir/evalproduct.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ARTICLE{'id_article'}/$article/g;
	    s/\$ARTICLE{'buyer_id'}/$userID/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$LINK{'add_deal'}/$b/g;
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

sub loadLastBuyers {
	my $content;
	my $article = $query->param("article");
	my $index = loadLastBuyersIndex ();
	my $table = loadLastBuyersByIndex();

	open (FILE, "<$dir/last_buyers.html") or die "cannot open file $dir/last_buyers.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;
	    s/\$ARTICLE{'search'}//g;
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

sub loadWine {
	my $content;
	my $category = loadInfoCategory();	
	my $menu = loadMenu();
	my $cats = getCat();
	my $countrySelect = loadWineCountry();
	my $wine_type = loadWineType();
	my $index = loadWineIndex();
	my $table = loadWineByIndex();
	my  $session = new CGI::Session( "driver:File", $session_id,  {Directory=>"$session_dir"} );	
	my  $username = $session->param("username");

	    my $b;
	    if ($username) {
		my  ($type_de_compte)= sqlSelect("ref_type_compte","personne","nom_utilisateur = '$username'");
		if ($type_de_compte eq '2') {
		    $b .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
		}
	    }
	
	open (FILE, "<$dir/wine.html") or die "cannot open file $dir/wine.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'search'}//g;
	    s/\$SELECT{'wine_cat'}/$countrySelect/g;
	    s/\$SELECT{'wine_type'}/$wine_type/g;
	    s/\$LINK{'add_deal'}/$b/g;
	    s/\$ARTICLE{'category'}/$category/g;
	    #s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ARTICLE{'index'}/$index/g;
	    s/\$ARTICLE{'table'}/$table/g;	    
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

sub loadSearchInfo {
	my $content;
	my $category = loadInfoCategory();	
	my $fabricant;
	my $info_properties;
	my $cat = $query->param("category");
	if ($query->param("category")) {
		$fabricant = loadInfoFabricant ();
	}
	my  ($subcatID)=sqlSelect("id_subcategorie", "subcategorie_$lang", "nom = '$cat'");
	if ($subcatID eq '16' or $subcatID eq '17' or $subcatID eq '18') {
		$info_properties = loadSearchInfoPcProperties();
	}elsif ($subcatID eq '15') {
		$info_properties = loadSearchInfoEcranDimension();
	}
	my $properties = loadAutoSearchProperties();
	my $type = loadSearchAutoCar();
	open (FILE, "<$dir/search_info.html") or die "cannot open file $dir/search_info.html";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;
	    s/\$ARTICLE{'loyer_properties'}/$properties/g;
	    s/\$ARTICLE{'fabricant'}/$fabricant/g;
	    s/\$ARTICLE{'type'}/$type/g;
	    s/\$ARTICLE{'search'}//g;
	    s/\$ARTICLE{'category'}/$category/g;
	    s/\$ARTICLE{'pc_properties'}/$info_properties/g;
	    #s/\$ARTICLE{'week_news'}/$string4/g;
	    s/\$LINK{'admin'}/$LINK{'admin'}/g;
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

sub loadSearchDVD {
	my $content;
	my $categories = loadSearchDvdCategories();
	my $properties = loadSearchDvdProperties();
	my $used = loadSearchCdUsed();
	open (FILE, "<$dir/search_dvd.html") or die "cannot open file $dir/search_dvd.html";    
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;s/\$LANG/$lang/g;
	    s/\$ERROR{'([\w]+)'}//g;s/\$SELECT{'dvd_categories'}/$categories/g;
	    s/\$ARTICLE{'dvd_properties'}/$properties/g;s/\$ARTICLE{'used'}/$used/g;
	    s/\$SESSIONID/$session_id/g;
	    $content .= $_;	
        }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip;print "Content-Length: ", length($content) , "\n";print "Content-Encoding: gzip\n" ;print "Content-Type: text/html\n\n";print $content;
        close (FILE);
	
}

BEGIN {
    use Exporter ();
  
    @LoadPage::ISA = qw(Exporter);
    @LoadPage::EXPORT      = qw(loadSearchDVD loadSearchInfo loadWine loadLastBuyers loadEvalProduct loadBook loadDvd loadBoat loadWatch loadBaby loadMoto loadArtAndDesign loadParfum loadCaviar loadChocolat loadCigares loadAnalyze loadTarif loadLingerie loadFondation loadInstrument loadLonger loadAnimal loadCollection loadSearchLingerie loadSearchParfum loadSearchBaby loadSearchJardin loadSearchCalendar loadSearchCollection loadSearchInstruments loadCalendrier loadGames loadAstro loadSearchWatch loadSearchArt loadSearchAnimal loadUpdateArticlePayPal showImage2 showImage loadSport getSelectArticleDepot getDepot loadPage);
    @LoadPage::EXPORT_OK   = qw();
}


