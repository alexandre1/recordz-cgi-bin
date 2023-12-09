#!C:/Strawberry/perl/bin/perl.exe -w

use strict; 
use warnings; 
use MIME::Lite;

my  $Message = new MIME::Lite From =>'robot@localhost.localdomain',
   		      To =>'alexjaquet@gmail.com', Subject =>'test' ,
		      Type =>'TEXT',
		      Data =>'test register under windows 10';
$Message->attr("content-type" => "text/html; charset=iso-8859-1");
$Message->send('smtp', "smtp.gmail.com", 
  SSL=>1,
  AuthUser=>'alexjaquet@gmail.com',  AuthPass=>'ludo%_21$$$alexandre1980', Debug=>1); 

print "Content-Type: text/html\n\n";
print "Send email from windows 10 ok";
