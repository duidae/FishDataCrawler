#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode qw(decode encode);
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
use File::Basename;
use HTML::TreeBuilder::XPath;

my $filename = "all.html.02.value_only";
my @attr = ("order", "family", "species", "occurrence", "fishbase_name", "name", "photo_link", "thumbnail");
my %families;

my $picfile = "./fish_pics/ID=9";
open(my $PICFILE, $picfile) or die "Cant open file $picfile";

my $t = HTML::TreeBuilder::XPath->new();

$t->parse_file($picfile) or die "Could not parse $file\n";

foreach my $img ( $t->findnodes( '//img' ) ) {

	my $src = $img->attr('src');

	print $img->as_HTML, "\n";
}

