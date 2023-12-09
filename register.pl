#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use CGI;
use Time::HiRes qw(gettimeofday);
use Article;
use DBI;
use MyDB;
use LoadProperties;
use ImageManipulation;

use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS ();
use Email::Simple ();
use Email::Simple::Creator ();
my $smtpserver = 'smtp.gmail.com';
my $smtpport = '587';
my $smtpuser   = 'alexjaquet@gmail.com';
my $smtppassword = 'bxwpypgecjwvvthp';

my $transport = Email::Sender::Transport::SMTPS->new({
  host => $smtpserver,
  port => $smtpport,
  ssl => "starttls",
  sasl_username => $smtpuser,
  sasl_password => $smtppassword,
});

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
my $the_key = "otherbla2938478hafajdvvjbbcBJHHJgudsa";
loadLanguage();
loadError();
#loadRegister();

if ($action eq "register") {
	#checkEmail();
	registerNewUser();
    
}elsif ($action eq "confirmRegistration") {
    confirmRegistration();
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
	    $string1 .= $tableArticle->loadARTICLELastHour();
	    $string2 .= $tableArticle->viewARTICLELastHourByIndex();
	}elsif ($type_p eq 'onlyench') {
	    $string1 .= $tableArticle->viewARTICLEOnlyEnchhopIndex();
	    $string2 .= $tableArticle->loadARTICLEOnlyEnchByIndex();
	}elsif ($type_p eq 'onlynew') {
   	    $string1 .= $tableArticle->viewARTICLEFromShopIndex();
	    $string2 .= $tableArticle->loadARTICLEFromShopByIndex();
	} else {
	    $string1 .= $articleClass->loadArticleSelection();;
	    $string2 .= $articleClass->viewArticleSelectionByIndex();;
		
   	}
    
    open (FILE, "<$dir/main.html") or die "cannot open file $dir/main.html";    	
	my $categories = loadCategories();
	my $menu .= loadMenu();
	my $content;
    
	while (<FILE>) {	
	    s/\$LABEL\{'([\w]+)'\}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
		s/\$ARTICLE{'main_menu'}/$menu/g;			
	    s/\$OPTIONS{'categories'}/$categories/g;
	    s/\$ARTICLE{'best_offers_index'}/$string1/g;
	    s/\$ARTICLE{'best_offers_table'}/$string2/g;        
	    
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
	#my $categories_account = $lp->loadRegisterTypeAccount();
	my $countries = $lp->loadRegisterCountry2();
	#my $canton = $lp->loadRegisterCanton();
	#my $time = $lp->loadRegisterTime();
	my $categoriesTosearch = $lp->loadCategories();
	my $price = $lp->loadRegisterPrice();	
	my $content;
	
	$LINK{'add_deal'} .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_deal&session=$session_id;\" class=\"menulink\" class=&{ns4class};>$SERVER{'vinyl_add_one'}</a>";
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
		s/\$ERROR{'username_label_error'}/$ERROR{'username_label_error'}/g;		
		s/\$ERROR{'first_name_error'}/$ERROR{'first_name_error'}/g;		
		s/\$ERROR{'name_error_label'}/$ERROR{'name_error_label'}/g;
		s/\$ERROR{'adress_error_label'}/$ERROR{'adress_error_label'}/g;
		s/\$ERROR{'first_name_error'}/$ERROR{'first_name_error'}/g;
		s/\$ERROR{'npa_error_not_a_number_label'}/$ERROR{'npa_error_not_a_number_label'}/g;
		s/\$ERROR{'city_error_label'}/$ERROR{'city_error_label'}/g;
		s/\$ERROR{'npa_error_label'}/$ERROR{'npa_error_label'}/g;		
		s/\$ERROR{'phone_number_label'}/$ERROR{'phone_number_label'}/g;		
		s/\$ERROR{'email_error_label'}/$ERROR{'email_error_label'}/g;		
		s/\$ERROR{'user_password_null'}/$ERROR{'user_password_null'}/g;		
		s/\$ERROR{'user_password_not_match'}/$ERROR{'user_password_not_match'}/g;
	    s/\$ARTICLE{'best_offers_index'}/$selectionIndex/g;		
	    s/\$ARTICLE{'best_offers_table'}/$selection/g;
	    s/\$OPTIONS{'categories'}/$categoriesTosearch/g;    
	    s/\$ACCOUNT_TYPE/$categories_account/g;
	    s/\$COUNTRY/$countries/g;
	    #s/\$SELECT{'time'}/$time/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$CANTON/$canton/g;	    
	    s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    s/\$SELECT{'price'}/$price/g;
	    s/\$LINK{'add_deal'}/$LINK{'add_deal'}/g;
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
    $lang = lc ($query->param('lang'));#=~ s/[^A-Za-z0-9 ]//;
    #$lang=~ s/[^A-Za-z0-9 ]//;
    open (FILE, "<$dirError/$lang.error.conf") or die "cannot open file $dirError/$lang.error.conf";    
    while (<FILE>) {
	(my  $label, my  $value) = split(/=/);
	$ERROR{$label} = $value;	
    }
    close (FILE);
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

sub checkEmail {
    my  $user_name = $query->param ('user_name');    
    my  $first_name = $query->param ('first_name');
    my  $name = $query->param ('name');
    my  $user_password = $query->param ('user_password') ;
    my  $paypal = $query->param('paypal_me');
    my  $country = $query->param ('country_name') ;
    my  $adress= $query->param ('adress_name');
    my  $city= $query->param ('city') ;
    my  $npa = $query->param ('npa') ;
    my  $phone_number= $query->param ('phone_number');
    my  $account_type = $query->param("account_type");
    my  $msn = $query->param("msn_messenger");
    my  $skype = $query->param("skype");
    my  $iban = $query->param("iban");
    my  $time = $query->param('type');
    my  $price = $query->param("price");
    my  $d = $query->param('type');
   #vérifier la correspondance entre le password et le verify sinon erreur
    my  $verify = $query->param('login_password_verify_label');
	loadLanguage();
	loadError();
	my $email = $query->param("email");
    my  ($email_db)=$db->sqlSelect("email", "personne",	
    			       "email = '$email'");
	if ($email_db ne '') {
		$ERROR{'email_error_label'} = 'ERREUR';
	}

}


sub registerNewUser {
    $lang = $query->param ('lang');    	
    loadLanguage();
    loadError();
	checkEmail();
    my  $user_name = $query->param ('user_name');    
    my  $first_name = $query->param ('first_name');
    my  $name = $query->param ('name');
    my  $user_password = $query->param ('user_password') ;
    my  $paypal = $query->param('paypal_me');
    my  $country = $query->param ('country_name') ;
    my  $adress= $query->param ('adress_name');
    my  $city= $query->param ('city') ;
    my  $npa = $query->param ('npa') ;
    my  $phone_number= $query->param ('phone_number');
    my  $email= $query->param ('email');
    my  $account_type = $query->param("account_type");
    my  $msn = $query->param("msn_messenger");
    my  $skype = $query->param("skype");
    my  $iban = $query->param("iban");
    my  $time = $query->param('type');
    my  $price = $query->param("price");
    my  $d = $query->param('type');
   #vérifier la correspondance entre le password et le verify sinon erreur
    my  $verify = $query->param('login_password_verify_label');
    
    my $error = '0';
    loadError();
    if ($email eq '') {
	$ERROR{'email_error_label'} = $ERROR{'email_label'};

	$error = '1';
    } else {
    	$ERROR{'email_error_label'} = '';
    }
    if ($user_password eq '') {
	$ERROR{'user_password_null'} = $ERROR{'user_password_null'}; $error = '1';
	}
    else {
	$ERROR{'user_password_null'} = '';
	}
    if ($verify ne $user_password) {$ERROR{'user_password_not_match'} = $ERROR{'user_password_not_match'}; $error = 1;} else {$ERROR{'user_password_not_match'} = '';}
    if ($user_name eq '') {
	$ERROR{'username_label_error'} .= $ERROR{'username_label_error'};
	$error = '1';
	}
    else {
	$ERROR{'username_label_error'} =  '';
    };
    if ($first_name eq '') {$ERROR{'first_name_error'} = $ERROR{'first_name_error'}; $error = '1';} else {$ERROR{'first_name_error'} = '';};
    if ($name eq '') {$ERROR{'name_error_label'} = $ERROR{'name_error_label'}; $error = '1';} else {$ERROR{'name_error_label'} = '';};
    if ($npa eq '') {$ERROR{'npa_error_label'} = $ERROR{'npa_error_label'}; $error = '1';} else {$ERROR{'npa_error_label'} = '';};
    if ($adress eq '') {$ERROR{'adress_error_label'} = $ERROR{'adress_error_label'}; $error = '1';} else {$ERROR{'adress_error_label'} = '';};
    if ($city eq '') {
	$ERROR{'city_error_label'} = $ERROR{'city_error_label'};
	$error = '1';
	} else {
	$ERROR{'city_error_label'} = '';
	};
    if ($phone_number  eq '') {
	$ERROR{'phone_number_label'} = $ERROR{'phone_number_label'};
	$error = '1';
	} else {$ERROR{'phone_number_label'} = '';
    };
    

    my $l = $query->param("lang");

    
    if ($email eq '' and $l eq 'FR') {
	$ERROR{'email_error_label'} = $ERROR{'email_label'};
	$error = 1;
    }
    
    my  ($nom_utilisateur)=$db->sqlSelect("nom_utilisateur", "personne",	
    			       "nom_utilisateur = '$user_name'");
  
    if ($nom_utilisateur ne '') {
	$ERROR{'username_label_error'} .= "Le nom d'utilisateur est déjà pris"; $error = '1';
	
    } 
    my  ($nom_utilisateur)=$db->sqlSelect("nom_utilisateur", "personne",	
    			       "nom_utilisateur = '$user_name'");

	my $encrypted =&string2hex(&RC4($user_password,$the_key));
    if ($nom_utilisateur eq '' and $error eq '0' and $email_from_db eq '') {
		

	    $ERROR{'email_error_label'} = '';
	    my  ($account_type_id)=$db->sqlSelect("ref_type_de_compte", "type_de_compte_libelle_langue, libelle, langue",
					   "type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND libelle.libelle = '$account_type'");
    
		$db->sqlInsert("personne",
			nom_utilisateur		=> $user_name,
			mot_de_passe		=> $encrypted,	    
			nom			=> $name,
			prenom			=> $first_name,
			adresse			=> $adress,
			npa	  		=> $npa,
			ville			=> $city,
			pays			=> $country,
			no_telephone		=> $phone_number,
			email			=> $email,
			active			=> '0',
			level			=> '1',			
			paypal_me 		=> $paypal,
			msn_messenger		=> $msn,
			iban 			=> $iban,
			skype_name 		=> $skype
		);
    
	    my  ($id_personne)=$db->sqlSelect("id_personne", "personne",
					   "nom_utilisateur = '$user_name'");
		sendNewRegistrationMailAndSms();
        loadMainPage();
	}else {
		$ERROR{'email_error_label'} = 'Email existe';
	    open (FILE, "<$dir/register_error.html") or die "cannot open file $dir/register_error.html";
	    my $content;my $s = loadRegisterCategories();
	    my $string2 = getCountry();
	    my $cats = $articleClass->getCat();
	    my $categories_account = $lp->loadRegisterTypeAccount();
        my $countries = $lp->loadRegisterCountry();
	    #my $time = $lp->loadRegisterTime();
	    #my $price = $lp->loadRegisterPrice();
	    my $menu = $lp->loadMenu();
	    
	    while (<FILE>) {
		s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
		s/\$LANG/$lang/g;
		s/\$COUNTRY/$string2/g;
		s/\$OPTIONS{'categories'}/$cats/g;
		s/\$SELECT{'categories_account'}/$s/g;
		s/\$ARTICLE{'main_menu'}/$menu/g;
		s/\$ERROR{'username_label_error'}/$ERROR{'username_label_error'}/g;
		s/\$ERROR{'login_error_label'}/$ERROR{'login_error_label'}/g;    	
		s/\$ERROR{'first_name_error'}/$ERROR{'first_name_error'}/g;
		s/\$ERROR{'name_error_label'}/$ERROR{'name_error_label'}/g;
		s/\$ERROR{'npa_error_label'}/$ERROR{'npa_error_label'}/g; 
		s/\$ERROR{'adress_error_label'}/$ERROR{'adress_error_label'}/g;
		s/\$ERROR{'city_error_label'}/$ERROR{'city_error_label'}/g;
		s/\$ERROR{'phone_number_label'}/$ERROR{'phone_number_label'}/g;
		s/\$ERROR{'email_error_label'}/$ERROR{'email_error_label'}/g;
		s/\$ERROR{'user_password_null'}/$ERROR{'user_password_null'}/g;
		s/\$ERROR{'user_password_not_match'}/$ERROR{'user_password_not_match'}/g;
		s/\$SELECT{'time'}/$time/g;
		s/\$SELECT{'price'}/$price/g;
		s/\$ARTICLE{'account_type'}/$account_type/g;
		s/\$SELECT{'time'}/$time/g;
		s/\$SELECT{'price'}/$price/g;
		s/\$ARTICLE{'user_name'}/$user_name/g;
		s/\$ARTICLE{'first_name'}/$first_name/g;
		s/\$ARTICLE{'name'}/$name/g;
		s/\$ARTICLE{'country_name'}/$country/g;
		s/\$ARTICLE{'adress_name'}/$adress/g;
  	        s/\$ACCOUNT_TYPE/$categories_account/g;
	        s/\$ARTICLE{'country'}/$countries/g;
	        s/\$SELECT{'time'}/$time/g;		
		s/\$ARTICLE{'city'}/$city/g;
		s/\$ARTICLE{'npa'}/$npa/g;
		s/\$ARTICLE{'iban'}/$iban/g;
		s/\$ARTICLE{'phone_number'}/$phone_number/g;
		s/\$ARTICLE{'email'}/$email/g;
		s/\$ARTICLE{'msn_messenger'}/$msn/g;
		s/\$ARTICLE{'skype'}/$skype/g;		
		s/\$COUNTRY/$string2/g;
		s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
		s/\$ARTICLE{'main_menu'}/$menu/g;
		s/\$SESSIONID/$session_id/g;
		$content .= $_;	
	    }
		print "Content-Type: text/html\n\n"; 
		print $content;
		close (FILE);
    }
  
}


sub getCountry {
    my $selected = $query->param("country_name");
    my  ($c)= $db->sqlSelectMany("nom",
			   "pays_present",
			   "id_pays_present = id_pays_present");	
	my  $string = "";
	my  %COUNTRY = ();
	$string .= "<select name =\"country_name\">";
	if ($selected) {
	    $string .= "<option selected VALUE=\"$selected\">$selected<option>";
	}
	while(($COUNTRY{'name'})=$c->fetchrow()) {

		$string .= "<option VALUE=\"$COUNTRY{'name'}\">$COUNTRY{'name'}</option>";

	}
    $string .= "</select>";
    return $string;
}
sub sendNewRegistrationMailAndSms {
    $lang = $query->param("lang");
    my $emailUser = $query->param("email");
    my $email = Email::Simple->create(
      header => [
                    To      => "$emailUser",
                    From    => 'robot@avant-garde.no-ip.biz',
                    Subject => 'Hi! c0der',
                ],
      body => "Click here to confirm your registration <a href=\"$host/cgi-bin/confirm.pl?action=confirmRegistration&lang=$lang&userID=$emailUser</a> n",
);

sendmail($email, { transport => $transport });
}

sub confirmRegistration {
    my  $username = $query->param ('userID');
    $username = s/[^\w ]//g;  
    sqlUpdate("personne", "nom_utilisateur='$username'",(active => '1'));    
    open (FILE, "<$dir/main.html") or die "cannot open file $dir/main.html";
    my $content;
    my  $string = loadArticleNews();
    my $menu = loadMenu();
    my $cats = getCat();
	while (<FILE>) {
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg;  s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$LANG/$lang/g;s/\$OPTIONS{'categories'}/$cats/g;
  	    s/\$ARTICLE{'news'}/$string/g;s/\$ARTICLE{'search'}//g;
	    $content .= $_;	
    }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
        close (FILE);    
}

sub loadRegisterCategories {
    my $string;
    my  ($c)= $db->sqlSelectMany("libelle.libelle","type_de_compte_libelle_langue,libelle,langue","type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $s = "<select name=\"account_type\" onchange=\"go();\">";
    my  %OPTIONS = ();
    my $selected = $query->param("account-type");
    $s .= "<option selected VALUE=\"$selected\">$selected</option>";
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $s.= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&page=register&session=$session_id&account_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$s	 .= "</select>";
    return $s;
}
#send back account information to user
sub forgetPassword {
    my  $email = $query->param('email');    
    #$email=~ s/[^A-Za-z0-9 ]//;    
    my  $string1= "";
    my  $string2= "";
    $session = new CGI::Session("driver:File", $session_id, {Directory=>"$session_dir"});
    my  ($username,$password)=sqlSelect("nom_utilisateur , mot_de_passe", "personne",
				       "email = '$email'");
    my $level = $session->param("level");  
    if ($username && $password) {
	my $string3 = getSelectArticleDepot();
	my  $Message = new MIME::Lite From =>'robot@djmarketplace.biz',
			To =>$email, Subject =>$SERVER{'msg_subscription_title'} ,
			Type =>'TEXT',
			Data =>"$SERVER{'msg_recovery'}<br><br>$SERVER{'login_username_label'} : $username<br><br>$SERVER{'login_password_label'}: $password";       
	$Message->attr("content-type" => "text/html; charset=iso-8859-1");
	$Message->send_by_smtp('localhost:25');	
	open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";
	my $content;
	my  $string = loadArticleNews();
	$string1 = loadArticleNews();
	$string2 = loadViewArticleNewsByIndex();
	my $cats = getCat();
	my $menu = loadMenu();
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ERROR{'email_error_label'}//g;
	    s/\$ERROR{'login_error_label'}/$SERVER{'pass_sent'}/g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ARTICLE{'index_table'}/$string1/g;
	    s/\$ARTICLE{'news'}/$string2/g;
	    s/\$SELECT{'depot'}/$string3/g;
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
    else {
	open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";
	my $content;
	my $menu = loadMenu();
	my $cats = getCat();
	while (<FILE>) {	
	    s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
	    s/\$LANG/$lang/g;
	    s/\$OPTIONS{'categories'}/$cats/g;
	    s/\$ERROR{'login_error_label'}//g;
	    s/\$ARTICLE{'main_menu'}/$menu/g;
	    s/\$ERROR{'email_error_label'}/$SERVER{'email_error_label'}/;
	    $content .= $_;	
	}
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);	
    
}}

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
