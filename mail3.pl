#!C:/Strawberry/perl/bin/perl.exe -w

$to = 'alexjaquet@gmail.com';
$from = 'robot@company.com';
$subject = 'Party!!!';
$message = 'Details of party';

open(MAIL, "|c:/xampp/sendmail/sendmail.exe -t") or die "could not find sendmail";

# Email Header
print MAIL "To: $to\n";
print MAIL "From: $from\n";
print MAIL "Subject: $subject\n\n";
# Email Body
print MAIL $message;

close(MAIL);

print "Content-Type: text/html\n\n";
print "Send email from windows 10 ok";
