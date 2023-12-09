#!/usr/bin/perl -w
package LoadProperties;
use CGI;
use CGI::Carp qw(fatalsToBrowser);use Image::Magick; 
use Switch;use MIME::Lite;use Digest::MD5 qw(md5_hex);use DBI;use GD::Graph::bars;use GD;use Time::HiRes qw(gettimeofday);use Image::GD::Thumbnail;use Date::Manip;use DateTime;
use POSIX qw(strftime);use CGI::Session qw/-ip-match/;use Compress::Zlib; use strict;use warnings;
use Email::Valid;
use SharedVariable;

sub trimwhitespace($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

sub loadInstrumentCategory {
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","ref_categorie = '42' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("category");
    type_de_vinselected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=instruments&session=$session_id&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;        
}

sub loadLingerieCategory {
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","ref_categorie = '55' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("category");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=lingerie&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
    
}
sub loadLingerieSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, langue","ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_id_langue AND langue.key = '$key'");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("category");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=jardin&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;        
    
}

sub loadHabitatJardinCategory {
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, langue, libelle","ref_categorie BETWEEN 70 and 75 OR ref_categorie = 70 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libellle_langue.ref_langue = langue.id_langue AND langue.key = '$key' ");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("category");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=jardin&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
    
}

sub loadHabitatJardinSubCategory {
    my $category = $query->param("category");
    my ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue","ref_subcategorie = (SELECT id_categorie FROM categorie_libelle_langue, langue, libelle WHERE libelle.libelle= '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND libelle.key = '$key AND categorie_langue_libelle.ref_langue = langue.id_langue AND langue.key = '$lang')");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("category");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=jardin&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;        
}

sub loadSearchArtCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, langue, libelle",
			   "categorie_libelle_langue.ref_categorie BETWEEN 35 AND 36 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_art&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchArtSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie.ref_categorie = (SELECT id_categorie FROM categorie_libelle_langue, langue, libelle WHERE libelle.libelle  = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key')");
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcat'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_art&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchAnimalCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "categorie_libelle_langue.ref_categorie BETWEEN 66 AND 68 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'" );
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_animal&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	 
}

sub loadSearchAnimalSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("nom",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie.ref_categorie = (SELECT categorie_libelle_langue.id_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle  = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.id_langue = langue.id_langue AND langue.key = '$key')");
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcat'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_animal&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchCollectionCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue,libelle,langue",
			   "ref_categorie = 45 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_collection&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	 
}

sub loadSearchCollectionSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("nom",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_categorie = (SELECT id_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle  = '$category' AND categorie_libelle_langue.ref_libelle = libelle.libelle AMD categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key') AND subcategorie_libelle_langue.ref_categorie = categorie_libelle_langue.id_categorie = categorie.id_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("subcat");
    my $string = "$SERVER{'subcat'}<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_collection&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}


sub loadSearchInstrumentsCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "ref_categorie = 42 AND subcategorie_libelle_langue = langue.id_langue AND langue.key = '$key' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle");
    my $selected = $query->param("category");
    my $string = "<td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_instruments&session=$session_id&category=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchInstrumentsFabricant {
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue, libelle, langue",
			   "ref_categorie = (select ref_categorie from article, categorie_libelle_langue, libelle, langue where libelle.libelle = '$category' AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle) AND subcategorie_ref_libelle = (SELECT id_libelle FROM libelle WHERE libelle = '$subcat')");
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_baby&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&category=$category\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}
sub loadSearchInstruments {
    my $content;
    my $category = loadSearchInstrumentsCategory();
    my $cat = $query->param("category");
    my $fab;
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

sub loadSearchCollectionFabricant {
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue, libelle, langue",
			   "ref_categorie = (select ref_categorie from article, categorie_libelle_langue, libelle, langue where libelle.libelle = '$category' AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle) AND subcategorie_ref_libelle = (SELECT id_libelle FROM libelle WHERE libelle = '$subcat')");
        
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_baby&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&category=$category\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchJardinCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, langue, libelle",
			   "ref_categorie BETWEEN 70 and 75 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND libelle.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_jardin&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}
sub loadSearchJardinSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_lang, libelle, langue",
			   "subcategorie_libelle_lang.ref_libelle = libelle.id_libelle AND subcategorie_libelle_lang.ref_langue = langue.id_langue AND langue.key = '$key' AND ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle WHERE libelle.libelle  = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND langue.key = '$lang' categorie_libelle_langue.ref_langue = langue.id_langue)");
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcat'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_jardin&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchCalendarCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle","ref_categorie = 57 OR ref_categorie = 79 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND libelle.categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_calendar&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchCalendarSubCategory {
    my $category = $query->param("category");
    my $subcat= $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle",
			   "ref_categorie = (SELECT id_categorie FROM categorie_libelle_langue, libelle WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle) AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle");
    my $selected = $query->param("subcat");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_calendar&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}
sub loadSearchBabyCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "id_categorie BETWEEN 58 AND 59 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_baby&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchBabySubCategory {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue,libelle",
			   "ref_categorie = (SELECT id_categorie FROM categorie_libelle_langue, libelle WHERE nom  = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle) AND subcategorie.ref_subcategorie= subcategorie_libelle_langue.ref_subcactegorie = (SELECT libelle.libelle FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang")";
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcat'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_baby&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchBabyFabricant {
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue",
			   "ref_subcategorie = (select id_subcategorie from subcategorie_libellle_langue, libelle WHERE libelle.libelle= '$subcategory' AND ref_categorie = (select id_categorie from categorie_libelle_langue, libelle WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'))");
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_baby&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&category=$category\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchLingerieCategory {
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue,libelle, langue",
			   "id_categorie BETWEEN 55 AND 56 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key' AND categorie_libelle.ref.libelle = libelle.id_libelle AND libelle.libelle = '$cat'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_lingerie&session=$session_id&category=$OPTIONS{'category'}&subcat=$subcat\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchLingerieSubCategory {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle",
			   "subcategorie.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue = langue.id_langue AND langue.key = '$key' AND ref_categorie = (SELECT id_categorie FROM categorie_libelle, langue WHERE libelle.libelle  = '$category' AND categorie.ref_libelle = libelle.id_libelle) AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND libelle.key '$subcat' AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = $lang'");
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcat'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_lingerie&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchLingerieFabricant {
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue",
			   "ref_subcategorie = (select id_subcategorie from subcategorie_libelle_langue, libelle WHERE nom = '$subcategory' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle) AND article.ref_categorie = (select id_categorie from categorie_libelle_langue, libelle where libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\"  onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
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
sub loadSearchParfumCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "id_categorie = 32 OR id_categorie = 43 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<tr><td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_parfum&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}
sub loadSearchParfumSubCategory {
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle",
			   "subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND libelle.libelle = '$subcategorie' AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND ref_categorie = (SELECT id_categorie FROM categorie_libelle_langue, libelle WHERE libelle.libelle  = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    local1
    my $string = "<td>$SERVER{'subcat'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_parfum&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    	    
}

sub loadSearchParfumFabricant {
    my $category = $query->param("category");
    my $subcategory = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue",
			   "ref_subcategorie = (select id_subcategorie from subcategorie_libelle_langue, libelle WHERE libelle.libelle = '$subcategory' AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_categorie = (select id_categorie from categorie_libelle_langue, libelle where libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchImmoCountry {

    my  ($c)= sqlSelectMany("nom",
			   "pays_present",
			   "");0
    my $selected = $query->param("country");
    my $string = "<select name=\"country\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_immo&session=$session_id&country=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    	
}

sub loadImmobilierType {
    my $canton = $query->param("canton");
    my $country = $query->param("country");    
    my $immo_type = $query->param("immo_type");
    my $location_type = $query->param("location_type");
    my $departement = $query->param("departement");
    my  $string .= "";
    
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,categorie_libelle_langue, libelle, langue","subcategorie_libelle_langue.ref_categorie = categorie.id_categorie and subcategorie_libelle_langue.ref_categorie = '11' AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND langue.key = '$lang'");
    my  %OPTIONS = ();
    
    
    $string .= "<select name=\"immo_type\" onchange=\"go4();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";

    if ($immo_type) {
	$string  .= "<option selected value=\"$immo_type\">$immo_type</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_immo&session=$session_id&country=$country&canton=$canton&departement=$departement&location_type=$location_type&immo_type=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
}

sub loadSearchImmoCanton {
    my $canton = $query->param("canton");
    my $country = $query->param("country");    
    my $immo_type = $query->param("immo_type");
    my $location_type = $query->param("location_type");
    my $departement = $query->param("departement");

    my  ($c)= sqlSelectMany("nom",
			   "canton_$lang",
			   "");
    #my $selected = $query->param("country");
    my $string = "Canton:<select name=\"canton\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($canton) {
	$string  .= "<option selected value=\"$canton\">$canton</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    #$string  .= "<option selected value=\"$selected\">$selected</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_immo&session=$session_id&canton=$OPTIONS{'category'}&country=$country&immo_type=$immo_type&departement=$departement&location_type=$location_type\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}
sub loadSearchWarchSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, categorie_libelle_langue, langue",
			   "ref_categorie = id_categorie AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND ref_categorie = (SELECT categorie_libelle_langue.ref_categorie FROM categorie_libelle_langue, libelle WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle");
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcategory'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_watch&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
	
}

sub loadSearchWarchCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "id_categorie BETWEEN 17 AND  18 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_watch&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
	
}

sub loadSearchCigaresCategories {
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
	
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, langue, libellle",
			   "ref_categorie = 20 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";            
    my  %OPTIONS = ();
  
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_cigares&amp;session=$session_id&category=$OPTIONS{'category'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english&page=cigares\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadSearchCigaresFabricant {
    my $category = $query->param("category");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue",
			   "ref_subcategorie = (select ref_subcategorie from subcategorie_libelle_langue, libelle, langue where libelle.libelle = '$category' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_cigares&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&category=$category\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchCigaresProperties {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'price_min'}</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'price_max'}</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	return $string;
}

sub loadSearchBoatCategories {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue,libelle, langue",
			   "ref_categorie = 19 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle  AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
        
    my $categorie = $query->param("category");
    my $string;
    my  %OPTIONS = ();
    $string .= "<td align=\"left\">$SERVER{'category'}</td>";
    $string .= "<td align=\"left\"><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($categorie) {
	$string  .= "<option selected value=\"$categorie\" onblur=\"skipcycle=false\">$categorie</option>";
    }
    $string  .= "<option value=\"\">--------</option>";            
    while(($OPTIONS{'category'})=$c->fetchrow()) {
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_boat&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}    
    return $string;    	
}

sub loadSearchGamesMenu {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_langue_libelle, libelle, langue",
			   "id_categorie BETWEEN 28 AND 29 AND categorie_langue_libelle.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$key'" );
    my $selected = $query->param("category");
    my $string = "<td>$SERVER{'category'}</td><td><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_games&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
}

sub loadSearchGamesSubMenu {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue,categorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_categorie = categorie_libelle_langue.id_categorie AND categorie_libelle_langue  = (SELECT libelle.libelle FROM categorie_libelle_langue, langue, libelle WHERE libelle.libelle ='$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue");
    my $selected = $query->param("subcat");
    my $string = "<td>$SERVER{'subcategory'}</td><td><select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_games&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
	
}
sub loadSearchGamesType {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "type_de_jeu_libelle_langue, langue, libelle",
			   "type_de_jeu_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_jeu_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("game_type");
    my $string = "<td>$SERVER{'game_type'}</td><td><select name=\"game_type\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_games&session=$session_id&category=$category&subcat=$subcat&game_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
	
}

sub loadEditor {
	my $string;
	$string .= "<tr><td>$SERVER{'editor'}</td><td><input type=\"text\" name=\"editor\"></td>";
	$string .= "</tr>";
}

sub loadSearchGamesUsed {
	my $string;
	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle","etat_libelle_langue, langue, libelle", "etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND etat_libelle_langue.ref_libelle = libelle.id_libelle");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";}
	$string .= "</select></td></tr>";
	return $string;	
}

sub loadSearchDvdCategories {
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue", "ref_categorie = 21 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_dvd&amp;session=$session_id&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";}
    $string .= "</select>";
    return $string;    
	
}
sub loadSearchDvdProperties {
	my $string;my $actors = shift || '';my $realisator = shift || '';my $year = shift || '';my $duration = shift || '';
	$string .= "<tr><td>$SERVER{'actor'}</td><td><input type=\"text\" name=\"actor\" value=\"$actors\"></td></tr>";
	$string .= "<tr><td>$SERVER{'realisator'}</td><td><input type=\"text\" name=\"realisator\" value=\"$realisator\"></td></tr>";
	$string .= "<tr><td>$SERVER{'year'}</td><td><input type=\"text\" name=\"year\" value=\"$year\"></td></tr>";
	return $string;
}

sub loadSearchSportMenu {
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, langue, libelle","ref_categorie BETWEEN 23 AND 26 OR ref_categorie = 34 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_sport&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";}
    $string .= "</select>";
    return $string;    
}

sub loadSearchSportSubMenu {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,categorie_libelle_langue, langue, libelle","subcategorie_libelle_langue.ref_categorie = id_categorie AND categorie_libelle_langue.id_categorie_libelle_langue  = (SELECT ref_categorie FROM categorie_langue_libelle, libelle, langue WHERE libelle.libelle = '$category' AND categorie_langue_libelle.ref_libelle =  libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND subcategorie_langue_libelle.ref_libelle =  libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_sport&amp;session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}
sub loadSearchSportProperties {
	my $string;
	$string .= "<tr><td>$SERVER{'price_min'}</td><td><input type=\"text\" name=\"price_min\"></td><td>$SERVER{'price_max'}</td><td><input type=\"text\" name=\"price_max\"></td>";$string .= "</tr>";
	return $string;
}

sub loadSportMenu {
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","id_categorie BETWEEN 23 AND 26 OR id_categorie = 34 or id_categorie = 78 or id_categorie = 80 AND categorie_libelle_langue.ref_langue = langue.id_langue AND categorie_libelle_langue.ref_libelle = libelle.ref_libelle AND langue.key = '$lang' ");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=sport&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";}
    $string .= "</select>";
    return $string;    
}

sub loadSportSubMenu {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,libelle, langue, categorie_libelle_langue, libelle", "subcategorie_libelle_languue.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_categorie = (SELECT libelle.libelle FROM libelle, categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$category' and categorie_libelle.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'" ));
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=sport&amp;session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";}
    $string .= "</select>";
    return $string;    
	
}

sub getArtAndDesignCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","id_categorie = 35 or id_categorie = 36 AND categorie_libelle_langue.ref_libelle = libelle.libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=art_design&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}
sub getArtAndDesignSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue,subcategorie_libelle_langue","subcategorie_libelle_langue.ref_categorie = categorie_libelle_langue.ref_categorie = (SELECT categorie_libelle_langue_ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=art_design&amp;session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";}
    $string .= "</select>";
    return $string;    
	
}

