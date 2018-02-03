#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode qw(decode encode);
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
use File::Basename;

my $filename = "all.html.02.value_only";
my @attr = ("order", "family", "species", "occurrence", "fishbase_name", "name", "photo_link", "thumbnail");
my %families;

open(my $FILE, '<:encoding(UTF-8)', $filename) or die "Cant open file $filename";
while(my $line = <$FILE>) {
	chomp($line);

	$line =~ m/photo_link=\"([^\"]*)\"/;
	my $piclink = $1;

	if($piclink ne "") {
		$piclink =~ m/ID=(\d+)$/;
		my $id = $1;

		print "wget -O ./fish_pics/ID=$id $piclink\n";
	}
}
close($FILE);
