#!c:/xampp/perl/bin/perl.exe
use warnings;
use CGI;
use Time::HiRes qw(gettimeofday);
my $query = CGI->new;
my $dir = "C:/Users/41786/OneDrive/Documents/recordz1/";
print $query->header; 

test();
 
sub test {
	my $counter = 1000; #Should be get from db;
	my $string = "";
	my $first_page = 0;
	my $nb_page = 0;
	my $min_index = $query->param("min_index");
	if (not defined $min_index) {
		$min_index = 0;
	}
	my $count_per_page = 10;
    open (FILE, "<$dir/test2.html") or die "cannot open file $dir/test2.html";
	my $content = "";
	my $max_index = $query->param("max_index");	
	if (not defined $max_index) {		
		$max_index = 40;
	} else {
		#$max_index = round ($counter / 40, 1);#Number of objects displayed per page.
	}		
	my $last_page = $nb_page - 1;
	my $n2 = 0;

	my $index_page = $query->param("index_page");
	if (not defined $index_page) {
		$index_page = 0;
	}
	my $previous_page = $query->param("previous_page");	
	if (not defined $previous_page) {
		$index_page = 0;
		$previous_page = 0;
	}
	my $index = 0;
	$string .= "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1\" ><-\"First page\"-></a>&#160;&nbsp;";				
	if (($index_page -1) > 0) {
		$previous_page = $previous_page - 1;
		$index_page--;
		$index--;
		$min_index = $min_index -40;
		$max_index = $max_index -40;
		$string .= "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1;min_index=$min_index&amp;max_index=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_page\" ><-\"Previous\"-></a>&#160;&nbsp;";				
	}
	for my $index ($min_index..$max_index) {						
		$next_page = $min_index + 40;
		if ($index_page < $count_per_page) {
			if (($index_page % $count_per_page) > 0) {							
				$string .= "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1&amp;min_index=$min_index&amp;max_index=$max_index&amp;index_page=$index_page&amp;previous_page=$previous_page&amp;index_page=$index_page\" ><-$index_page-></a>&#160;&nbsp;";				
			}
		}		
		$index_page++;
		$index++;
		$min_index += 40;;						
		$max_index += 40;;					
	}
	$string .= "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1;min_index=$min_index&amp;max_index=$max_index&amp;previous_page=$previous_page\" ><-\"Next\"-></a>&#160;&nbsp;";				
	while (<FILE>) {	
		s/\$ARTICLE{'index'}/$string/g;
		$content .= $_;	
	}
	print $content;
    close (FILE);
}

sub round {
    my $n = shift || '';
    my $r = sprintf("%.0f", $n);    
    return $r;
}
