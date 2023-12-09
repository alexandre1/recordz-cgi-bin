#!C:/Strawberry/perl/bin/perl.exe -w
use strict;
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

my $email = Email::Simple->create(
  header => [
    To      => 'alexjaquet@gmail.com',
    From    => 'robot@avant-garde.no-ip.biz',
    Subject => 'Hi! c0der',
  ],
  body => "This is my message\n",
);

sendmail($email, { transport => $transport });
print "Content-Type: text/html\n\n";
print "Send email from windows 10 ok";
