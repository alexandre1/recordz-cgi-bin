package Initialize;

use Exporter;
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Compress::Zlib;


use vars qw ($session_dir $session $session_id $action $SESSIONID);
#intialize db connection


#Set the values and initilize db connexion and query

$query = CGI->new ;


#create a new session


BEGIN {
    use Exporter ();
  
    @Initialize::ISA = qw(Exporter);
    @Initiliaze::EXPORT      = qw();
    @Initiliaze::EXPORT_OK   = qw($session_dir $query $session_dir $session $session_id $action);
}