sub loadArtIndex {
    my  $cat = shift || '';
    my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    my  $depot = $query->param("depot");
    $depot =~ s/\W//g;
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;
    my $from;
    if ($category) {$from .= ", categorie_libelle_langue, libelle, langue";
                    $add .= " AND libelle.libelle = '$category' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";
                    }
    if ($subcat) {$from .= ", subcategorie_libelle_langue";
                    $add .= " AND subcategorie_libelle_langue.id_subcategorie_libelle_langue = (SELECT libelle.libelle FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie";
                    }
    my $country_swiss = $query->param("country_swiss");my $country_france = $query->param("country_france");my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");my $with_lang_italian = $query->param("with_lang_italian");my $with_lang_english = $query->param("with_lang_english");
    my  ($c)= sqlSelect("count(id_article)","article,met_en_vente $from","ref_article = id_article AND ref_statut = '3' AND  enchere_date_fin > '$date% ' AND quantite > 0 $add AND article.ref_categorie BETWEEN 35 AND 36");			
    my  $nb_page = arrondi ($c / 40, 1);my  $min_index = '0';my  $max_index = '40';    
    for (my  $i = '0'; $i < $nb_page;$i++) {my $j;if ($i <= 9) {$j = "0$i";}else {$j = $i;}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=art_design&session=$session_id&amp;min_index=$min_index&amp;max_index=$max_index&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }        
return $string;    
}

sub loadArtByIndex {
    my  $cat = shift || '';my  $type = shift  || '';my  $depot = $query->param("depot") ;$depot=~ s/[^A-Za-z0-9 ]//;
    my  $index_start = $query->param ("min_index");$index_start=~ s/[^A-Za-z0-9 ]//;my  $index_end = $query->param ("max_index");$index_end =~ s/[^A-Za-z0-9 ]//;
    my $category = $query->param("category");my $subcat = $query->param("subcat");my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    $date = trimwhitespace($date);my  $string = "";my  $add;my $from;
    if ($category) {$from .= ", categorie_libelle_langue, libelle, langue";
                    $add .= " AND libelle.libelle = '$category' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    if ($subcat) {$from .= ", subcategorie_libelle_langue";
                    $add .= " AND subcategorie_libelle_langue.id_subcategorie_libelle_langue = (SELECT libelle.libelle FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie";
                    }
    
    if (!$index_start ) {$index_start = 0;}if (!$index_end ) {$index_end = 40;}$add .= getAdd();    
    my  ($c)= sqlSelectMany("DISTINCT article.nom,marque,prix, pochette,id_article,date_stock,article.ref_categorie,article.lieu,quantite","article,met_en_vente $from","ref_article = id_article  AND ref_statut = '3' and quantite > 0 AND  enchere_date_fin > "." '$date%' AND article.ref_categorie BETWEEN 35 AND 36 $add ORDER BY  date_stock DESC LIMIT $index_start, $index_end  ");	    
    my $i = 0;my $j = 0;
    $string .= "<table style=\"border-top-width:medium;border-top-color:#94CEFA\"><tr>";
    while( ($ARTICLE{'name'},$ARTICLE{'author'},$ARTICLE{'price'},$ARTICLE{'pochette'},$ARTICLE{'id_article'},$ARTICLE{'date'},$ARTICLE{'ref_categorie'},$ARTICLE{'article_lieu'},$ARTICLE{'quantity'})=$c->fetchrow()) {
	my $img;
	if ($ARTICLE{'pochette'} eq '') {$ARTICLE{'pochette'} = "../images/no.gif";}	
	if ($ARTICLE{'date'} eq $date) {$img = "../images/new_article.gif"}else {#$img = "../images/blank.gif"}
	my $add3;
	if ($ARTICLE{'ref_categorie'} eq '11') {$add3 = $ARTICLE{'article_lieu'};}
	$string .= "<td align=\"left\" width=\"253px\" height=\"100px\" style=\"background-image:url(../images/table_article_decoration.jpg);background-position:right bottom;background-repeat: no-repeat;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&amp;action=detailother&amp;article=$ARTICLE{'id_article'}\" class=\"menulink3\" >$ARTICLE{'name'} $add3</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;<img alt=\"\" src=\"$ARTICLE{'pochette'}\" /> <img alt=\"\" src=\"$img\" /><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ARTICLE{'price'} francs suisse <br/><br/></td>";
	$i += 1;$j += 1;
	if ($i eq 1) {$string .= "<td align=\"left\" width=\"10px\"></td>";$i = 0;}	
	if ($j eq 2) {$string .= "</tr><tr></tr><tr></tr><tr>";$j = 0;}
    }    
    $string .= "</table>";
    return $string;
    
}

sub getMotoCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue","categorie_libelle_langue.ref_categorie BETWEEN 37 AND 39 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=moto&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}
sub getMotoSubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue,subcategorie_libelle_langue","subcategorie_libelle_langues.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=moto&amp;session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}

#loadCalendrier

sub getCalendrierCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","categorie_libelle_langue.ref_categorie = 57 or categorie_libelle_langue.ref_categorie = 79 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=calendrier&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}

sub loadCalendrierIndex {
    my  $cat = shift || '';my  $type = shift || '';my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);my  $depot = $query->param("depot");$depot =~ s/\W//g;my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  $string = "";my  $index = '0';
    my  $total = '0';
    my  $add;
    my $from;
    if ($category) {$from .= " , categorie_libelle_langue, libelle, langue";
                    $add .= " AND libelle.libelle = '$category' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    }else {
	 $add .= " AND article.ref_categorie = 57 OR 79 AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    }
    if ($subcat) {$from .= ", subcategorie_libelle_langue";
         $add .= " AND subcategorie_libelle_langue.id_subcategorie_libelle_langue = (SELECT libelle.libelle FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie";
    }
    my $country_swiss = $query->param("country_swiss");my $country_france = $query->param("country_france");my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");my $with_lang_italian = $query->param("with_lang_italian");my $with_lang_english = $query->param("with_lang_english");
    my  ($c)= sqlSelect("count(id_article)","article,met_en_vente $from","ref_article = id_article AND ref_statut = '3' AND  enchere_date_fin > '$date% ' AND quantite > 0 $add  ");			
    my  $nb_page = arrondi ($c / 40, 1);my  $min_index = '0';my  $max_index = '40';    
    for (my  $i = '0'; $i < $nb_page;$i++) {my $j;if ($i <= 9) {$j = "0$i";}else {$j = $i;}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=calendar&session=$session_id&amp;min_index=$min_index&amp;max_index=$max_index&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }        
return $string;    
}

