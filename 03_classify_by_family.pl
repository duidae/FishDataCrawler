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
my $outputdir = "./thumbnail_classify_by_family";
my %families;

open(my $FILE, '<:encoding(UTF-8)', $filename) or die "Cant open file $filename";
while(my $line = <$FILE>) {
	chomp($line);

	$line =~ m/family=\"([^\"]*)\"/;
	my $family = $1;

	$line =~ m/thumbnail=\"([^\"]*)\"/;
	my $thumbnail = $1;
	if($thumbnail ne "") {
		$thumbnail =~ s/\s/\\ /g;
		$families{$family}++;
		my $basename = basename($thumbnail);
		my $outputfilename = "$family" . "_" . "$families{$family}" . "_" . $basename;
		print "cp $thumbnail $outputdir\n";
		print "mv $outputdir/$basename $outputdir/$outputfilename\n";
	}
}
close($FILE);
