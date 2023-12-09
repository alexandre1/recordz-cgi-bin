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
showImage();

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

