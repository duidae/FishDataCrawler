#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode qw(decode encode);
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $filename = "all.html";
open(my $FILE, '<:encoding(UTF-8)', $filename) or die "Cant open file $filename";

while(my $line = <$FILE>) {
	chomp($line);
	$line =~ s/^[\s|\t]+//g;

	$line =~ s/><td/>\n<td/g;
	$line =~ s/><\/tr/>\n<\/tr/g;

	if($line =~ m//) {
	} else {
		print "$line\n";
	}
}
close($FILE);
