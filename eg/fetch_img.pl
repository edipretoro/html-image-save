#!/usr/bin/env perl -w

use strict;
use warnings;

use LWP::Simple;

use lib './../lib';
use HTML::Image::Save;
use File::Slurp;
use File::Basename;

my $uri = shift or die "Usage: $0 url\n";
my $html = get( $uri ) or die "Unable to get content from $uri\n";

my $img_saver = HTML::Image::Save->new(
    base_url => $uri,
    output_dir => './data',
    img_dir => 'img',
);

$img_saver->html( $html );
write_file(basename( $uri ) || 'index.html', $img_saver->save());

