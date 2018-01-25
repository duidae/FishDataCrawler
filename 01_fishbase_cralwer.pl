#!/usr/bin/perl

use strict;
use warnings;
use utf8;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

my $fishbase_url = "http://www.fishbase.org/Country/CountryChecklist.php?what=list&trpp=50&c_code=156A&csub_code=&cpresence=present&sortby=alpha2&ext_pic=on&vhabitat=all2";



my $filename = $ARGV[0];
open(my $FILE, '<:encoding(UTF-8)', $filename) or die "Cant open file $filename";

my $DL_dir = "./download/";
while(my $line = <$FILE>) {
	chomp($line);
	$line =~ s/^\s+|\s+$//g;

	my @fields = split(' ',$line);

	# trim ""
	foreach my $i (0..@fields-1) {
		$fields[$i] =~ s/^\"|\"$//g;
	}

	# fields: [district_caseNumber] [case official number] [announcement url/NA] [case name] [title_url]+
	if(@fields <= 4) {
		print "Incorrect field $line\n";
	} else {
		my $district = $fields[0];
		my $announcement_url = $fields[2];
		my $casename = $fields[3];

		# download announcement
		if($announcement_url ne "NA") {
			my @url_seg = split('/', $announcement_url);
			my $file_name = $url_seg[@url_seg-1];

			my @ext = split('\.',$file_name);
			my $ext_name = $ext[@ext-1];
			my $new_name = $DL_dir."[$district]".$casename."_announcement.$ext_name";
			$new_name =~ s/\(/[/g;
			$new_name =~ s/\)/]/g;

			print "wget --random-wait -O $new_name $announcement_url\n";
			#system "wget --random-wait -O $new_name $announcement_url";
		}

		# download other url
		for(my $i = 4; $i < @fields; $i++) {
			my $field = $fields[$i];
			my @seg = split('_', $field);
			my $title = $seg[0];
			my $url = $seg[1];

			my @url_seg = split('/', $url);
			my $file_name = $url_seg[@url_seg-1];

			my @ext = split('\.',$file_name);
			my $ext_name = $ext[@ext-1];
			my $new_name = $DL_dir."[$district]".$casename."_$title.$ext_name";
			$new_name =~ s/\(/[/g;
			$new_name =~ s/\)/]/g;

			print "wget --random-wait -O $new_name $url\n";
			#system "wget --random-wait -O $new_name $url";
		}
	}
}
close($FILE);
