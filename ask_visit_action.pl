#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use CGI;
use Time::HiRes qw(gettimeofday);
use Article;
use DBI;
use MyDB;
use LoadProperties;
use ImageManipulation;
use POSIX qw/strftime/;

use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS ();
use Email::Simple ();
use Email::Simple::Creator ();


use vars qw (%ENV $session_dir $can_do_gzip $cookie $page $dir $dirLang $dirError $imgdir $action $t0 $session_id $ycan_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);
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
loadAskVisit();

sub loadAskVisit {
    my $article = $query->param("article");
    my $name = $query->param("name");
    my $form_by_email = $query->param("form_par_email");
    my $form_by_mobile = $query->param("form_par_mobile");
    my $form_by_phone = $query->param("form_par_phone");
    my $person_name = $query->param("person_name");
    my $person_id = $query->param("person_id");
    my $person_firstname = $query->param("firstname");
    my $person_email = $query->param("email");
    my $person_adress = $query->param("adress");
    my $person_npa = $query->param("npa");
    my $person_city = $query->param("city");
    my $person_tel_private = $query->param("tel_private");
    my $person_tel_natel = $query->param("tel_natel");
    my $comment = $query->param("comment");
    if ($article) {
                $db->sqlInsert("article_visite",
			ref_personne		=> $person_id,
			ref_article		=> $article,	    
			nom			=> $person_name,
			prenom			=> $person_firstname,
			adresse			=> $person_adress,
			npa	  		=> $person_npa,
			ville			=> $person_city,
			no_prive		=> $person_tel_private,
			email			=> $person_email,
			no_mobile 		=> $person_tel_natel,
			par_email 		=> $form_by_email,
			par_telephone 		=> $form_by_phone,
                        par_mobile 		=> $form_by_mobile			
		);
     if ($form_by_email) {
         print "Content-Type: text/html\n\n";
         print "Email demandeur de visites  $person_email";
         
         my $email = Email::Simple->create(
           header => [
                         To      => "$person_email",
                         From    => 'robot@avant-garde.no-ip.biz',
                         Subject => 'Vous avez demander une visite d \'un bien immobilier',
                     ],
           body => 'test',);
           sendmail($email, { transport => $transport });      
          ($ARTICLE{'email'})= $db->sqlSelect("email", "personne,met_en_vente", "id_personne = ref_vendeur AND ref_article = $article");           
          $email = Email::Simple->create(
           header => [
                         To      => "$ARTICLE{'email'}",
                         From    => 'robot@avant-garde.no-ip.biz',
                         Subject => "Vous avez demander une visite pour le bien immobilier suivant  ref : $article",
                     ],
           body => "Bonjour la personnne nommée $person_name, $person_firstname souhaite visiter  le bien immobilier portant la référence $article voici l\'email du demandeur : $person_email merci de prendre contact par email le  plus rapidement possible",);
           sendmail($email, { transport => $transport });      
           
           print "Close me";
      }
      if ($form_by_mobile) {
         print "Content-Type: text/html\n\n";
         print "Numéro de téléphone du demandeur : $person_tel_natel";
         
         my $email = Email::Simple->create(
           header => [
                         To      => "$person_email",
                         From    => 'robot@avant-garde.no-ip.biz',
                         Subject => 'Vous avez demander une visite d \'un bien immobilier',
                     ],
           body => 'test',);
           sendmail($email, { transport => $transport });      
          ($ARTICLE{'email'})= $db->sqlSelect("email", "personne,met_en_vente", "id_personne = ref_vendeur AND ref_article = $article");           
          $email = Email::Simple->create(
           header => [
                         To      => "$ARTICLE{'email'}",
                         From    => 'robot@avant-garde.no-ip.biz',
                         Subject => "Vous avez demander une visite pour le bien immobilier suivant  ref : $article",
                     ],
           body => "Bonjour la personnne nommée $person_name, $person_firstname souhaite visiter  le bien immobilier portant la référence $article voici le numérp de tàééphone du demandeur : $person_tel_natel  merci de prendre contact par téléphone le  plus rapidement possible",);
           sendmail($email, { transport => $transport });      
           
           print "Close me";
       }
       if ($form_by_phone) {
         print "Content-Type: text/html\n\n";
         print "Numéro de téléphone du demandeur : $person_tel_private";
         
         my $email = Email::Simple->create(
           header => [
                         To      => "$person_email",
                         From    => 'robot@avant-garde.no-ip.biz',
                         Subject => 'Vous avez demander une visite d \'un bien immobilier',
                     ],
           body => 'test',);
           sendmail($email, { transport => $transport });      
          ($ARTICLE{'email'})= $db->sqlSelect("email", "personne,met_en_vente", "id_personne = ref_vendeur AND ref_article = $article");           
          $email = Email::Simple->create(
           header => [
                         To      => "$ARTICLE{'email'}",
                         From    => 'robot@avant-garde.no-ip.biz',
                         Subject => "Vous avez demander une visite pour le bien immobilier suivant  ref : $article",
                     ],
           body => "Bonjour la personnne nommée $person_name, $person_firstname souhaite visiter  le bien immobilier portant la référence $article voici le numérp de tàééphone du demandeur : $person_tel_private  merci de prendre contact par téléphone le  plus rapidement possible",);
           sendmail($email, { transport => $transport });      
           
           print " Close me";
       }

    }

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

