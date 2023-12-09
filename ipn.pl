#!C:/Strawberry/perl/bin/perl.exe -w
BEGIN {
$| = 1; # Flush
use strict;
use MyDB;
use warnings;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTPS ();
use Email::Simple ();
use Email::Simple::Creator ();

my $smtpserver = 'smtp.gmail.com';
my $smtpport = '587';
my $smtpuser   = 'alexjaquet@gmail.com';
my $smtppassword = 'bxwpypgecjwvvthp';

my $transport = Email::Sender::Transport::SMTPS->new({
  host => $smtpserver,
  port => $smtpport,
  ssl => "starttls",
  sasl_username => $smtpuser,
  sasl_password => $smtppassword,
});

# Catch fatal errors and die with 200 OK plain/text header
# This is done because IPN will keep sending up to 16 requests
# till the right header is posted.
$SIG{__DIE__} = \&print_header;
}
#my $Just_Exit = 0; # if you need it

# Lots of servers will not resolve the IP to a host name
# So variable $ENV{'REMOTE_HOST'} will not have a value.
# If you want any security check if it is a PayPal IP.
#die('Does not match PayPal at IP:'.$ENV{'REMOTE_ADDR'})
# if ($ENV{'REMOTE_ADDR'} ne '173.0.82.66');

# comment the one your not using
my $PP_server = 'ipnpb.sandbox.paypal.com'; # sandbox IP:173.0.82.66
#my $PP_server = 'ipnpb.paypal.com'; # production IP:173.0.88.40

# It is highly recommended that you use version 6 upwards of
# the UserAgent module since it provides for tighter server
# certificate validation
use LWP::UserAgent 6;

# read post from PayPal system and add 'cmd'
use CGI qw(:standard);
my $cgi = CGI->new();
my $db = MyDB->new();
my $query = 'cmd=_notify-validate&';
$query .= join('&', map { $_.'='.$cgi->param($_) } $cgi->param());

# post back to PayPal system to validate
my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1,SSL_version => 'SSLv23:!TLSv12' });
my $req = HTTP::Request->new('POST', 'https://'.$PP_server.'/cgi-bin/webscr');
$req->content_type('application/x-www-form-urlencoded');
$req->header(Host => $PP_server);
$req->content($query);
my $res = $ua->request($req);

# make the variable hash
my %variable =
 map { split(m'='x, $_, 2) }
 grep { m'='x }
 split(m'&'x, $query);

# assign posted variables to local variables
$item_name = $variable{'item_name'};
$item_number = $variable{'item_number'};
$payment_status = $variable{'payment_status'};
$payment_amount = $variable{'mc_gross'};
$payment_currency = $variable{'mc_currency'};
$txn_id = $variable{'txn_id'};
$receiver_email = $variable{'receiver_email'};
$payer_email = $variable{'payer_email'};
print "Content-Type: text/html\n\n"; 
print $res->content."\n";

if ($res->is_error) {
 # HTTP error
}
elsif ($res->content eq 'VERIFIED') {
 # check the $variable{'payment_status'}=Completed
 if ($payment_status eq 'Completed') {
        print "Completed";
        #my  ($tx)=$db->sqlSelect1("tx", "article", "id_article = $item_number");            	
  }
 # check that payment_amount $variable{'mc_gross'}/payment_currency $variable{'mc_currency'} are correct
 # process payment
}
elsif ($res->content eq 'INVALID') {
 # log for manual investigation
}
else {
 # error
}
# end with header or will die with header
print_header('Good');

sub print_header {
my $error = shift || '';
# what you do here can die like logging. That can be detected with $Just_Exit
# so we know we have been here before and not to run the thing that died
# if ( $error ne 'Good' && ! $Just_Exit ) {
# $Just_Exit = 1;
# log($error);
# }
# error will be the die info with \n

# Static Header. Do not use CGI.pm for header, it can die.
print <<'HEADER';
Content-Type: text/plain
HEADER
exit(0);
} 