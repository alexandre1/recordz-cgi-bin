#!C:/Strawberry/perl/bin/perl.exe -w
use CGI;
use Image::Thumbnail;

my $imgdir=  "C:/Users/41786/OneDrive/Documents/recordz1/upload";
my $query = new CGI;

uploadImage('test_upload.jpg');

sub uploadImage {
    my  $name = shift || '';
    my  $file = $query->upload('image');	
    
    open(LOCAL, ">$imgdir/$name") or print 'error';
    my $file_handle = $query->upload('image');                                
    binmode LOCAL;
    while(<$file_handle>) {        
	print LOCAL;
 }
    close($file_handle);           
    close(LOCAL);
    createImageMagickThumb("$name");	
}


sub createImageMagickThumb {

    my  $filename = shift || '';
    my $t = new Image::Thumbnail(
            size       => 55,
            create     => 1,
            module     => 'Imager',
            input      => "$imgdir/$filename",
            outputpath => "$imgdir/test.$filename",
    );

    print "Content-Type: text/html\n\n";
    print "outputpath => '$imgdir/test.$filename'";
}