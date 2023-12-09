#!C:/Strawberry/perl/bin/perl.exe -w
use warnings;
use Image::Thumbnail;
use CGI;
use Image::Magick;

my $query = CGI->new ;
$imgdir=  "C:/Users/41786/OneDrive/Documents/recordz1/upload";

# With Image Magick

my $file = $query->param("image");

uploadImage("1.jpg");

sub uploadImage {
    my  $name = shift || '';
    my  $file = $query->param('image');	
    
    open(LOCAL, ">$imgdir/$name") or print 'error';
    my $file_handle = $query->upload('image');                                
    binmode LOCAL;
    while(<$file_handle>) {        
	print LOCAL;
 }
    close($file_handle);           
    close(LOCAL);
    	
    $t = new Image::Thumbnail(
        size       => "55x75",
        create     => 1,
        module	   => "Image::Magick",
        input      => "$imgdir/$file",
        outputpath => "$imgdir/thumb.$name.jpg");
}
