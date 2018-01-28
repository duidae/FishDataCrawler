#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode qw(decode encode);
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $filename = "all.html.01.tr_td_only";
open(my $FILE, '<:encoding(UTF-8)', $filename) or die "Cant open file $filename";

my @attr = ("order", "family", "species", "occurrence", "fishbase_name", "name", "photo_link");

my $td_counter = 0;
my $value = "";
while(my $line = <$FILE>) {
	chomp($line);

	# match </tr>
	if($line =~ /<\/tr>/) {
		$td_counter = 0;
	}

	# match <td></td>
	if($line =~ /<td[^>]*>/) {
		$td_counter++;
		$line =~ s/<td[^>]*>//;
		$line =~ s/<\/td>//;
		$value = $line;

		if($td_counter == 3) { #species
			$value =~ m/<a[^>]*>([^<]*)<\/a>/;
			my $species = $1;
			print "$attr[$td_counter-1]\=\"$species\" ";
		} elsif ($td_counter == 7) { #photo_link
			my $link = "";
			if($value =~ m/href=\"([^"]*)\"/) {
				$link = $1;
			}
			
			my $thumbnail = "";
			if($value =~ m/img src=\"([^"]*)\"/) {
				$thumbnail = $1;
			}

			print "$attr[$td_counter-1]\=\"$link\" thumbnail=\"$thumbnail\"\n";
		} else {
			print "$attr[$td_counter-1]\=\"$value\" ";
		}
	}
}
close($FILE);