sub getBabyCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","categorie_libelle_langue.ref_categorie BETWEEN 58 AND 65 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=baby&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}
sub getBabySubCategory {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue,subcategorie_libelle_langue","ref_categorie = (SELECT id_categorie FROM categorie_$lang WHERE nom = '$category') AND ref_categorie = id_categorie");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=baby&amp;session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}




sub loadGamesMenu {
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","categorie_libelle_langue.ref_categorie BETWEEN 28 AND 29 OR categorie_libelle_langue.ref_categorie = 46 OR categorie_libelle_langue.ref_categorie = 47");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
}

sub loadGamesSubMenu {
    my $category = $query->param("category");
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,categorie_libelle_langue, libelle, langue","subcategorie_libelle_langue.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_categorie = (SELECT libelle.libelle FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle ='$category AND categorie_libelle_langue.ref_langue = langue.id_langue AND categorie_libelle_langue.ref_libelle = libelle.ref_libelle AND langue.key = '$lang')'");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}
sub loadGamesType {
    my $category = $query->param("category");my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle","type_de_jeu_libelle_langue, libelle, langue","type_de_jeu.ref_libelle = libelle.id_libelle AND type_de_jeu.ref_langue = langue.id_langue AND langue.key = '$lang');
    my $selected = $query->param("game_type");
    my $string = "<select name=\"game_type\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&session=$session_id&category=$category&subcat=$subcat&game_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}


sub loadAstroCategory {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","subcategorie_libelle_langue.ref_categorie = 77 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $string = "<select name=\"game_type\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
    if ($category) {$string  .= "<option selected value=\"$category\">$category</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&session=$session_id&category=$category&subcat=$subcat&game_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
	$string .= "</select>";
    return $string;    
	
}

sub loadAstroSubCategory {
    my $category = $query->param("category");my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, langue, libelle","subcategorie_libelle_langue.ref_libelle = libelle.ref_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang)");
    my $selected = $query->param("game_type");
    my $string = "<select name=\"game_type\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&session=$session_id&category=$category&subcat=$subcat&game_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	


sub loadAstroIndex {
    my  $cat = shift || '';my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    my  $depot = $query->param("depot");$depot =~ s/[^A-Za-z0-9 ]//;
    my $category = $query->param("category");my $subcat = $query->param("subcat");my  $string = "";my  $index = '0';my  $total = '0';my  $add;my $from;
    if ($category) {
	$from .= ",categorie_libelle_langue, libelle, langue";
	$add .= " AND articlce.ref_categorie = categorie_libelle_langue.ref_categorie AND libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";}
    if ($subcat) {
	$from .= ",subcategorie_libelle_langue ";
	$add .= " AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie AND libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    my $country_swiss = $query->param("country_swiss");my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");my $with_lang_english = $query->param("with_lang_english");
    my  ($c)= sqlSelect("count(id_article)","article,met_en_vente $from","ref_article = id_article AND ref_statut = '3' AND  enchere_date_fin > '$date% ' AND quantite > 0 $add AND (article.ref_categorie = 77)");	
    my  $nb_page = arrondi ($c / 40, 1);
    my  $min_index = '0'; my  $max_index = '40';    
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	my $j;if ($i <= 9) {$j = "0$i";}else {$j = $i;}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&session=$session_id&amp;min_index=$min_index&amp;max_index=$max_index&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }
        
return $string;    
}




sub loadDvdCategories {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_categorie = 21 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=dvd&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadBookCategories {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle, langue, libelle",
			   "subcategorie.ref_categorie = 27 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategoroie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=dvd&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadBookIndex {
    my  $cat = shift || '';
    my  $type = shift || '';
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    my  $depot = $query->param("depot");
    $depot =~ s/[^A-Za-z0-9 ]//;
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;
    my $from;
   if ($category) {$from .= ", categorie_libelle_langue, libelle, langue";
                    $add .= " AND libelle.libelle = '$category' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    if ($subcat) {$from .= ", subcategorie_libelle_langue";
                    $add .= " AND subcategorie_libelle_langue.ref_subcategorie_libelle_langue = (SELECT subcategorie_libelle_langue.ref_subcategorie FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie";
                    }
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");

    my  ($c)= sqlSelect("count(id_article)",
			   "article,met_en_vente $from",
			   "ref_article = id_article AND ref_statut = '3' AND  enchere_date_fin > '$date% ' AND quantite > 0 $add AND article.ref_categorie = 27");	
	

    my  $nb_page = arrondi ($c / 40, 1);
    my  $min_index = '0';
    my  $max_index = '40';
    
    #print "Content-Type: text/html\n\n";
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	#my $x =
	my $j;
	#print "valeur de i $i <br />";
	if ($i <= 9) {
		$j = "0$i";
	}else {
		$j = $i;
	}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=book&amp;session=$session_id&amp;min_index=$min_index&amp;max_index=$max_index&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }
        
return $string;    
}

sub loadBookByIndex {
    my  $cat = shift || '';
    my  $type = shift  || '';
    my  $depot = $query->param("depot") ;
    $depot=~ s/[^A-Za-z0-9 ]//;
    my  $index_start = $query->param ("min_index");
    $index_start=~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index");
    $index_end =~ s/[^A-Za-z0-9 ]//;
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    $date = trimwhitespace($date);
    my  $string = "";
    my  $add;
    my $from;
    if ($category) {$from .= ", categorie_libelle_langue, libelle, langue";
                    $add .= " AND libelle.libelle = '$category' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    if ($subcat) {$from .= ", subcategorie_libelle_langue";
                    $add .= " AND subcategorie_libelle_langue.ref_subcategorie_libelle_langue = (SELECT ref_subcategorie FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie";
                    }
     
    if (!$index_start ) {
	$index_start = 0;
    }
    if (!$index_end ) {
	$index_end = 40;
    }

   $add .= getAdd();    

    my  ($c)= sqlSelectMany("DISTINCT article.nom,marque,prix, pochette,id_article,date_stock,article.ref_categorie,article.lieu,quantite",
		       "article,met_en_vente $from",
		       "ref_article = id_article  AND ref_statut = '3' and quantite > 0 AND  enchere_date_fin > "." '$date%' AND article.ref_categorie = 27 $add ORDER BY  date_stock DESC LIMIT $index_start, $index_end  ");	
    
#	$string .= "<br />";
#	$string .= "<table width=\"500\" border=\"0\">";
#	$string .= "<tr>";
#	$string .= "<td align=\"left\">&nbsp;</td>";
#	$string .=  "<td align=\"left\">&nbsp;</td>";
#	$string .=  "<td align=\"leftf\">&xcvxcv;xcvxc</td>";
#	$string .=  "</tr>";

    my $i = 0;
    
    my $j = 0;
    #$string .= "<hr>";
    $string .= "<table style=\"border-top-width:medium;border-top-color:#94CEFA\"><tr>";
    
    while( ($ARTICLE{'name'},$ARTICLE{'author'},$ARTICLE{'price'},$ARTICLE{'pochette'},$ARTICLE{'id_article'},$ARTICLE{'date'},$ARTICLE{'ref_categorie'},$ARTICLE{'article_lieu'},$ARTICLE{'quantity'})=$c->fetchrow()) {
	#$string .= " <label>&nbsp;&nbsp;$ARTICLE{'genre'}</label>";
	my $img;
	if ($ARTICLE{'pochette'} eq '') {
		$ARTICLE{'pochette'} = "../images/no.gif";
	}
	
	if ($ARTICLE{'date'} eq $date) {
		$img = "../images/new_article.gif"
	}else {
		#$img = "../images/blank.gif"
	}
	my $add3;
	if ($ARTICLE{'ref_categorie'} eq '11') {
		$add3 = $ARTICLE{'article_lieu'};
	}
	#$ARTICLE{'label'}
	#$ARTICLE{'label'} .= "...";

	$string .= "<td align=\"left\" width=\"253px\" height=\"100px\" style=\"background-image:url(../images/table_article_decoration.jpg);background-position:right bottom;background-repeat: no-repeat;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&amp;action=detailother&amp;article=$ARTICLE{'id_article'}\" class=\"menulink3\" >$ARTICLE{'name'} $add3</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;<img alt=\"\" src=\"$ARTICLE{'pochette'}\" /> <img alt=\"\" src=\"$img\" /><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ARTICLE{'price'} francs suisse <br/><br/></td>";
	$i += 1;
	$j += 1;

	if ($i eq 1) {
		#$string .= "<hr>";
		$string .= "<td align=\"left\" width=\"10px\"></td>";		
		$i = 0;
	}
	
	if ($j eq 2) {
		
		$string .= "</tr>";
		$string .= "<tr>";
		$string .= "</tr>";
		$string .= "<tr>";
		$string .= "</tr>";
		$string .= "<tr>";		
		$j = 0;
	}
    }    
    $string .= "</table>";
    return $string;
    
}




sub loadSearchWatchFabricant {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($categoryID)=sqlSelect("ref_categorie", "categorie_libelle_langue, libelle", "libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue,categorie_libelle_langue",
			   "subcategorie_libelle_langue.ref_subcategorie = (select ref_subcategorie from subcategorie_libelle_langue, libelle, langue where libelle.libelle = '$subcat' and subcategorie_libelle_langue.ref_categorie = $categoryID AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_watch&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&category=$category&subcat=$subcat\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchWatchUsed {
	my $string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue,libelle, langue",
			   "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";
	return $string;
}

sub loadSearchImmoDepartement {
    my $departement = $query->param("departement");
    my $canton = $query->param("canton");
    my $country = $query->param("country");    
    my $immo_type = $query->param("immo_type");
    my $location_type = $query->param("location_type");

    my  ($c)= sqlSelectMany("nom,code",
			   "departement",
			   "");    
    my $string = "Departement:<select name=\"departement\" onchange=\"go5();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($departement) {
	$string  .= "<option selected value=\"$departement\">$departement</option>";
    }

    #$string  .= "<option selected value=\"$selected\">$selected</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'},$OPTIONS{'code'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_immo&session=$session_id&category=$OPTIONS{'category'}&country=$country&departement=$OPTIONS{'category'}&canton=$canton&immo_type=$immo_type&location_type=$location_type\">$OPTIONS{'category'}($OPTIONS{'code'})</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadSearchImmoMode {
    my $location_type = $query->param("location_type");
    my $country = $query->param("country");
    my $canton = $query->param("canton");
    my $departement = $query->param("departement");
    my $immo_type = $query->param("immo_type");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "location_ou_achat_libelle_langue, libelle, langue",
			   "location_ou_achat_libelle_langue.ref_libelle = libelle.id_libelle AND location_ou_achat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    my $string = "<select name=\"mode\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    if ($location_type) {
	$string  .= "<option selected value=\"$location_type\">$location_type</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_immo&session=$session_id&location_type=$OPTIONS{'category'}&country=$country&canton=$canton&departement=$departement&immo_type=$immo_type\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadLoyer {
	my $string;
	$string .= "";
	$string .= "<td align=\"left\">Location prix min </td><td align=\"left\"><input type=\"text\" name=\"buy_price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\"></td><td align=\"left\">Location prix max</td><td align=\"left\"><input type=\"text\" name=\"buy_price_max\" value=\"\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
	$string .= "</td></tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">Nombre de pièces :</td><td align=\"left\"><input type=\"text\" name=\"nbr_piece\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">Meublé</td><td align=\"left\"><input type=\"checkbox\" name=\"is_meubled_yes\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">Surface habitable</td><td align=\"left\"><input type=\"text\" name=\"habitable_surface\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\"></td>";
	$string .= "</tr>";

	return $string;	
}

sub loadAppartBuy {
	my $string;
	$string .= "";
	$string .= "<td align=\"left\">CHF d'achat min </td><td align=\"left\"><input type=\"text\" name=\"buy_price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\"></td><td align=\"left\">CHF d'achat max</td><td align=\"left\"><input type=\"text\" name=\"buy_price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\">";
	$string .= "</td></tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">Nombre de pièces :</td><td align=\"left\"><input type=\"text\" name=\"nbr_piece\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">Meublé</td><td align=\"left\"><input type=\"checkbox\" name=\"is_meubled_yes\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">Surface habitable</td><td align=\"left\"><input type=\"text\" name=\"habitable_surface\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" value=\"\"></td>";
	$string .= "</tr>";

	return $string;
	
}
sub loadInfoFabricant {
    my $category = $query->param("category");
    my $fabricant = $query->param("fabricant");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue, libelle, langue",
			   "ref_subcategorie = (select id_subcategorie from subcategorie_libelle_langue, libelle, langue where libelle.libelle = '$category' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'" );
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_info&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&category=$category\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    	
}

sub loadInfoCategory {
    my $category = $query->param("category");
    my $type = $query->param("type");
    
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie__libelle_langue, langue, libelle",
			   "subcategorie__libelle_langue.ref_categorie = 10 AND subcategorie__libelle_langue.ref_libelle = libelle.libelle AND subcategorie__libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    my $string .= "<td align=\"left\">$SERVER{'category'}</td>";
    $string .= "<td align=\"left\"><select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();
    
    if ($category) {
	$string  .= "<option selected value=\"$category\" onblur=\"skipcycle=false\">$category</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_info&session=$session_id&category=$OPTIONS{'category'}&type=$type\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchInfoEcranDimension {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'dimension_min'}</td><td align=\"left\"><input type=\"text\" name=\"ecran_dimension_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'dimension_max'}</td><td align=\"left\"><input type=\"text\" name=\"ecran_dimension_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'price_min'}</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'price_max'}</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue, langue, libelle",
			   "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";

	return $string;
}
sub loadSearchInfoPcProperties {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'processor_min'}</td><td align=\"left\"><input type=\"text\" name=\"processor_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'processor_max'}</td><td align=\"left\"><input type=\"text\" name=\"processor_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'ram_min'}</td><td align=\"left\"><input type=\"text\" name=\"ram_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'ram_max'}</td><td align=\"left\"><input type=\"text\" name=\"ram_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'hard_drive_min'}</td><td align=\"left\"><input type=\"text\" name=\"hard_drive_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'hard_drive_max'}</td><td align=\"left\"><input type=\"text\" name=\"hard_drive_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'price_min'}</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td><td align=\"left\">$SERVER{'price_max'}</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue,libelle, langue",
			   "etat_libelle_langue_ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";

	return $string;
	
}

sub getSearchWearSex {
    my $genre = $query->param("genre");
          
    my  $string .= "<select name=\"genre\" onchange=\"go();\" onfocus=\"skipcycle=true;\" onblur=\"skipcycle=false\">";
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","categorie_libelle_langue.ref_categorie BETWEEN 6 AND 7 AND categorie_libelle_langue.ref_libelle = libelle.libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    $string .= "<option>------</option>";    
    if ($genre) {
	$string .= "<option selected value=\"$genre\">$genre</option>";
    }

    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_wear&session=$session_id&genre=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
}	

sub getSearchWearType {
    my $genre = $query->param("genre");
    my $subcat = $query->param("subcat");
          
    my  $string .= "<select name=\"category\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","subcategorie_libelle_langue.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$genre' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue)'");
    if ($subcat) {
	$string .= "<option selected value=\"$subcat\">$subcat</option>";
    }

    $string .= "<option>------</option>"; 
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_wear&amp;type=6&session=$session_id&genre=$genre&subcat=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
}	

sub loadWearFabricant {
    my $genre = $query->param("genre");	
    my $subcat = $query->param("subcat");
    my $fabricant = $query->param("fabricant");
    
    my  ($sexID)=sqlSelect("ref_categorie", "categorie_libelle_langue, libelle, langue", "libelle.libelle = '$genre' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND  categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue ,categorie_libelle_langue",
			   "AND article.ref_categorie = $sexID AND subcategorie_libelle_langue.ref_subcategorie = (select subcategorie_libelle_langue.ref_subcategorie from subcategorie_libelle_langue where libelle.libelle = '$subcat' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    
    my $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = A

    
    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_wear&session=$session_id&fabricant=$OPTIONS{'category'}&genre=$genre&subcat=$subcat\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    return $string;    
	
}

sub loadSearchWearJeansProperties {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'size'}</td><td align=\"left\"><input type=\"text\" name=\"size\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">CHF min.</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "<td align=\"left\">CHF max.</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	return $string;
}

sub loadCdVinylMixTapeCategories {
	my $string;
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
	
	my $category = $query->param("category");
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle,langue",
			   "categorie_libelle_langue.ref_categorie BETWEEN 13 AND  15 OR categorie_libelle_langue.ref_categorie = 69 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
        if ($category) {
		$string  .= "<option selected value=\"$category\" onblur=\"skipcycle=false\">$category</option>";
	}

	my  %OPTIONS = ();
        $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
     
       while(($OPTIONS{'category'})=$c->fetchrow()) {
 	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=cd_vinyl_mixtap&session=$session_id&category=$OPTIONS{'category'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\">$OPTIONS{'category'}</option>";
	}
      $string .= "</select>";
      return $string;       	
}

sub loadCdVinylMixTapeSubCategories {
	my $category = $query->param("category");
	my $subcat = $query->param("subcat");
	my $string;
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue,libelle, langue"
			   "subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')'");
	$string = "$SERVER{'subcategory'} <select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
	my  %OPTIONS = ();
        $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
        if ($subcat) {
		$string  .= "<option selected value=\"$subcat\" onblur=\"skipcycle=false\">$subcat</option>";
	}
     , 
       while(($OPTIONS{'category'})=$c->fetchrow()) {
 	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=cd_vinyl_mixtap&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>";
	}
      $string .= "</select>";
      return $string;       	
}

sub loadSearchCdVinylMixTapeCategories {
	my $string;
	my $category = $query->param("category");
	my $production_house = $query->param("production_house");
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "id_categorie BETWEEN 13 AND  15 and categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
        if ($category) {
		$string  .= "<option selected value=\"$category\" onblur=\"skipcycle=false\">$category</option>";
	}

	my  %OPTIONS = ();
        $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
     
       while(($OPTIONS{'category'})=$c->fetchrow()) {
 	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_cd&session=$session_id&category=$OPTIONS{'category'}&production_house=$production_house\">$OPTIONS{'category'}</option>";
	}
      $string .= "</select>";
      return $string;       	
}

sub loadSearchCdVinylMixTapeSubCategories {
	my $category = $query->param("category");
	my $subcat = $query->param("subcat");
	my $production_house = $query->param("production_house");	
	my $string;
	$string .= "<td align=\"left\">$SERVER{'subcategory'}</td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_categorie = (SELECT categorie_libelle_langue.ref_categorie FROM langue, libelle, categorie_libelle_langue WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
	$string = "$SERVER{'subcategory'} <select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
	my  %OPTIONS = ();
        $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
        if ($subcat) {
		$string  .= "<option selected value=\"$subcat\" onblur=\"skipcycle=false\">$subcat</option>";
	}
     
       while(($OPTIONS{'category'})=$c->fetchrow()) {
 	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_cd&session=$session_id&subcat=$OPTIONS{'category'}&category=$category&subcat=$subcat&production_house=$production_house\">$OPTIONS{'category'}</option>";
	}
      $string .= "</select>";
      return $string;       	
}

sub loadSearchCdProperties {
	my $category = $query->param("category");
	my $subcat = $query->param("subcat");
	my $production_house = $query->param("production_house");
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'title'}</td><td align=\"left\"><input type=\"text\" name=\"cd_title\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'article_author_label'}</td><td align=\"left\"><input type=\"text\" name=\"cd_artist\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'article_label_label'}</td>";
	
	my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,categorie_libelle_langue",
			   "article.ref_categorie = categorie_libelle_langue.ref_categorie AND libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");    		
	$string .= "<td align=\"left\"><select name=\"production_house\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
        my  %OPTIONS = ();
	if ($production_house) {
		$string  .= "<option selected value=\"$production_house\" onblur=\"skipcycle=false\">$production_house</option>";
	}
        $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";    
        while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_cd&session=$session_id&production_house=$OPTIONS{'category'}&subcat=$subcat&category=$category\">$OPTIONS{'category'}</option>";
	}
        $string .= "</select>";
        $string .= "</td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'size'}</td><td align=\"left\"><input type=\"text\" name=\"size\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">CHF min.</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "<td align=\"left\">CHF max.</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	return $string;

	return $string;	
}

sub getIsEnchereDealAgain {
    my $category = $query->param ("category");
    my $load = $query->param("isencher");
    my $name = $query->param("name");
    my $article = $query->param("article");
    my $type_ecran = $query->param("type_ecran"); hm
    my $subcat= $query->param ("subcat");
    my  $string ;
    $string .="<tr>";
    $string .="<td align=\"left\"><label id=\"label_image\">$SERVER{'avec_enchere'}</label></td>";
    $string .= "<td align=\"left\"><select name=\"is_enchere\" onchange=\"go();\">";
    if ($load) {
	$string .= "<option selected value=\"$load\">$load</option>";
    }
    $string .= "<option>---------</option>";    
    $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page&session=$session_id&category=$category&isencher=$SERVER{'yes'}&category=$category&subcat=$subcat&type_ecran=$type_ecran&name=$name&article=$article\">$SERVER{'yes'}</option>";
    $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=deal_again&session=$session_id&category=$category&isencher=$SERVER{'no'}&category=$category&subcat=$subcat&type_ecran=$type_ecran&name=$name&article=$article\">$SERVER{'no'}</option>";    
    $string .= "</select>";
    $string .= "</td></tr>";
    return $string;    
}

sub loadEncherePropertiesDealAgain {
	my $category = $query->param ("category");
	my $name = $query->param("name");
	my $enchere_long = $query->param("enchere_long");        
        my $load = $query->param("isencher");
	my $subcat = $query->param("subcat");
	my $article = $query->param("article");
	my $wine_country = $query->param("wine_country");
	my $region = $query->param("region");
        my $fabricant= $query->param("fabricant");
        my $description = $query->param("description");
	my $game_type = $query->param("game_type");
        my $price=  $query->param("price");
        my $selected = $enchere_long;

	my $string;
	$ENV{TZ} = 'EST'; 
	my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
	my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;	
	my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);	
	
	
	&Date_Init("Language=French","DateFormat=non-US","TZ=FST"); #French Summer Time 
        my  $date2 = ParseDateString("aujourd'hui");

	my   $currentDate = $date;
	my   $cutoffDate  = &DateCalc($date, "+ $enchere_long jours");
	
	my $year2 = substr($cutoffDate,0,4);
	my $month2 = substr($cutoffDate,4,2);
	my $day2 = substr($cutoffDate,6,2);

	my $date_finish = "$year2-$month2-$day2";

	
	$string .="<tr>";
		$string .="<td align=\"left\">$SERVER{'debut_enchere_label'}</td>";
		$string .="<td align=\"left\"><input type=\"text\" name=\"enchere_date_start\" value=\"$date $time\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";		
	$string .="</tr>";
	$string .="<tr>";
		$string .="<td align=\"left\">$SERVER{'duree_enchere_label'}</td>";
		$string .="<td align=\"left\"><select name=\"duration_enchere\" onchange=\"go4();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
		$string .= "<option selected value=\"$selected\">$selected</option>";
		for (my $i = 1; $i < 31; $i++) {
			$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=deal_again&session=$session_id&category=$category&subcat=$subcat&isencher=$load&enchere_long=$i&wine_country=$wine_country&region=$region&name=$name&article=$article&game_type=$game_type\">$i</option>";
		}
		$string .= "</select></td>";		
	$string .="</tr>";
	$string .="<tr>";
		$string .="<td align=\"left\">$SERVER{'fin_enchere_label'}</td>";
		$string .="<td align=\"left\"><input type=\"text\" name=\"enchere_end_day\" value=\"$date_finish $time\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .="</tr>";
	
	return $string;
}


