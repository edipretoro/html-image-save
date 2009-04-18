#!/usr/bin/env perl -w

use strict;
use warnings;

use LWP::Simple;

use lib './../lib';
use HTML::Image::Save;
use File::Slurp;
use File::Basename;
use File::Spec;
use File::Path;

use GD::Image;

my $uri = shift or die "Usage: $0 url\n";
my $html = get( $uri ) or die "Unable to get content from $uri\n";

my $img_saver = HTML::Image::Save->new(
    base_url => $uri,
    output_dir => './data',
    img_dir => 'img',
    callback => \&convert_to_jpeg,
);

$img_saver->html( $html );
$html = $img_saver->save();
write_file(basename( $uri ) || 'index.html', $html);

sub convert_to_jpeg {
    my ($self, $image, $local_link) = @_;

    my ($file, $path, $ext) = fileparse( $local_link, qr/\.[^.]*/ );
    my $jpeg_file = File::Spec->catfile( $path, $file . '.jpg' );
    
    my $img = GD::Image->new( $local_link );
    open(my $fh, '>', $jpeg_file);
    binmode($fh);
    print $fh $img->jpeg();
    close($fh);
    $image->attr('src', $jpeg_file);
    rmtree( $local_link );
}
