#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use CGI;
use Time::HiRes qw(gettimeofday);
use Article;
use DBI;
use MyDB;
use LoadProperties;
use ImageManipulation;
use CGI::Lite;
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
my $the_key2 = "otherbla2938478hafajdvvjbbcBJHHJgudsa";
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
if ($action eq 'login') {
    loginTest();
}else {
    loadLogin();
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

sub loadLogin {
   open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";    	
	my $selectionIndex = $articleClass->loadArticleSelection();;
	my $selection = $articleClass->viewArticleSelectionByIndex();;
	my $menu = $lp->loadMenu();
	
	my $categoriesTosearch = $lp->loadCategories();
	my $content;
	#$ARTICLE{'image_pub'} = loadPublicite();
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
	    #s/\$ARTICLE{'image_pub'}/$ARTICLE{'image_pub'}/g;
	    $content .= $_;	
   }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
	close (FILE);
}


sub loginTest {

    my  $username = $query->param('user_name') ;
    my $u = $query->param("u");
    my $lang = lc ($query->param('lang'));
    my $char = "'";
    my  $userpassword = $query->param('user_password');
    my  $string ="";
    my $encrypted;
    my $decrypted =  &RC4(&hex2string($userpassword),$the_key2);
    my  ($user_name,$user_password,$level)= ();
    my $encrypted_password = &string2hex(&RC4($userpassword,$the_key2));
   ($user_name,$user_password,$level)=$db->sqlSelect("nom_utilisateur , mot_de_passe,level","personne", "nom_utilisateur = '$username' AND mot_de_passe='$encrypted_password'");
    
	
	if ($user_name && $user_password) {
      my $content;	   
      my $encrypted = &string2hex(&RC4($username,$the_key));
      my $cgi = CGI::Lite->new ();
      
      # Retrieve existing cookies
      my $cookies = $cgi->parse_cookies;
      my $oldcookie = defined ($cookies) ? $cookies->{USERNAME} : 'not set';              
      # Set new cookie
      print "Set-Cookie: USERNAME=$encrypted\nContent-Type: text/html\n\n";
      $articleClass->clearBasket($user_name);
	   my $string4 = $articleClass->weekNews ();
	   my $menu = loadMenu();
	   my $cats = $articleClass->getCat();
	   open (FILE, "<$dir/myaccount.html") or die "cannot open file $dir/myaccount.html";	    	
	   while (<FILE>) {	    
         s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
         s/\$LANG/$lang/g;
         s/\$ERROR{'([\w]+)'}//g;
         s/\$ARTICLE{'main_menu'}/$menu/g;
         s/\$OPTIONS{'categories'}/$cats/g;
         s/\$ARTICLE{'week_news'}/$string4/g;
         s/\$ARTICLE{'news'}/$string/g;
         s/\$LINK{'add_deal'}/$b/g;
         s/\$u/$encrypted/g;
         s/\$ARTICLE{'search'}//g;
         $content .= $_;	0
	    }
		print $content;
      close (FILE);	    
	}
    else {
      my $content;
      open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";
      $LINK{'admin'} = "";
      my $string4 = $articleClass->weekNews ();
      my $menu = $lp->loadMenu();
           my $cats = $articleClass->getCat();
      while (<FILE>) {	
          s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
          s/\$LANG/$lang/g;
          s/\$ERROR{'login_error_label'}/$SERVER{'login_error_label'}/;	    
          s/\$ERROR{'email_error_label'}//g;
          s/\$ARTICLE{'main_menu'}/$menu/g;
          s/\$OPTIONS{'categories'}/$cats/g;
          s/\$LINK{'admin'}/$LINK{'admin'}/g;
          s/\$SESSIONID/$session_id/g;
          s/\$ARTICLE{'week_news'}/$string4/g;	    
          $content .= $_;	
      }
      
      $content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
      print "Content-Length: ", length($content) , "\n";
      print "Content-Encoding: gzip\n" ;      
      print "Content-Type: text/html\n\n"; 
      print $content;
      close (FILE);
   }

}
sub login {
    my  $username = $query->param('user_name') ;
    my $u = $query->param("u");
    my $char = "'";
    my  $userpassword = $query->param('user_password');
    my  $string ="";
    my $encrypted;
    my  ($user_name,$user_password,$level)= ();
   ($user_name,$user_password,$level)=$db->sqlSelect("nom_utilisateur , mot_de_passe,level","personne", "nom_utilisateur = '$username' AND mot_de_passe='$userpassword'");
    
	
	if ($user_name && $user_password) {
      my $content;	   
      my $encrypted =&string2hex(&RC4($username,$the_key));
      my $cgi = CGI::Lite->new;
      # Retrieve existing cookies
      my $cookies = $cgi->parse_cookies;
      my $oldcookie = defined ($cookies) ? $cookies->{USERNAME} : 'not set';              
      # Set new cookie
      print "Set-Cookie: USERNAME=$encrypted\nContent-Type: text/html\n\n";
      $articleClass->clearBasket($user_name);
	   my $string4 = $articleClass->weekNews ();
	   my $menu = loadMenu();
	   my $cats = $articleClass->getCat();
	   open (FILE, "<$dir/myaccount.html") or die "cannot open file $dir/myaccount.html";	    	
	   while (<FILE>) {	    
         s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
         s/\$LANG/$lang/g;
         s/\$ERROR{'([\w]+)'}//g;
         s/\$ARTICLE{'main_menu'}/$menu/g;
         s/\$OPTIONS{'categories'}/$cats/g;
         s/\$ARTICLE{'week_news'}/$string4/g;
         s/\$ARTICLE{'news'}/$string/g;
         s/\$LINK{'add_deal'}/$b/g;
         s/\$u/$encrypted/g;
         s/\$ARTICLE{'search'}//g;
         $content .= $_;	0
	    }
		print $content;
      close (FILE);	    
	}
    else {
      my $content;
      open (FILE, "<$dir/login.html") or die "cannot open file $dir/login.html";
      $LINK{'admin'} = "";
      my $string4 = $articleClass->weekNews ();
      my $menu = $lp->loadMenu();
           my $cats = $articleClass->getCat();
      while (<FILE>) {	
          s/\$LABEL{'([\w]+)'}/ exists $SERVER{$1} ? $SERVER{$1} : $1 /eg; 
          s/\$LANG/$lang/g;
          s/\$ERROR{'login_error_label'}/$SERVER{'login_error_label'}/;	    
          s/\$ERROR{'email_error_label'}//g;
          s/\$ARTICLE{'main_menu'}/$menu/g;
          s/\$OPTIONS{'categories'}/$cats/g;
          s/\$LINK{'admin'}/$LINK{'admin'}/g;
          s/\$SESSIONID/$session_id/g;
          s/\$ARTICLE{'week_news'}/$string4/g;	    
          $content .= $_;	
      }
      $content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
      print "Content-Length: ", length($content) , "\n";
      print "Content-Encoding: gzip\n" ;      
      print "Content-Type: text/html\n\n"; 
      print $content;
      close (FILE);
   }
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
