#!C:/Strawberry/perl/bin/perl.exe -w
use strict;
use warnings;
use CGI::Lite ();

my $now = localtime (time ());
my $cgi = CGI::Lite->new;

# Retrieve existing cookies
my $cookies = $cgi->parse_cookies;
my $oldcookie = defined ($cookies) ? $cookies->{USERNAME} : 'not set';

# Set new cookie
print "Set-Cookie: USERNAME=alexandre\nContent-Type: text/html\n\n";

# Print the page
print <<EOT;
<p>Previous cookie value was $oldcookie<br />
New cookie value is alexandre</p>

<p><a href="$ENV{REQUEST_URI}">Get next one</a>.</p>
EOT
exit;