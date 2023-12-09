#!/usr/bin/perl -w
package Recordz::Auction::SharedVariable;
use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Compress::Zlib;
use CGI::Session qw/-ip-match/;
use Recordz::Auction::Initialize;
use vars qw ($action $session_id $can_do_gzip $current_ip $lang $LANG %ARTICLE %SESSION %SERVER %USER $CGISESSID %LABEL %ERROR %VALUE $COMMANDID %COMMAND %DATE %PAYPALL $INDEX %LINK  $query $session $host $t0  $client);

#Set the values to the global variables
$current_ip = $ENV{'REMOTE_ADDR'};
$client = $ENV{'HTTP_USER_AGENT'};
$t0 = gettimeofday();
$host = "http://avant-garde.no-ip.biz";
%ERROR = ();%LABEL = ();$LANG = "";%LINK = ();%ARTICLE = ();%SESSION = ();%SERVER = ();

$action = $query->param('action');
$session_id  =  $query->param('session');
$can_do_gzip = ($ENV{'HTTP_ACCEPT_ENCODING'} =~ /gzip/i) ? 1 : 0; 