sub loadBoatMenu {
    my $category = $query->param("subcat");
    
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "ref_categorie = 19 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
        
    my $departement = $query->param("departement");
    my $string;
    my  %OPTIONS = ();
    $string .= "<select name=\"subcat\" onchange=\"go();\">";
    $string .= "<option>----------</option>";
    if ($category) {
	$string .= "<option selected value=\"$category\">$category</option>";
    }
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=boat&session=$session_id&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>;";
	}
    $string .= "</select>";
    return $string;    	
}


sub loadWatchCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "id_categorie BETWEEN 17 AND 18 AND categorie_libelle_langue.ref_libelle = libelle.libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=watch&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadWatchSubCategory {
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany"libelle.libelle",
			   "subcategorie_libelle_langue,libelle, langue",
			   "subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND subcategorie_libelle_languesubcategorie_libelle_langue.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle =  '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("subcat");
    my $string = "$SERVER{''}<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($subcat) {
	$string  .= "<option selected value=\"$subcat\">$subcat</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=watch&session=$session_id&subcat=$OPTIONS{'category'}&category=$category\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}
sub loadCigaresSubCategories {
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
	
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_categorie = 20 AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue");
        
    my %OPTIONS = ();
    my $string;
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<a  class=\"menulink\" class=&{ns4class} href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&category=$OPTIONS{'category'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english&page=cigares\">$OPTIONS{'category'}</a>&nbsp";
    }
    
    return $string;    
	
}
sub loadChocolatMenu {
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
	
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue",
			   "subcategorie_libelle_langue.ref_categorie = 40 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie.ref_langue = langue.id_langue AND langue.key = '$lang'");
        
    my  %OPTIONS = ();
    my $string;
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<a  class=\"menulink\" class=&{ns4class} href=\"/cgi-bin/recordz.cgi?lang=$lang&page=chocolat&amp;session=$session_id&category=$OPTIONS{'category'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english&page=cigares\">$OPTIONS{'category'}</a>&nbsp";
    }    
    return $string;    	
}


sub loadParfumCategory {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle,langue",
			   "id_categorie = 32 or id_categorie = 43 AND categorie_libelle_libelle.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang');
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=parfum&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}
sub loadParfumSubCategory {
    my $category = $query->param("category");	
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND subcategorie_libelle_langue.ref_categorie = (SELECT categorie_libelle_langue.ref_categorie FROM categorie_libelle_langue WHERE libelle.libelle= '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    my $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=parfum&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadWatchAndJewelsByIndex {
    my  $cat = shift || '';
    my  $type = shift  || '';
    my  $depot = $query->param("depot") ;
    $depot=~ s/[^A-Za-z0-9 ]//;
    my  $index_start = $query->param ("min_index");
    $index_start=~ s/[^A-Za-z0-9 ]//;
    my  $index_end = $query->param ("max_index");
    $index_end =~ s/[^A-Za-z0-9 ]//;
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);
    $date = trimwhitespace($date);
    my  $string = "";
    my  $add;
    my $from;
    if ($category) {$from .= ", categorie_libelle_langue, libelle, langue";
                    $add .= " AND libelle.libelle = '$category' AND article.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'";}
    if ($subcat) {$from .= ", subcategorie_libelle_langue";
                    $add .= " AND subcategorie_libelle_langue.id_subcategorie_libelle_langue = (SELECT libelle.libelle FROM subcategorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$subcat' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang') AND article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie";
                    }

    
    if (!$index_start ) {
	$index_start = 0;
    }
    if (!$index_end ) {
	$index_end = 40;
    }

   $add .= getAdd();    

    my  ($c)= sqlSelectMany("DISTINCT article.nom,marque,prix, pochette,id_article,date_stock,article.ref_categorie,article.lieu,quantite",
		       "article,met_en_vente $from",
		       "ref_article = id_article  AND ref_statut = '3' and quantite > 0 AND  enchere_date_fin > "." '$date%' AND article.ref_categorie BETWEEN 17 AND 18 $add ORDER BY  date_stock DESC LIMIT $index_start, $index_end  ");	
    
#	$string .= "<br />";
#	$string .= "<table width=\"500\" border=\"0\">";
#	$string .= "<tr>";
#	$string .= "<td align=\"left\">&nbsp;</td>";
#	$string .=  "<td align=\"left\">&nbsp;</td>";
#	$string .=  "<td align=\"left\">&xcvxcv;xcvxc</td>";
#	$string .=  "</tr>";

    my $i = 0;
    
    my $j = 0;
    #$string .= "<hr>";
    $string .= "<table style=\"border-top-width:medium;border-top-color:#94CEFA\"><tr>";
    
    while( ($ARTICLE{'name'},$ARTICLE{'author'},$ARTICLE{'price'},$ARTICLE{'pochette'},$ARTICLE{'id_article'},$ARTICLE{'date'},$ARTICLE{'ref_categorie'},$ARTICLE{'article_lieu'},$ARTICLE{'quantity'})=$c->fetchrow()) {
	#$string .= " <label>&nbsp;&nbsp;$ARTICLE{'genre'}</label>";
	my $img;
	if ($ARTICLE{'pochette'} eq '') {
		$ARTICLE{'pochette'} = "../images/no.gif";
	}
	
	if ($ARTICLE{'date'} eq $date) {
		$img = "../images/new_article.gif"
	}else {
		#$img = "../images/blank.gif"
	}
	my $add3;
	if ($ARTICLE{'ref_categorie'} eq '11') {
		$add3 = $ARTICLE{'article_lieu'};
	}
	#$ARTICLE{'label'}
	#$ARTICLE{'label'} .= "...";

	$string .= "<td align=\"left\" width=\"253px\" height=\"100px\" style=\"background-image:url(../images/table_article_decoration.jpg);background-position:right bottom;background-repeat: no-repeat;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&amp;action=detailother&amp;article=$ARTICLE{'id_article'}\" class=\"menulink3\" >$ARTICLE{'name'} $add3</a><br/>&nbsp;&nbsp;&nbsp;&nbsp;<img alt=\"\" src=\"$ARTICLE{'pochette'}\" /> <img alt=\"\" src=\"$img\" /><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$ARTICLE{'price'} francs suisse <br/><br/></td>";
	$i += 1;
	$j += 1;

	if ($i eq 1) {
		#$string .= "<hr>";
		$string .= "<td align=\"left\" width=\"10px\"></td>";		
		$i = 0;
	}
	
	if ($j eq 2) {
		
		$string .= "</tr>";
		$string .= "<tr>";
		$string .= "</tr>";
		$string .= "<tr>";
		$string .= "</tr>";
		$string .= "<tr>";		
		$j = 0;
	}
    }    
    $string .= "</table>";
    return $string;
    
}

sub loadLastBuyersIndex {
    my $article = $query->param("article");  
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
    my  $date = sprintf "%4d-%02d-%02d \n",$year+1900,$mon+1,$mday;
    my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);


    
    my  $string = "";
    my  $index = '0';
    my  $total = '0';
    my  $add;

    my  ($c)= sqlSelect("count(id_article)",
			   "article,a_paye",
			   "a_paye.ref_article = id_article AND a_paye.ref_statut = '7' AND id_article = $article");	
	
    my  $nb_page = arrondi ($c / 40, 1);
    my  $min_index = '0';
    my  $max_index = '40';
    
    #print "Content-Type: text/html\n\n";
    for (my  $i = '0'; $i < $nb_page;$i++) {	
	#my $x =
	my $j;
	#print "valeur de i $i <br />";
	if ($i <= 9) {
		$j = "0$i";
	}else {
		$j = $i;
	}
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=last_buyers&amp;article=$article&amp;session=$session_id&amp;min_index=$min_index&amp;max_index=$max_index\"  class=\"menulink2\" ><-$j-></a>&#160;&nbsp;";		
	$min_index += 40;	
    }
        
return $string;    
}


sub loadSearchWineCountry {
    my  ($c)= sqlSelectMany("nom",
			   "pays_present",
			   "");
    my $selected = $query->param("country");
    my $string = "<select name=\"country\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_wine&session=$session_id&country=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadSearchWineRegion {
    my $country = $query->param("country");
    my $region = $query->param("region");
    my  ($c)= sqlSelectMany("pays_region_vin.nom",
			   "pays_region_vin,pays_present",
			   "ref_pays = id_pays_present AND pays_present.nom = '$country' AND  parent_id IS NOT NULL ORDER BY pays_region_vin.nom");
    
    my $string = "<td align=\"left\">$SERVER{'region_label'}</td><td align=\"left\"><select name=\"region\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($region) {
	$string  .= "<option selected value=\"$region\">$region</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_wine&session=$session_id&country=$country&region=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
	
}

sub loadSearchWineCepage {
    my $country = $query->param("country");
    my $region = $query->param("region");
    my $cepage = $query->param("cepage");
    my  ($c)= sqlSelectMany("cepage.nom",
			   "pays_region_vin,cepage",
			   "ref_pays_region_vin = id_pays_region_vin AND pays_region_vin.nom = '$region'");
    
    my $string = "<td align=\"left\">$SERVER{'cepage'}</td><td align=\"left\"><select name=\"cepage\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($cepage) {
	$string  .= "<option selected value=\"$cepage\">$cepage</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_wine&session=$session_id&country=$country&region=$region&cepage=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select></td>";
    return $string;    
	
	
}

sub loadSearchCdUsed {
	my $string;
	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue",
			   "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";
	return $string;	
}
sub loadWineCountry {
    my  ($c)= sqlSelectMany("nom",
			   "pays_present",
			   "");
    my $selected = $query->param("country");
    my $string = "<select name=\"country\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wine&session=$session_id&country=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
}

sub loadWineType {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "type_de_vin_libelle_langue, libelle, langue",
			   "type_de_vin_libelle_langue.ref_libelle = libelle.ref_libelle AND type_de_vin_libelle.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("wine_type");
    my $country = $query->param("country");
    
    my $string = "<select name=\"wine_type\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wine&session=$session_id&country=$country&wine_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    $string .= "</select>";
    return $string;    
}

sub loadAutoFabricant {

    my $fabricant = $query->param("fabricant");
    my $withclim = $query->param("withclim");
    my $type = $query->param("type");
    my $motorisation = $query->param("motorisation");    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article",
			   "ref_categorie = 8");
    
    my $string = "<select name=\"fabricant\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_auto&session=$session_id&fabricant=$OPTIONS{'category'}&type=$type&withclim=$withclim&motorisation=$motorisation\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadAutoSearchProperties {
	my $fabricant = $query->param ("fabricant");
	my $motorisation = $query->param("motorisation");
	my $withclim = $query->param("withclim");
	my $type  = $query->param ("type");
	my $string;
		$string .= "<td align=\"left\">Année fabrication min</td><td align=\"left\" ><input type=\"\" name=\"year_fabrication_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
		$string .= "<td align=\"left\">Année fabrication max</td><td align=\"left\"><input type=\"\" name=\"year_fabrication_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";	
	$string .= "</tr>";
	
	$string .= "<tr>";
		$string .= "<td align=\"left\">Nbr de cheveaux min</td><td align=\"left\"><input type=\"text\" name=\"horse_nbr_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
		$string .= "<td align=\"left\">Nbr de cheveaux max</td><td align=\"left\"><input type=\"text\" name=\"horse_nbr_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
		$string .= "<td align=\"left\">Km min</td><td align=\"left\"><input type=\"text\" name=\"km_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"\"></td>";
		$string .= "<td align=\"left\">Km max</td><td align=\"left\"><input type=\"text\" name=\"km_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";	
	$string .= "</tr>";

	$string .= "<tr>";
		$string .= "<td align=\"left\">$SERVER{'nb_cylindre_min'}</td><td align=\"left\"><input type=\"text\" name=\"cylindre_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"\"></td>";
		$string .= "<td align=\"left\">$SERVER{'nb_cylindre_max'}</td><td align=\"left\"><input type=\"text\" name=\"cylindre_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";	
	$string .= "</tr>";
	
	$string .= "<tr>";
		$string .= "<td align=\"left\">CHF min,</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
		$string .= "<td align=\"left\">CHF max,</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr>";
		#$string .= "<td align=\"left\">Boite de vitesse</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onblur=\"skipcycle=false\"></td>";
		#$string .= "<td align=\"left\">CHF max</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
			$string .= "<td align=\"left\">Avec clim</td>";			
			$string .= "<td align=\"left\"><select name=\"withclim\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">"; 
			if ($withclim) {
				$string  .= "<option selected value=\"$withclim\" onblur=\"skipcycle=false\">$withclim</option>";
			}
			$string .= "<option value =\"\">---------</option>";    
			$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_auto&session=$session_id&withclim=$SERVER{'yes'}&fabricant=$fabricant&type=$type&motorisation=$motorisation\">$SERVER{'yes'}</option>";
			$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_auto&session=$session_id&withclim=$SERVER{'no'}&fabricant=$fabricant&type=$type&motorisation=$motorisation\">$SERVER{'no'}</option>";    
			$string .= "</select>";
			$string .= "</td>";
			$string .= "<td align=\"left\">Motorisation</td>";			
			$string .= "<td align=\"left\"><select name=\"motorisation\" onchange=\"go4();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">"; 
			if ($motorisation) {
				$string  .= "<option selected value=\"$motorisation\" onblur=\"skipcycle=false\">$motorisation</option>";
			}
			$string .= "<option value =\"\">---------</option>";    
			$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_auto&session=$session_id&withclim=$withclim&fabricant=$fabricant&type=$type&motorisation=$SERVER{'essence'}\">$SERVER{'essence'}</option>";
			$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_auto&session=$session_id&withclim=$withclim&fabricant=$fabricant&type=$type&motorisation=$SERVER{'diesel'}\">$SERVER{'diesel'}</option>";    
			$string .= "</select>";
			$string .= "</td>";


	$string .= "</tr>";
	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue, libelle, langue",
			   "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";
	return $string;
}

