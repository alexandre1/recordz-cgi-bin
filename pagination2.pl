#!c:/xampp/perl/bin/perl.exe
use Data::Page;
use warnings;
my $page = Data::Page->new();
$page->total_entries(1000);
$page->entries_per_page(40);
$page->current_page(0);
 
print "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1;min_index=$min_index&amp;max_index=$page->first_page\" ><-$page->first_page-></a>&#160";
print "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1;min_index=$min_index&amp;max_index=$page->$page->first_page" ><-$page->first_page-></a>&#160";
print "<a href=\"/cgi-bin/pagination.pl?lang=FR&amp;session=1;min_index=$min_index&amp;max_index=$page->current_page\" ><-$page->current_page-></a>&#160";
