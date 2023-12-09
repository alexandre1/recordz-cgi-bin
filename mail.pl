
sub loadArticleSelection {
    $lang = $query->param("lang") ;	
    my  $cat = shift || '';
    my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;
    my  $add2;
    my  $dep;
    my  %OPTIONS = ();
    my $counter = 0;
	#my  ($c)= $mydb->sqlSelecCount("count(DISTINCT article.nom),marque,label,prix, pochette",
	#		   "article,met_en_vente",
	#		   "ref_article = id_article AND met_en_vente.notre_selection = '1' AND ref_statut = '3' AND article.quantite > 0");	
	#my $counter = $c;
		
	
	my $first_page = 0;
	my $nb_page = 1000;
	my $min_index = $query->param("min_index");
	if (not defined $min_index) {
		$min_index = 0;
	}
	my $count_per_page = 10;
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
	
	$string .= "<a href=\"/cgi-bin/cgi-bin/main.pl?min_index=$min_index&amp;max_index=$max_index&amp;index_page=$index_page&page=main&amp;lang=$lang&amp;page=main&session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index\" ><-\"First page\"-></a>&#160;&nbsp;";				
	
	if (($index_page -1) > 0) {
		$previous_page = $previous_page - 1;
		$index_page--;
		$index--;
		$min_index = $min_index -40;
		$max_index = $max_index -40;
		$string .= "<a href=\"/cgi-bin/main.pl?lang=$lang&amp;page=main&session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_pagex&amp;previous_page=$previous_page\" ><-\"Previous\"-></a>&#160;&nbsp;";				
	}
	for my $index ($min_index..$max_index) {						
		$next_page = $min_index + 40;
		if ($index_page < $count_per_page) {
			if (($index_page % $count_per_page) > 0) {							
				$string .= "<a href=\"/cgi-bin/main.pl?lang=$lang&amp;page=main&session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index&amp;previous_page=$previous_page&amp;index_page=$index_pagex&amp;previous_page=$previous_pagee&amp;index_page=$index_page\"\" ><-$index_page-></a>&#160;&nbsp;";								

			}
		}		
		$index_page++;
		$index++;
		$min_index += 40;;						
		$max_index += 40;;					
	}	
	$string .= "<a href=\"/cgi-bin/main.pl?lang=$lang&amp;page=main&session=$session_id&amp;min_index_our_selection=$min_index&amp;max_index_our_selection=$max_index&amp;min_index=$min_index&amp;max_index=$max_index&amp;previous_page=$previous_page\" ><-\"Next\"-></a>&#160;&nbsp;";				
	while (<FILE>) {	
		s/\$ARTICLE{'index'}/$string/g;
		$content .= $_;	
	}
	        
	return $content;    
}