sub loadMotoFabricant {
    my $category = $query->param("category");
    my $fabricant = $query->param("fabricant");
    my $withclim = $query->param("withclim");
    my $type = $query->param("type");
    my $motorisation = $query->param("motorisation");    
    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article",
			   "article.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libellee = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.kay = '$lang')");
    
    my $string = "<select name=\"fabricant\"  onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    
    my  %OPTIONS = ();

    if ($fabricant) {
	$string  .= "<option selected value=\"$fabricant\" onblur=\"skipcycle=false\">$fabricant</option>";
    }
    $string  .= "<option value=\"\" onblur=\"skipcycle=false\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    return $string;    
	
}
sub loadSearchMotoCategory {
    my $fabricant = $query->param("fabricant");
    my $category = $query->param("category");
    my $withclim = $query->param("withclim");
    my $motorisation = $query->param("motorisation");
    my $type = $query->param("type");	    
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "id_categorie BETWEEN 37 AND 39 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
    
    my  %OPTIONS = ();

    if ($category) {
	$string  .= "<option  onblur=\"skipcycle=false\" selected value=\"$category\">$category</option>";
    }
    $string  .= "<option onblur=\"skipcycle=false\" value=\"\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_moto&session=$session_id&fabricant=$fabricant&category=$OPTIONS{'category'}&withclim=$withclim&motorisation=$motorisation\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadSearchMotoSubCategory {
    my $fabricant = $query->param("fabricant");
    my $category = $query->param("category");
    my $subcat = $query->param("subcat");
    my $motorisation = $query->param("motorisation");
    my $type = $query->param("type");	    
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, langue, libelle WHERE libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue = langue.key = '$lang')");
    
    my $string = "<select name=\"subcat\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
    
    my  %OPTIONS = ();

    if ($subcat) {
	$string  .= "<option  onblur=\"skipcycle=false\" selected value=\"$subcat\">$subcat</option>";
    }
    $string  .= "<option onblur=\"skipcycle=false\" value=\"\">--------</option>";
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option onblur=\"skipcycle=false\" VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_moto&session=$session_id&category=$category&subcat=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadMotoSearchProperties {
	my $fabricant = $query->param ("fabricant");
	my $motorisation = $query->param("motorisation");
	my $withclim = $query->param("withclim");
	my $type  = $query->param ("type");
	my $string;
		$string .= "<td align=\"left\">Année fabrication min</td><td align=\"left\" ><input type=\"\" name=\"year_fabrication_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
		$string .= "<td align=\"left\">Année fabrication max</td><td align=\"left\"><input type=\"\" name=\"year_fabrication_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";	
	$string .= "</tr>";
	
	$string .= "<tr>";
		$string .= "<td align=\"left\">Km min</td><td align=\"left\"><input type=\"text\" name=\"km_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"\"></td>";
		$string .= "<td align=\"left\">Km max</td><td align=\"left\"><input type=\"text\" name=\"km_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";	
	$string .= "</tr>";

	
	$string .= "<tr>";
		$string .= "<td align=\"left\">CHF min,</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
		$string .= "<td align=\"left\">CHF max,</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";

	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue",
			   "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";
	return $string;
}

sub loadTvOrDVD {
    my $category = $query->param("category");
    my $type_ecran = $query->param("type_ecran");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, libelle, langue",
			   "subcategorie_libelle_langue.ref_categorie = '12' subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
  
    my  $string;
    $string .= "<td align=\"left\">Catégorie</td>";
    $string .= "<td align=\"left\">";
    $string .= "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
    $string .= "<option>---------</option>";
    if ($category) {
	$string .= "<option selected value=\"$category\">$category</option>";	
    }
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_tv&session=$session_id&category=$OPTIONS{'category'}&type_ecran=$type_ecran\">$OPTIONS{'category'}</option>";
	}
    $string .= "</td>";
    return $string;
}

