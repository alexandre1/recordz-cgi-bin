#!c:/xampp/perl/bin/perl.exe
ings;
use CGI;
use Time::HiRes qw(gettimeofday);
use LoadProperties;
use vars qw (%ENV $session_dir $can_do_gzip $cookie $page $dir $dirLang $dirError $imgdir $action $t0 $session_id $ycan_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);
my $query = CGI->new;
print $query->header; 

search();
 
sub search {
    open (FILE, "<$dir/test2.html") or die "cannot open file $dir/test2.html";
	my $string .= "<a href=\"/cgi-bin/recordz.cgi?lang=FR&amp;session=1&page=historique&amp;article=1amp;min_index=1&amp;max_index=40\" ><-1-></a>&#160;&nbsp;";		
	while (<FILE>) {	
		s/\$ARTICLE{'index'}/$string/g;
    }
	$content = Compress::Zlib::memGzip($content)  if $can_do_gzip; ;
	print "Content-Length: ", length($content) , "\n";
	print "Content-Encoding: gzip\n" ;
	print "Content-Type: text/html\n\n"; 
	print $content;
    close (FILE);
}
