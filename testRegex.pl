#!C:/Strawberry/perl/bin/perl.exe -w
use strict;
use warnings;
use CGI;

my $query = CGI->new ;
my $dir = "C:/Users/41786/Documents/recordz1";

showImage();

sub showImage {
    my $call = shift || '';
    my  $image = $query->param('article');
    my  $URL = "../upload/$image.jpg";
    my $ARTICLE_URL = {};
    my $content = "";
	if (defined $image) {
		open (FILE, "<$dir/show_test.html") or die "cannot open file $dir/show_test.html";
		while (<FILE>) {
			s/\$ARTICLE_URL/$URL/g;
			$content .= $_;
		}
	}
	print "Content-Type: text/html\n\n";
    print "$URL";
	print $content;
    close (FILE);    
    return 1;
}