sub loadTvTypeEcran {
    my $category = $query->param ("category");
    my $subcat= $query->param ("subcat");
    my $load = $query->param("isencher");
    my $fabricant = $query->param("fabricant");
    my $type_ecran = $query->param("type_ecran");

    my  ($c)= sqlSelectMany("libelle.libelle",
			   "type_ecran_libelle_langue, libelle, langue",
			   "type_ecran_libelle_langue,ref_libelle = libelle.id_libelle AND type_ecran_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
  
    my  $string ;
    $string .= "<td align=\"left\">$SERVER{'type_ecran'}</td>";
    $string .= "<td align=\"left\">";
    $string .= "<select name=\"type_ecran\" onchange=\"go2();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
    $string .= "<option value=\"\">---------</option>";
    if ($type_ecran) {
	$string .= "<option selected value=\"$type_ecran\">$type_ecran</option>";	
    }
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_tv&session=$session_id&category=$category&isencher=$load&subcat=$subcat&type_ecran=$OPTIONS{'category'}&fabricant=$fabricant\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    
    return $string;    

}
sub loadTvFabricant {

    my $category = shift || '';
    my $fabricant = $query->param("fabricant");
    my $type_ecran = $query->param("type_ecran");

    my  ($c)= sqlSelectMany("DISTINCT marque",
			   "article,subcategorie_libelle_langue, libelle, langue",
			   "article.ref_subcategorie = subcategorie_libelle_langue.ref_subcategorie AND libelle.libelle = '$category' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
  
    my  $string ;
    $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\">";
    $string .= "<select name=\"fabricant\" onchange=\"go3();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";    
    $string .= "<option value=\"\">---------</option>";
    if ($fabricant) {
	$string .= "<option selected value=\"$fabricant\">$fabricant</option>";	
    }
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_tv&session=$session_id&category=$category&t&fabricant=$OPTIONS{'category'}&type_ecran=$type_ecran\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    
    return $string;    
	
}
sub loadSearchTvProperties {
	my $string;
	$string .= "<td align=\"left\">Taille de l'écran en cm min</td><td align=\"left\"><input type=\"text\" name=\"tv_size_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "<td align=\"left\">Taille de l'écran en cm max</td><td align=\"left\"><input type=\"text\" name=\"tv_size_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr>";
	$string .= "<td align=\"left\">CHF min</td><td align=\"left\"><input type=\"text\" name=\"price_min\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "<td align=\"left\">CHF max</td><td align=\"left\"><input type=\"text\" name=\"price_max\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"></td>";
	$string .= "</tr>";
	$string .= "<tr><td>$SERVER{'used'}</td><td>";
	my  ($c)= sqlSelectMany("libelle.libelle",
			   "etat_libelle_langue, libelle, langue",
			   "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	$string .= "<select name=\"used\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\" >";
	my  %OPTIONS = ();
	while(($OPTIONS{'category'})=$c->fetchrow()) {	
		$string .= "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$string .= "</select></td></tr>";
	
	return $string;
}

sub loadLocationVilla {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'city_label'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"place\"></td>";
	$string .= "</tr>";
	return $string;
}

sub localNbrFloor {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'nbr_piece'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"nbr_piece\"></td>";
	$string .= "</tr>";
	return $string;
}

sub localHabitableSurface {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'habitable_surface_min'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"habitable_surface_min\"></td>";
	$string .= "<td align=\"left\">$SERVER{'habitable_surface_max'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"habitable_surface_min\"></td>";
	$string .= "</tr>";
	return $string;
}


sub loadBuyOrLocation {
	my $string;
	my $category = $query->param ("category");
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'label_location_or_buy'}</td>";
	$string .= "<td align=\"left\"><select name=\"location_or_buy\" onchange=\"go4()\">";
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_wish&session=$session_id&category=$category&\">$SERVER{'location'}</option>";
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_wish&session=$session_id&category=$category&\">$SERVER{'buy'}</option></td>";
	$string .= "</tr>";
	return $string;
}

sub getCategoryGoAddWish {
    my $load = $query->param("isencher");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my  $string = "<option selected value=\"$selected\">$selected</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_wish&isencher=$load&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    return $string;    
}


sub loadImmobilierMenu {
    my $canton = $query->param("canton");
    my $location_type = $query->param("location_type");
    my  $string .= "";
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
    my $selected;
    $string .= "<select name=\"subcat\" onchange=\"go3();\">";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,libelle, langue","subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langu.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_subcategorie = (SELECT ref_subcategorie_libelle_langue FROM subcategorie_libelle_langue WHERE ref_categorie = 11 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    $string .= "<option>--------</option>";
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=immo&amp;type=6&session=$session_id&canton=$canton&location_type=$location_type&subcat=$ARTICLE{'genre'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
}

sub loadImmobilierLocationType {
    my $subcat = $query->param("subcat");
    my $canton = $query->param("canton");
    my $location = $query->param("location_type");
    my $country = $query->param("country");    

    my  $string .= "";
    
    my  ($c)= sqlSelectMany("libelle.libelle","location_ou_achat_libelle_langue, libelle, langue","location_ou_achat_libelle_langue.ref_libelle = libelle.id_libelle AND location_ou_achat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    $string .= "<select name=\"location_type\" onchange=\"go2();\">";
    $string .= "<option value=\"\">-------</option>";
    if ($location) {
	$string .= "<option selected value=\"$location\">$location</option>";	
    }
    
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=immo&amp;type=6&session=$session_id&canton=$canton&subcat=$subcat&location_type=$ARTICLE{'genre'}&country=$country\">$ARTICLE{'genre'}</option>";
    }
    $string .="</select>";
    return $string;
}

sub loadCantonImmoMain {
	my $subcat = $query->param("subcat");
	my $canton = $query->param("canton");
	my $location_type = $query->param("location_type");
	my $string;
        my  ($c)= sqlSelectMany("nom","canton_$lang","");
	$string .= "<select name=\"canton\" onchange=\"go4();\">";
	$string .= "<option value=\"\">-------</option>";
    if ($canton) {
	$string .= "<option selected value=\"$canton\">$canton</option>";	
    }
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=immo&session=$session_id&location_type=$location_type&subcat=$subcat&canton=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
return $string;	


}
sub loadSearchBookCategories {
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "subcategorie_libelle_langue, langue, libelle"
			   "ref_categorie = 27 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("category");
    my $string = "<select name=\"category\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=search_book&amp;session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    return $string;    
	
}
sub loadSearchBookProperties {
	my $string;
	$string .= "<tr><td>$SERVER{'title'}</td><td><input type=\"text\" name=\"title\"></td></tr><tr>";
	$string .= "<td>$SERVER{'autor'}</td><td><input type=\"text\" name=\"author\"></td></tr><tr><td>$SERVER{'year'}</td><td>	<input type=\"text\" name=\"year\"></td></tr><tr>";
	$string .= "<td>$SERVER{'editor'}</td><td><input type=\"text\" name=\"editor\"></td></tr><tr><td>$SERVER{'price_min'}</td><td><input type=\"text\" name=\"price_min\"></td><td>$SERVER{'price_max'}</td><td><input type=\"text\" name=\"price_max\"></td></tr>";

	return $string;
}


sub getArticleCat {
	my $string = "";
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=hardstyle&amp;type=1&session=$session_id;\" class=\"menulink\" >Hardstyle</a>&nbsp;";
	$string .=  "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=hardcore&amp;type=1&session=$session_id;\" class=\"menulink\" >Hardcore</a>&nbsp;";	
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=tek&amp;type=1&session=$session_id;\" class=\"menulink\" >Techno</a>&nbsp;";	
	$string .= "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=house&amp;type=1&session=$session_id\" class=\"menulink\" >House</a>&nbsp;";			
	$string .=  "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=trance&amp;type=1&session=$session_id;\" class=\"menulink\" >Trance</a>&nbsp;";
	$string .=  "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=hiphop&amp;type=1&session=$session_id;\" class=\"menulink\" >Hip Hop</a>&nbsp;";
	$string .=  "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;cat=dancehall&amp;type=1&session=$session_id;\" class=\"menulink\" >Dancehall</a>&nbsp;";
	$string .=  "<a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=mix_tape&amp;type=5&session=$session_id\" class=\"menulink\" >Mix Tape</a>";	
	return $string;

}

sub getNatelType {
             
    my  $string .= "";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","ref_categorie = '10' AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<a class=\"menulink\" class=&{ns4class} href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=informatique&amp;type=6&session=$session_id&subcat=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</a>&nbsp;&nbsp;";
    }
    $string .= "</select>";
    return $string;
	
}
sub getTvVideoType {
    my  $selected = $query->param("subcat");
    my $string = "<select name=\"subcat\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("category");
    if ($selected) {
	$string  .= "<option selected value=\"$selected\">$selected</option>";
    }
    $string  .= "<option value=\"\">--------</option>";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,libelle, langue","subcategorie_libelle_langue.ref_categorie = '12' AND subcategorie_libelle_langue.ref_libelle = libelle.ref_libelle AND subcategorie_libelle_langue.ref_langue AND langue.key = '$lang'");
    
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=tv_video&amp;type=6&session=$session_id&subcat=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
	
}

sub getInformatiqueType {
    my $category = $query->param("subcat");         
    my  $string .= "";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue,libelle, langue","subcategorie_libelle_langue.ref_categorie = '10' AND subcategorie_libelle_langue.ref_libelle = libelle.ref_libelle AND subcategorie_libelle_langue.ref_langue AND langue.key = '$lang'");
    $string .= "<select name=\"subcat\" onchange=\"go();\">";
    $string .= "<option selected value=\"$category\">$category</option>";
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=informatique&amp;type=6&session=$session_id&subcat=$ARTICLE{'genre'}\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
	
}

sub getAutoType {
    my $category = $query->param("subcat");
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");         
    my  $string .= "";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","subcategorie_libelle_langue.ref_categorie = '8' AND subcategorie_libelle_langue.ref_libelle = libelle.ref_libelle AND subcategorie_libelle_langue.ref_langue AND langue.key = '$lang'"");
    $string .= "<select name=\"subcat\" onchange=\"go();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    $string .= "<option>-----</option>";
    if ($category) {$string .= "<option selected value=\"$category\">$category</option>";}
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=auto&amp;type=6&session=$session_id&subcat=$ARTICLE{'genre'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\">$ARTICLE{'genre'}</option>";
    }
    $string .= "</select>";
    return $string;
	
}

sub loadMenu {
	my $string = "";
	my $country_swiss = $query->param("country_swiss");my $country_france = $query->param("country_france");
	my $with_lang_french = $query->param("with_lang_french");my $with_lang_german = $query->param("with_lang_german");
	my $with_lang_italian = $query->param("with_lang_italian");my $with_lang_english = $query->param("with_lang_english");		
	#$string .=  "<li><img src=\"../images/charity.gif\"><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=charity&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'charity'}</a><img src=\"../images/charity.gif\"></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=art_design&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'art'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=parfum&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'parfum_cosmetik'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wear_news&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'fashion'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=lingerie&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'lingerie'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=baby&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'baby'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=astro&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'astro'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=animal&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'animal'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=watch&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'watch_jewels'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=jardin&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'Habitat_et_jardin'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=auto&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'car'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=moto&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'moto'}</a></li>";	
	#$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=immo&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'real_estate'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=cd_vinyl_mixtap&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'cd_music'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=intruments&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'music_instrument'}</a></li>";	
	#$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=cigares&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'cigares'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=collection&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'collections'}</a></li>";
	#$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=caviar&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'caviar'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wine&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'wine'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=boat&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'boat'}</a></li>";		
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=tv_video&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'tv_video_camera'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=informatique&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english;\" class=\"menulink\" >$SERVER{'computer_it'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=games&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english;\" class=\"menulink\" >$SERVER{'games'}</a></li>";
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=book&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'book'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=dvd&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'dvd_k7'}</a></li>";	
	$string .=  "<li><a href=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=sport&amp;session=$session_id&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=$with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=$with_lang_german&amp;with_lang_english=$with_lang_english\" class=\"menulink\" >$SERVER{'sport'}</a></li>";
	return $string;
}


sub getWearSex {
    my $genre = $query->param("sex");
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
          
    my  $string .= "<select name=\"sex\" onchange=\"go();\">";
    my  ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","categorie_libelle_langue.ref_categorie = 6 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    if ($genre) {
	$string .= "<option selected value=\"$genre\">$genre</option>";
    }

    $string .= "<option>------</option>";
    
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wear_news&amp;session=$session_id&amp;sex=$ARTICLE{'genre'}&amp;country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&amp;with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&amp;with_lang_english=$with_lang_english\">$ARTICLE{'genre'}</option>";
    }
    
    ($c)= sqlSelectMany("libelle.libelle","categorie_libelle_langue, libelle, langue","categorie_libelle_langue.ref_categorie = 7 AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wear_news&amp;type=6&session=$session_id&sex=$ARTICLE{'genre'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\">$ARTICLE{'genre'}</option>";
    }

    $string .= "</select>";
    return $string;
	
}


sub getWearType {
    my $genre = $query->param("sex");
    my $subcat = $query->param("subcat");
    my $country_swiss = $query->param("country_swiss");
    my $country_france = $query->param("country_france");
    my $with_lang_french = $query->param("with_lang_french");
    my $with_lang_german = $query->param("with_lang_german");
    my $with_lang_italian = $query->param("with_lang_italian");
    my $with_lang_english = $query->param("with_lang_english");
          
    my  $string .= "<select name=\"navi\" onchange=\"go2();\">";
    my  ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue","subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_categorie = (SELECT categorie_libelle_langue.ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle ='$genre')");
    if ($subcat) {
	$string .= "<option selected value=\"$subcat\">$subcat</option>";
    }

    $string .= "<option>------</option>"; 
    while( ($ARTICLE{'genre'})=$c->fetchrow()) {
	$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=wear_news&amp;type=6&session=$session_id&sex=$genre&subcat=$ARTICLE{'genre'}&country_swiss=$country_swiss&amp;country_france=$country_france&amp;with_lang_french=with_lang_french&with_lang_italian=$with_lang_italian&amp;with_lang_german=with_lang_german&with_lang_english=$with_lang_english\">$ARTICLE{'genre'}</option>";
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


sub loadRegisterLongerPrice {
    my $string;
    my $account = $query->param("account_type");
    my $selected = $query->param("time");  
    my  ($c)= sqlSelect("prix","type_de_compte_libelle_langue, libelle, langue","libelle.libelle= '$account' AND type_de_compte_libelle_langue.ref_libelle = type_de_compte_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $x = $c * $selected;
    $x =~ s/\[0-9]//g; ;
    my $s = "<tr><td>$SERVER{'tarif'} € </td><td><input type=\"text\" name=\"price\" value=\"$x\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\"><td></tr>";
    return $s;
}

sub loadRegisterLongerTypeAccount {
    my $string;
    my  ($c)= sqlSelectMany("libelle.libelle","type_de_compte_libelle_langue, libelle, langue","type_de_compte_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_compte_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $s = "<td>$SERVER{'account_label'}</td><td><select name=\"account_type\" onchange=\"go();\">";
    my  %OPTIONS = ();
    my $selected = $query->param("account_type");
    $s .= "<option selected VALUE=\"$selected\">$selected</option>";
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $s .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&page=longer&session=$session_id&account_type=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
	$s .= "</select></td>";
    return $s;
}

    
sub loadSubCategoriesOther {
    my $maincat = $query->param("category");
    my $subcat = $query->param("subcat");
    my $load = $query->param("isencher");
    my  ($c)= sqlSelectMany("libelle ",
			   "subcategorie_libelle_langue",
			   "subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' AND subcategorie_libelle_langue.ref_categorie = (SELECT ref_categorie FROM categorie_libelle_langue, libelle, langue WHERE libelle.libelle = '$maincat' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')");
    my   $string = "";
    if ($c) {
		$string .="<tr>";
		$string .="<td align=\"left\"><label id=\"label_category_name\">$LABEL{'category'}</label></td>";			
     	        $string .= "<td align=\"left\"><select name=\"subcat\" onchange=\"go6();\">";
    if ($subcat) {
	$string .= "<option selected value=\"$subcat\">$subcat</option>";
    }
    $string .= "<option>------------</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {
		 #my $entities = '&amp;';
		 #$OPTIONS{'category'} =~ s/[&]/$entities/ge;			      
	         $string .="<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&isencher=$load&session=$session_id&category=$maincat&subcat=$OPTIONS{'category'};\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select></td></tr>";
    }
    return $string;    
	
}

sub getCategoryGo {
    my $load = $query->param("isencher");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "categorie_libelle_langue, libelle, langue",
			   "categorie_libelle_langue.ref_categorie = categorie_libelle_langue.ref_categorie AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND  categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang' ORDER BY catLibelle ");
    my $selected = $query->param("category");
    my  $string = "<option selected value=\"$selected\">$selected</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	
         $string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&isencher=$load&session=$session_id&category=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>" ;
	}
    return $string;    
}

sub loadEnchereProperties {
	my $category = $query->param ("category");
	my $enchere_long = $query->param("enchere_long");        
        my $load = $query->param("isencher");
	my $subcat = $query->param("subcat");
        my $name =$query->param("name");
        my $fabricant= $query->param("fabricant");
        my $description = $query->param("description");
        my $price=  $query->param("price");
        my $selected = $enchere_long;
	my $wine_country = $query->param("wine_country");
	my $region = $query->param("region");
        my $wine_type = $query->param("wine_type");
	my $string;
	$ENV{TZ} = 'EST'; 
	my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime();
	my  $date = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;	
	my  $time = sprintf("%4d:%02d:%02d",$hour,$min,$sec);	
	
	
	&Date_Init("Language=French","DateFormat=non-US","TZ=FST"); #French Summer Time 
        my  $date2 = ParseDateString("aujourd'hui");

	my   $currentDate = $date;
	my   $cutoffDate  = &DateCalc($date, "+ $enchere_long jours");
	
	my $year2 = substr($cutoffDate,0,4);
	my $month2 = substr($cutoffDate,4,2);
	my $day2 = substr($cutoffDate,6,2);
	my $cepage = $query->param("cepage");
	my $date_finish = "$year2-$month2-$day2";
	my $game_type = $query->param("game_type");
	
	$string .="<tr>";
		$string .="<td align=\"left\">$SERVER{'debut_enchere_label'}</td>";
		$string .="<td align=\"left\"><input type=\"text\" name=\"enchere_date_start\" value=\"$date $time\" style=\"width:120px\"></td>";		
	$string .="</tr>";
	$string .="<tr>";
		$string .="<td align=\"left\">$SERVER{'duree_enchere_label'}</td>";
		$string .="<td align=\"left\"><select name=\"duration_enchere\" onchange=\"go4();\">";
		$string .= "<option selected value=\"$selected\">$selected</option>";
		for (my $i = 1; $i < 31; $i++) {
			$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&category=$category&subcat=$subcat&isencher=$load&enchere_long=$i&wine_country=$wine_country&region=$region&cepage=$cepage&wine_type=$wine_type&game_type=game_type\">$i</option>";
		}
		$string .= "</select></td>";		
	$string .="</tr>";
	$string .="<tr>";
		$string .="<td align=\"left\">$SERVER{'fin_enchere_label'}</td>";
		$string .="<td align=\"left\"><input type=\"text\" name=\"enchere_end_day\" value=\"$date_finish $time\" style=\"width:120px\"></td>";
	$string .="</tr>";
	
	return $string;
}

sub loadIsBuyOrLocation {
	my $string;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'label_location_or_buy'}</td>";
	$string .= "<td align=\"left\"><select name=\"is_location_or_buy\">";
	$string .= "<option>$SERVER{'location'}</option>";
	$string .= "<option>$SERVER{'buy'}</option>";
	$string .= "</select></td>";
	$string .= "</tr>";
	return $string;
}

sub getIsEnchere {
    my $category = $query->param ("category");
    my $wine_country = $query->param("wine_country");
    my $region = $query->param("region");
    my $load = $query->param("isencher");
    my $type_ecran = $query->param("type_ecran");
    my $subcat= $query->param ("subcat");
    my $cepage = $query->param("cepage");
    my $wine_type = $query->param("wine_type");
    my  $string ;
    $string .="<tr>";
    $string .="<td align=\"left\"><label id=\"label_image\">$SERVER{'avec_enchere'}</label></td>";
    $string .= "<td align=\"left\"><select name=\"is_enchere\" onchange=\"go3();\">";
    if ($load) {
	$string .= "<option selected value=\"$load\">$load</option>";
    }
    $string .= "<option>---------</option>";    
    $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&category=$category&isencher=$SERVER{'yes'}&category=$category&subcat=$subcat&type_ecran=$type_ecran&wine_country=$wine_country&region=$region&cepage=$cepage&wine_type=$wine_type\">$SERVER{'yes'}</option>";
    $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&category=$category&isencher=$SERVER{'no'}&category=$category&subcat=$subcat&type_ecran=$type_ecran&wine_country=$wine_country&region=$region&cepage=$cepage&wine_type=$wine_type\">$SERVER{'no'}</option>";    
    $string .= "</select>";
    $string .= "</td></tr>";
    return $string;    
}

sub loadTypeEcran {
    my $category = $query->param ("category");
    my $subcat= $query->param ("subcat");
    my $load = $query->param("isencher");
    my $type_ecran = $query->param("type_ecran");
    my  ($c)= sqlSelectMany("libelle.libelle",
			   "type_ecran_libelle_langue",
			   "type_ecran_libelle_langue.ref_libelle = libelle.id_libelle AND type_ecran_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
  
    my  $string = "<tr>";
    $string .= "<td align=\"left\">$SERVER{'type_ecran'}</td>";
    $string .= "<td align=\"left\">";
    $string .= "<select name=\"type_ecran\" onchange=\"go5();\">";    
    $string .= "<option>---------</option>";
    if ($type_ecran) {
	$string .= "<option selected value=\"$type_ecran\">$type_ecran</option>";	
    }
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {	
         $string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&category=$category&isencher=$load&subcat=$subcat&type_ecran=$OPTIONS{'category'}\">$OPTIONS{'category'}</option>";
	}
    $string .= "</select>";
    $string .= "</td>";
    $string .= "</tr>";
    return $string;    
	
}

sub loadFabricant {
    my $string;
    $string .= "<td align=\"left\">$SERVER{'fabricant'}</td>";
    $string .= "<td align=\"left\"><input type=\"text\" name=\"fabricant\"></td>";
    $string .= "</tr>";
    return $string;	
}

sub getCarProperties {
    my $maincat = $query->param("category");
    my $subcat = $query->param("subcat");
    my $load = $query->param("isencher");
    my $name =$query->param("name");;
    my $string;
    my $type_essence = $query->param("type_essence");
    my $speed_box = $query->param("speed_box");
    $string .="<tr><td align=\"left\">$SERVER{'chev'}</td><td align=\"left\"><input type=\"text\" name=\"horse\"></td></tr>";
    $string .="<tr><td align=\"left\">$SERVER{'nb_cylindre'}</td><td align=\"left\"><input type=\"text\" name=\"nb_cylindre\"></td></tr>";
    $string .="<tr><td align=\"left\">$SERVER{'nbr_km'}</td><td align=\"left\"><input type=\"text\" name=\"km\"></td></tr>";
    $string .="<tr><td align=\"left\">$SERVER{'year_fabrication'}</td><td align=\"left\"><input type=\"text\" name=\"year_fabrication\"></td></tr>";
    $string .="<tr><td align=\"left\">$SERVER{'year_service'}</td><td align=\"left\"><input type=\"text\" name=\"year_service\"></td></tr>";  
    $string .="<tr><td align=\"left\">$SERVER{'essence_type'}</td>";
    my  ($c)= sqlSelectMany("libelle.libelle","type_essence_libelle_langue, libelle, langue","type_essence_libelle_langue.ref_libelle = libelle.id_libelle AND type_essence_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");	
    my  %OPTIONS = ();
    $string .="<td align=\"left\"><select name=\"type_essence\">";
    if ($type_essence) {$string .= "<option selected VALUE=\"$type_essence\">$type_essence</option>";}
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option>$OPTIONS{'category'}</option>";}
    $string .= "</select></td></tr><tr><td align=\"left\">$SERVER{'limp_speed'}</td>";
    my  ($d)= sqlSelectMany("nom","boite_de_vitesse_$lang","");	
    %OPTIONS = ();
    $string .="<td align=\"left\"><select name=\"speed_box\">";
    if ($speed_box) {$string .= "<option selected VALUE=\"$speed_box\">$speed_box</option>";}
    while(($OPTIONS{'category'})=$d->fetchrow()) {$string .= "<option>$OPTIONS{'category'}</option>";}
    $string .= "</select></td></tr><tr><td align=\"left\">$SERVER{'climatisation'}</td><td align=\"left\"><select name=\"with_clima\">";
    $string .= "<option>$SERVER{'yes'}</option><option>$SERVER{'no'}</option></select></td>";
    $string .= "</tr>";
    return $string;

}

sub loadDimension {
	
}



sub loadCityLocation {
	my $string;
	my $category = $query->param("category");
	my $subcat = $query->param("subcat");
	my $country = $query->param("country");
	my $departement = $query->param("departement");
	my $canton = $query->param ("canton");
	my $dep;
	my $label;
	my $c = loadAddImmoCountry();;
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'country'}</td>";
	$string .= "<td align=\"left\">$c</td>";
	
	$string .= "</tr>";
	if ($country eq 'dollar') {
		$label = "$SERVER{'canton'}";
		$dep = loadAddImmoCanton();
	}elsif ($country eq 'France') {
		$label = "$SERVER{'depatement'}";
		$dep = loadAddImmoDepartement();
	}

	$string .= "<tr>";
	$string .= "<td align=\"left\">$label</td>";
	$string .= "<td align=\"left\">$dep</td>";
	$string .= "</tr>";
	$string .= "<td align=\"left\">$SERVER{'city_label'}</td>";$string .= "<td align=\"left\"><input type=\"text\" name=\"city\"></td>";
	$string .= "</tr>";
	$string .= "<tr><td align=\"left\">$SERVER{'adress_label'}</td><td align=\"left\"><input type=\"text\" name=\"adress\"></td></tr>";
	$string .= "<tr><td align=\"left\">$SERVER{'nbr_piece'}</td><td align=\"left\"><input type=\"text\" name=\"nbr_piece\"></td></tr>";
	$string .= "<tr><td align=\"left\">$SERVER{'habitable_surface'}</td><td align=\"left\"><input type=\"text\" name=\"habitable_surface\"></td></tr>";
	return $string;
}
sub timeDiff {
	
	my $date1 = shift || '';
	my $date2 = shift || '';
#'2005-08-02 0:26:47', date2 =>  '2005-08-03 13:27:46'
	my  @offset_days = qw(0 31 59 90 120 151 181 212 243 273 304 334);

	my $year1  = substr($date1, 0, 4);
	my $month1 = substr($date1, 5, 2);
	my $day1   = substr($date1, 8, 2);
	my $hh1    = substr($date1,11, 2) || 0;
	my $mm1    = substr($date1,14, 2) || 0;
	my $ss1    = substr($date1,17, 2) if (length($date1) > 16);
		 #$ss1  ||= 0;

	my $year2  = substr($date2, 0, 4);
	my $month2 = substr($date2, 5, 2);
	my $day2   = substr($date2, 8, 2);
	my $hh2    = substr($date2,11, 2) || 0;
	my $mm2    = substr($date2,14, 2) || 0;
	my $ss2    = substr($date2,17, 2) if (length($date2) > 16);
	   #$ss2  ||= 0;

	my $total_days1 = $offset_days[$month1 - 1] + $day1 + 365 * $year1;
	my $total_days2 = $offset_days[$month2 - 1] + $day2 + 365 * $year2;
	my $days_diff   = $total_days2 - $total_days1;

	my $seconds1 = $total_days1 * 86400 + $hh1 * 3600 + $mm1 * 60 + $ss1;
	my $seconds2 = $total_days2 * 86400 + $hh2 * 3600 + $mm2 * 60 + $ss2;

	my $ssDiff = $seconds2 - $seconds1;

	my $dd     = int($ssDiff / 86400);
	my $hh     = int($ssDiff /  3600) - $dd *    24;
	my $mm     = int($ssDiff /    60) - $dd *  1440 - $hh *   60;
	my $ss     = int($ssDiff /     1) - $dd * 86400 - $hh * 3600 - $mm * 60;

	return "$dd J $hh H $mm M $ss Sec";
}


sub loadTvDimension {
	my $string;$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'dimension'}</td>";$string .= "<td align=\"left\"><input type=\"text\" name=\"dimension\"></td>";$string .= "</tr>";
	return $string;
}

sub loadInfoPcProperties {
	my $string;
	$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'processor_ghz'}</td><td align=\"left\"><input type=\"text\" name=\"processor\"></td>";$string .= "</tr>";
	$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'hard_drive_capacity'}</td><td align=\"left\"><input type=\"text\" name=\"hard_drive\"></td>";
	$string .= "</tr>";$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'ram'}</td><td align=\"left\"><input type=\"text\" name=\"ram\"></td>";$string .= "</tr>";
	return $string;
	
}

sub loadQuantity {
	my $string;my $quantity = shift || 0;
	$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'article_quantity_label'}</td><td align=\"left\"><input type=\"text\" name=\"quantity\" value=\"$quantity\"></td>";$string .= "</tr>";
	return $string;
}

sub loadAddWineCountry {
	my $string;my $category = $query->param ("category"); my $subcat= $query->param ("subcat");
        my $load = $query->param("isencher");my $selected = $query->param("wine_country");
	my $region = $query->param("region");my $cepage = $query->param("cepage");
	$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'wine_country'}</td>";$string .= "<td align=\"left\"><select name=\"wine_country\" onchange=\"go11();\">";
	my  ($c)= sqlSelectMany("nom","pays_present","");	
        my  %OPTIONS = ();
	$string .= "<option>---------</option>";
	if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
	while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option value=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&category=$category&isencher=$load&subcat=$subcat&wine_country=$OPTIONS{'category'}&cepage=$cepage&region=$region\">$OPTIONS{'category'}</option>";}
	$string .= "</select></td>";
	$string .= "</tr>";	
}

sub loadAddImmoCountry {
    my $category = $query->param("category");my $subcat = $query->param("subcat");
    my  ($c)= sqlSelectMany("nom","pays_present", "");
    my $selected = $query->param("country");
    my $string = "<select name=\"country\" onchange=\"go9();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&country=$OPTIONS{'category'}&category=$category&subcat=$subcat\">$OPTIONS{'category'}</option>";}
    $string .= "</select>";
    return $string;    
	
}

sub loadAddImmoCanton {
    my $category = $query->param("category");
    my $canton = $query->param("canton");my $country = $query->param("country");
    my $subcat = $query->param("subcat");my $immo_type = $query->param("immo_type");
    my $location_type = $query->param("location_type");my $departement = $query->param("departement");
    my  ($c)= sqlSelectMany("nom", "canton_$lang",  "");    
    my $string = "<select name=\"canton\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($canton) {$string  .= "<option selected value=\"$canton\">$canton</option>"; }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {
	$string .= "<option>$OPTIONS{'category'}</option>" ;}
    $string .= "</select>";
    return $string;    
	
}

sub loadAddImmoDepartement {
    my $departement = $query->param("departement");my $canton = $query->param("canton");
    my $category = $query->param("category");my $subcat = $query->param("subcat");
    my $country = $query->param("country");my $immo_type = $query->param("immo_type");
    my $location_type = $query->param("location_type");

    my  ($c)= sqlSelectMany("nom,code","departement","");    
    my $string = "<select name=\"departement\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    if ($departement) {$string  .= "<option selected value=\"$departement\">$departement</option>";}
    my  %OPTIONS = ();
    while(($OPTIONS{'category'},$OPTIONS{'code'})=$c->fetchrow()) {
	#$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&departement=$OPTIONS{'category'}&country=$country&canton=$canton&immo_type=$immo_type&location_type=$location_type&category=$category&subcat=$subcat&departement=$OPTIONS{'category'}\">$OPTIONS{'category'}($OPTIONS{'code'})</option>" ;
	$string .=  "<option value=\"$OPTIONS{'category'}\">$OPTIONS{'category'}($OPTIONS{'code'})</option>\n";
	}
    $string .= "</select>";
    return $string;    
	
}

sub loadOffshoreProperties {
	my $string;
	$string .= "<tr>";$string .= "<td>$SERVER{'longueur'}</td><td><input type=\"text\" name=\"longueur\"></td>";
	$string .= "<td>$SERVER{'largeur'}</td><td><input type=\"text\" name=\"largeur\"></td>";
	$string .= "</tr>";$string .= "<tr>";$string .= "<td>$SERVER{'chev'}</td><td><input type=\"text\" name=\"horse\"></td>";
	$string .= "</tr>";$string .= "<tr>";$string .= "<td>$SERVER{'conso'}</td><td><input type=\"text\" name=\"conso\"></td>";$string .= "</tr>";
	return $string;
}


sub loadAddGamesType {
    my $category = $query->param("category");my $subcat = $query->param("subcat");
    my $enchere_long = $query->param("enchere_long"); my $load = $query->param("isencher");
    my $cepage = $query->param("cepage");
    my  ($c)= sqlSelectMany("libelle.libelle","type_de_jeu_libelle_langue, libelle, langue","type_de_jeu_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_jeu_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("game_type");
    my $string	;
    $string .= "<tr>";$string .= "<td>$SERVER{'game_type'}</td>";
    $string .= "<td><select name=\"game_type\" onchange=\"go10();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">"; 
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";  }
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&category=$category&subcat=$subcat&game_type=$OPTIONS{'category'}&isencher=$load&enchere_long=$enchere_long&cepage=$cepage\">$OPTIONS{'category'}</option>";	}
    $string .= "</select></td>";
    $string .= "</tr>";
    return $string;    
	
}
sub loadAddWineRegion {
    my $country = $query->param("wine_country");my $region = $query->param("region");my $category = $query->param ("category");
    my $subcat= $query->param ("subcat");my $load = $query->param("isencher");my $cepage = $query->param("cepage");
    my $wine_type = $query->param("wine_type");
    my  ($c)= sqlSelectMany("pays_region_vin.nom","pays_region_vin,pays_present","ref_pays = id_pays_present AND pays_present.nom = '$country' AND  parent_id IS NOT NULL ORDER BY pays_region_vin.nom");    
    my $string = "<td align=\"left\">$SERVER{'region_label'}</td><td align=\"left\"><select name=\"region\" onchange=\"go12();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($region) {$string  .= "<option selected value=\"$region\">$region</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&wine_country=$country&region=$OPTIONS{'category'}&category=$category&subcat=$subcat&isencher=$load&cepage=$cepage&wine_type=$wine_type\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select></td>";
    return $string;    
	
}

sub loadAddWineCepage {
    my $country = $query->param("wine_country");my $region = $query->param("region");my $cepage = $query->param("cepage");
    my $category = $query->param ("category");my $subcat= $query->param ("subcat"); my $load = $query->param("isencher");
    my $wine_type = $query->param("wine_type");
    my  ($c)= sqlSelectMany("cepage.nom","pays_region_vin,cepage","ref_pays_region_vin = id_pays_region_vin AND pays_region_vin.nom = '$region'");    
    my $string = "<tr>";
    $string .= "<td align=\"left\">$SERVER{'cepage'}</td><td align=\"left\"><select name=\"cepage\" onchange=\"go13();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($cepage) {$string  .= "<option selected value=\"$cepage\">$cepage</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&wine_country=$country&region=$region&cepage=$OPTIONS{'category'}&isencher=$load&category=$category&subcat=$subcat&region=$region&wine_type=$wine_type\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select></td></tr>";
    return $string;    
	
	
}
sub loadAddWineType {
    my $country = $query->param("wine_country");my $region = $query->param("region");my $cepage = $query->param("cepage");
    my $category = $query->param ("category");my $subcat= $query->param ("subcat");my $load = $query->param("isencher");
    my ($c)= sqlSelectMany("libelle.libelle","subcategorie_libelle_langue, libelle, langue","subcategorie_libelle_langue.ref_categorie = 16 AND subcategorie_libelle_langue.ref_libelle = libelle.id_libelle AND subcategorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my $selected = $query->param("wine_type");   
    my $string = "<tr><td>$SERVER{'wine_type'}</td><td><select name=\"wine_type\" onchange=\"go14();\" onfocus=\"skipcycle=true\" onblur=\"skipcycle=false\">";
    my $departement = $query->param("departement");
    if ($selected) {$string  .= "<option selected value=\"$selected\">$selected</option>";}
    $string  .= "<option value=\"\">--------</option>";
    my  %OPTIONS = ();    
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option VALUE=\"/cgi-bin/recordz.cgi?lang=$lang&amp;page=add_other&session=$session_id&wine_country=$country&wine_type=$OPTIONS{'category'}&region=$region&isencher=$load&category=$category&subcat=$subcat&cepage=$cepage\">$OPTIONS{'category'}</option>" ;}
    $string .= "</select></td></tr>";
    return $string;    
}

sub loadAutor {
	my $string;
	$string .= "<tr><td>$SERVER{'autor'}</td><td><input type=\"text\" name=\"autor\" onchange=\"validateInput()\"></td>";
	$string .= "<tr><td>$SERVER{'year'}</td><td><input type=\"text\" name=\"year\" onchange=\"validateYear()\"></td>";
	return $string;
}
sub loadUsedOrNew {
    my $country = $query->param("wine_country");my $region = $query->param("region");my $cepage = $query->param("cepage");
    my $category = $query->param ("category");my $subcat= $query->param ("subcat");my $load = $query->param("isencher");
    my $string;my  ($c)= sqlSelectMany("libelle.libelle", "etat_libelle_langue, libelle, langue", "etat_libelle_langue.ref_libelle = libelle.id_libelle AND etat_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
    my  %OPTIONS = ();
    $string .= "<td align=\"left\">$SERVER{'used'}</td><td align=\"left\"><select name=\"used\">";
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "<option>$OPTIONS{'category'}</option>";}
    $string .= "</select></td></tr>";
    return $string;    
	
}

sub getCategoryID {
    my  $category = shift || '';   
    my  ($c)= sqlSelectMany("ref_categorie","categorie_libelle_langue, libelle","libelle.libelle = '$category' AND categorie_libelle_langue.ref_libelle = libelle.id_libelle AND categorie_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");	
    my  $string = "";my  %OPTIONS = ();
    while(($OPTIONS{'category'})=$c->fetchrow()) {$string .= "$OPTIONS{'category'}";}
    return $string;    
}

sub getCurrentCarProperties {
    my $maincat = $query->param("category");my $subcat = $query->param("subcat");my $load = $query->param("isencher");
    my $name =$query->param("name");my $article = $query->param("article");
    my $string; my $type_essence = $query->param("type_essence");my $clima;



    ($ARTICLE{'nb_cheveaux'},$ARTICLE{'nb_km'},$ARTICLE{' premiere_immatriculation '},
     $ARTICLE{'annee_construction'},$ARTICLE{'limp_speed'},$ARTICLE{'climatisation'},$ARTICLE{'year_fab'},$ARTICLE{'ref_type_essence'},$ARTICLE{'ref_boite_de_vitesse'})= sqlSelect("nb_cheveaux,nb_km,premiere_immatriculation,annee_construction,clima,annee, ref_type_essence, ref_boite_de_vitesse",
				 "article,boite_de_vitesse_libelle_langue,type_essence_libelle_langue",
				 "id_article ='$article' and ref_boite_de_vitesse = id_boite_de_vitesse and essence_ou_diesel = id_type_essence");	


    my $type_essence = sqlSelect("libelle.libelle", "type_essence_libelle_langue, libelle, langue", "type_essence_libelle_langue.ref_libelle = '$ARTICLE{'ref_type_essence'}' AND type_essence_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";
    my $ref_boite_de_vitesse = sqlSelect("libelle.libelle", "type_boite_de_vitesse_libelle_langue, libelle, langue", "type_boite_de_vitesse_libelle_langue.ref_libelle = '$ARTICLE{'ref_boite_de_vitesse'}' AND boite_de_vitesse_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')"11;
    if ($ARTICLE{'climatisation'} eq '0') {$clima = $SERVER{'no'};}else {$clima = $SERVER{'yes'};}
    $string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'chev'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"horse\" value=\"$ARTICLE{'nb_cheveaux'}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'nbr_km'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"km\" value=\"$ARTICLE{'nb_km'}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'year_fabrication'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"year_fabrication\" value=\"$ARTICLE{'year_fab'}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'year_service'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"year_service\" value=\"$ARTICLE{' premiere_immatriculation '}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'essence_type'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" value=\"$type_essence\">";
    $string .= "</td>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'limp_speed'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" value=\"$ref_boite_de_vitesse\">";
    $string .= "</td>";$string .="<tr>"; $string .="<td align=\"left\" width=\"120\">$SERVER{'climatisation'}</td>";
    $string .="<td align=\"left\">$clima</td>";
    $string .= "</tr>";
    return $string;
}

sub getCurrentMotoProperties {
    my $maincat = $query->param("category");my $subcat = $query->param("subcat");my $load = $query->param("isencher");
    my $name =$query->param("name");my $article = $query->param("article");
    my $string; my $type_essence = $query->param("type_essence");my $clima;



    ($ARTICLE{'nb_cheveaux'},$ARTICLE{'nb_km'},$ARTICLE{' premiere_immatriculation '},
     $ARTICLE{'annee_construction'},$ARTICLE{'ref_limp_speed'},$ARTICLE{'climatisation'},$ARTICLE{'year_fab'},$ARTICLE{'ref_type_essence'})= sqlSelect("nb_cheveaux,nb_km,premiere_immatriculation,annee_construction,ref_boite_de_vitesse,clima,annee,ref_type_essence",
				 "article,boite_de_vitesse_libelle_langue,type_essence_libelle_langue",
				 "id_article ='$article' and ref_boite_de_vitesse = id_boite_de_vitesse and essence_ou_diesel = id_type_essence");	


    my $type_essence = sqlSelect("libelle.libelle", "type_essence_libelle_langue, libelle, langue", "type_essence_libelle_langue.ref_libelle = '$ARTICLE{'ref_type_essence'}' AND type_essence_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')";
    my $ref_boite_de_vitesse = sqlSelect("libelle.libelle", "type_boite_de_vitesse_libelle_langue, libelle, langue", "type_boite_de_vitesse_libelle_langue.ref_libelle = '$ARTICLE{'ref_boite_de_vitesse'}' AND boite_de_vitesse_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang')"11;

    if ($ARTICLE{'climatisation'} eq '0') {$clima = $SERVER{'no'};}else {$clima = $SERVER{'yes'};}
    $string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'chev'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"horse\" value=\"$ARTICLE{'nb_cheveaux'}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'nbr_km'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"km\" value=\"$ARTICLE{'nb_km'}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'year_fabrication'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"year_fabrication\" value=\"$ARTICLE{'year_fab'}\"></td>";
    $string .="</tr>";$string .="<tr>";$string .="<td align=\"left\" width=\"120\">$SERVER{'year_service'}</td>";
    $string .="<td align=\"left\" width=\"120\"><input type=\"text\" name=\"year_service\" value=\"$ARTICLE{' premiere_immatriculation '}\"></td>";
    $string .= "</tr>";
    return $string;
}

sub loadFabricantProperties {	
	my $string;
	$ARTICLE{'author'} = shift || '';
	my $libelle = shift || $SERVER{'fabricant'};
	my $enchere = shift || '';
	my $encherereur;
	if ($enchere) {	$encherereur= getLastEnchereurDetail();}
	$string .= "<tr><td align=\"left\">$libelle</td><td align=\"left\"><input type=\"text\" name=\"fabricant\" value=\"$ARTICLE{'author'}\" onchange=\"validateInput();\"></td>$encherereur</tr>";
	return $string;	
}

sub loadPayementModeProperties {
	my $string;$ARTICLE{'payement_mode'} = shift || '';$
	ARTICLE{'deliver_mode'}  = shift || '';	
	$string .= "<tr><td align=\"left\" ><label>$SERVER{'payement_mode'}</LABEL></td><td align=\"left\"><input type=\"text\"  name=\"payement_mode\" value=\"$ARTICLE{'payement_mode'}\"></td></tr>";	
	$string .= "<tr><td align=\"left\" >$SERVER{'deliver_mode'}</td><td align=\"left\"><input type=\"text\"  name=\"deliver_mode\" value=\"$ARTICLE{'deliver_mode'}\" ></td></tr>";
}

sub getLinkImmobilierInterest {
         my $article = $query->param("article");
        my $string ;
	$string .= "<a href=\"#\" class=\"menulink\" class=&{ns4class}; onclick=\"window.open('/cgi-bin/recordz.cgi?lang=$lang&amp;session=$session_id&page=askvisit&amp;article=$article','MyWindow3','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=530,height=650,left=20,top=20')\">Demander une visite</a><br/>";
	return $string;
}

sub loadDimensionOther {
	my $string;my $dimension = shift || '';
	$string .= "<tr><td align=\"left\">Dimension: </td><td align=\"left\"><input type=\"text\" name=\"dimension\" value=\"$dimension\"></td></tr>";
	return $string;
}

sub loadDetailInfoPcProperties {
    my $string;
    my $processor = shift || '';
    my $hard_drive2 = shift || '';
    my $ram = shift || '';
    $string .= "<tr><td align=\"left\">$SERVER{'processor_ghz'}</td><td align=\"left\"><input type=\"text\" name=\"processor\" value=\"$processor\"></td></tr>";
    $string .= "<tr><td align=\"left\">$SERVER{'hard_drive_capacity'}</td><td align=\"left\"><input type=\"text\" name=\"hard_drive\" value=\"$hard_drive2\"></td></tr>";
    $string .= "<tr><td align=\"left\">$SERVER{'ram'}</td><td align=\"left\"><input type=\"text\" name=\"ram\" value=\"$ram\"></td></tr>";
    return $string;
}

sub loadStyle {
    my $string;my $style = shift || '';$string .= "<tr><td align=\"left\">$SERVER{'search_genre_label'}</td><td align=\"left\"><input type=\"text\" name=\"style\" value=\"$style\" onchange=\"validateInput()\"></td></tr>";return $string;
}

sub loadQuantityWanted {
    my $string;$string .= "<tr><td align=\"left\">$SERVER{'quantity_wanted'}</td><td align=\"left\"><input type=\"text\" name=\"quantity_wanted\" onchange=\"validateInput()\"></td></tr>";return $string;
}

sub loadDetailOffshoreProperties {
	my $longueur = shift || '';my $largeur = shift || '';my $chev = shift || '';
	my $conso = shift || '';	my $string;
	$string .= "<tr><td>$SERVER{'longueur'}</td><td><input type=\"text\" name=\"longueur\" value=\"$longueur\"></td><td>$SERVER{'largeur'}</td><td align=\"left\"><input type=\"text\" name=\"largeur\" value=\"$largeur\" style=\"width:100px\"></td>";
	$string .= "</tr><tr><td>$SERVER{'chev'}</td><td><input type=\"text\" name=\"horse\" value=\"$chev\"></td></tr>";
	$string .= "<tr><td>$SERVER{'conso'}</td><td><input type=\"text\" name=\"conso\" value=\"$conso\"></td></tr>";
	return $string;
}

sub loadDvdProperties {
	my $string;my $actors = shift || '';my $realisator = shift || '';my $year = shift || '';my $duration = shift || '';
	$string .= "<tr><td>$SERVER{'actor'}</td><td><input type=\"text\" name=\"actor\" value=\"$actors\"></td></tr>";
	$string .= "<tr><td>$SERVER{'realisator'}</td><td><input type=\"text\" name=\"realisator\" value=\"$realisator\"></td></tr>";
	$string .= "<tr><td>$SERVER{'year'}</td><td><input type=\"text\" name=\"year_fabrication\" value=\"$year\"></td></tr>";
	$string .= "<tr><td>$SERVER{'duration'}</td><td><input type=\"text\" name=\"duration\" value=\"$duration\"></td></tr>";
	return $string;
}
sub loadDvdGenre {
	my $string;my $genre = shift || '';
	$string .= "<tr><td>$SERVER{'search_genre_label'}</td><td><input type=\"text\" name=\"genre\" value=\"$genre\"></td></tr>";
	return $string;
}

sub loadSnowboardSize {
	my $string;my $size = shift || '';
	$string .= "<tr><td>$SERVER{'size'}</td><td><input type=\"text\" name=\"size\" value=\"$size\"></td></tr>";
	return $string;
}

sub loadSkypeLink {
	my $string;my $skype = shift || '';
	$string .= "<a href=\"callto://$skype\"><img alt=\"\" src=\"http://goodies.skype.com/graphics/skypeme_btn_small_green.gif\" style=\"border:1px;border-style:dotted;\"></a>";
	return $string;
}

sub loadWineProperties {
	my $ref_cepage = shift || '';my $ref_pays_region_vin = shift || '';my $ref_type_de_vin = shift || '';
	my $provenance = shift || '';my $year = shift || '';$year = substr ($year,0,4);
	my ($pays_provenance ) = sqlSelect("nom",  "pays_present",  "id_pays_present = '$provenance'");
	my ($pays_region_vin) = sqlSelect("pays_region_vin.nom",  "pays_region_vin",  "id_pays_region_vin = '$ref_pays_region_vin' ");
	my ($type_de_vin) = sqlSelect("libelle.libelle", "type_de_vin_libelle_langue", "ref_type_de_vin = '$ref_type_de_vin' AND type_de_vin_libelle_langue.ref_libelle = libelle.id_libelle AND type_de_vin_libelle_langue.ref_langue = langue.id_langue AND langue.key = '$lang'");
	my ($cepage) = sqlSelect("cepage.nom",  "cepage",  "id_cepage = '$ref_cepage'");
	my $string;
	$string .= "<tr><td>$SERVER{'coutry_com'}</td><td><input type=\"text\" value=\"$pays_provenance\"></td></tr>";
	$string .= "<tr><td>$SERVER{'country_reg'}</td><td><input type=\"text\" value=\"$pays_region_vin\"></td></tr>";
	$string .= "<tr><td>$SERVER{'cepage'}</td><td><input type=\"text\" value=\"$cepage\"></td></tr>";
	$string .= "<tr><td>$SERVER{'millesim'}</td><td><input type=\"text\" value=\"$year\"></td></tr>";
	$string .= "<tr><td>$SERVER{'wine_t'}</td><td><input type=\"text\" value=\"$type_de_vin\"></td></tr>";
	return $string;
}

sub loadAuteur {
	my $auteur = shift || '';my $year = shift || '';my $string;
	$string .= "<tr><td>$SERVER{'autor'}</td><td><input type=\"text\" name=\"auteur\" value=\"$auteur\"></td></tr>";
	$string .= "<tr><td>$SERVER{'year'}</td><td><input type=\"text\" name=\"year\" value=\"$year\"></td></tr>";
	return $string;
}

sub loadWearSize {
	my $string;my $size = shift || '';
	$string .= "<tr><td>$SERVER{'size'}</td><td><input type=\"text\" name=\"size\" value=\"$size\"></td></tr>";
	return $string;
}

sub loadUsedOrNewDetail {
	my $string;my $used_value = shift || '';
	$string .= "<tr><td>$SERVER{'used'}</td><td><input type=\"text\" name=\"used\" value=\"$used_value\"></td></tr>";
	return $string;
}
sub loadWat {
	my $wat = shift || '';my $string;
	$string .= "<tr><td>$SERVER{'wat'}</td><td><input type=\"text\" name=\"wat\" value=\"$wat\"></td></tr>";
	return $string;
}



sub loadCityLocationValue {
	my $string;my $canton = shift || '';my $lieu = shift || '';my $nb_piece = shift || '';my $habitable_surface = shift || '';my $location_ou_achat = shift || '';my $adresse = shift || '';
	my $npa = shift || '';my $city = shift || '';
	my $country = shift || '';
	$string .= "<tr>";
	$string .= "<td align=\"left\">$SERVER{'label_location_or_buy'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"location_ou_achat\" value=\"$location_ou_achat\"></td>";
	$string .= "</tr>";
	$string .= "<td align=\"left\">$SERVER{'canton'}</td>";$string .= "<td align=\"left\"><input type=\"text\" name=\"canton\" value=\"$canton\"></td>";$string .= "</tr>";
	$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'city_label'}</td>";$string .= "<td align=\"left\"><input type=\"text\" name=\"location_place\" value=\"$lieu\"></td>";$string .= "</tr>";$string .= "<tr>";$string .= "<td align=\"left\">$SERVER{'adress'}</td>";
	$string .= "<td align=\"left\">$adresse</td>";
	if ($country eq '1') {$string .= "<td align=\"left\"><a href=\"javascript:void(0)\" class=\"menulink\"  onclick=\"window.open('http://map.search.ch/$npa-$city/$adresse','MyWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=800,height=600,left=20,top=20')\">Trouver sur la carte</a></td>";
	}elsif ($country eq '2') {$string .= "<td align=\"left\"><a href=\"javascript:void(0)\" class=\"menulink\"  onclick=\"window.open('http://www.maporama.com/affiliates/popup/share/Map.asp?_XgoGCAdrCommand=run&language=$lang&_XgoGCAddress=$adresse+%E9curies&Zip=$npa&_XgoGCTownName=$city&COUNTRYCODE=FR&submit.x=57&submit.y=10','MyWindow','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=800,height=600,left=20,top=20')\">Trouver sur la carte</a></td>";}
	$string .= "</tr>";
	$string .= "<tr><td align=\"left\">$SERVER{'nbr_piece'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"nbr_piece\" value=\"$nb_piece\"></td>";
	$string .= "</tr>";
	$string .= "<tr><td align=\"left\">$SERVER{'habitable_surface'}</td>";
	$string .= "<td align=\"left\"><input type=\"text\" name=\"habitable_surface\" value=\"$habitable_surface\"></td>";
	$string .= "</tr>";
	return $string;
}


sub loadIsBuyOrLocationValue {
	my $string;
	$string .= "<tr><td align=\"left\">$SERVER{'label_location_or_buy'}</td><td align=\"left\"><select name=\"is_location_or_buy\">";
	$string .= "<option>$SERVER{'location'}</option><option>$SERVER{'buy'}</option></select></td></tr>";
	return $string;
}
