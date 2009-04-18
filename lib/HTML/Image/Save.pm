package HTML::Image::Save;

use warnings;
use strict;

use base qw( Class::Accessor::Fast Class::ErrorHandler );
__PACKAGE__->mk_accessors(qw(
    base_url
    output_html
    html
    output_dir
    img_dir
));

use HTML::TreeBuilder;
use LWP::Simple;
use HTML::ResolveLink;
use Carp;
use File::Spec;
use File::Basename;
use File::Path;

=head1 NAME

HTML::Image::Save - Extract and save images from a HTML file

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Extract and save images from a HTML file

    use HTML::Image::Save;
    use LWP::Simple;

    my $html = get('http://en.wikipedia.org/wiki/Web_Scraping');
    my $img_saver = HTML::Image::Save->new();
    $img_saver->html( $html );
    $img_saver->output_html( 'web_scraping.html' );
    $img_saver->output_dir( './' );
    $img_saver->img_dir( 'images' );
    $img_saver->save();

    # or

    my $img_saver = HTML::Image::Save->new(
       output_dir => './',
       img_dir => 'images',
    );
    $img_saver->html( $html );
    $img_saver->output_html( 'web_scraping.html' );
    $img_saver->save();

    # so, the final HTML will be stored in './web_scraping.html' and images will be saved under './images/'

=head1 FUNCTIONS

=head2 new

=cut

sub new {
    my ($class, %args) = @_;

    my $self = {
        base_url => $args{base_url} || undef,
        img_dir => $args{img_dir} || 'images',
        output_dir => $args{output_dir} || './',
    };
    
    bless $self, $class;
    return $self;
}

=head2 save

=cut

sub save {
    my $self = shift;

    croak "No base URL" unless $self->base_url;
    croak "No HTML" unless $self->html;
    
    my $resolver = HTML::ResolveLink->new(
        base => $self->base_url
    );
    
    my $html = $resolver->resolve($self->html);

    my $tree = HTML::TreeBuilder->new_from_content( $html );
    my @img = $tree->find('img');

    $self->_build_directories();
    
    foreach my $image (@img) {
        my $remote_link = $image->attr('src');
        my $local_link = $self->_get_local_link($remote_link);
        getstore($remote_link, $local_link);
        $image->attr('src', $local_link);
    }

    $self->html($tree->as_HTML());

    if ($self->output_html()) {
        open my $fh, '>', $self->output_html;
        print $self->html();
        close $fh;
    }

    return $self->html();
    
}

sub _get_local_link {
    my ($self, $remote_link) = @_;
    
    my $filename = basename($remote_link);
    return File::Spec->catfile($self->output_dir, $self->img_dir, $filename);
}

sub _build_directories {
    my $self = shift;
    
    my $dir = File::Spec->catfile($self->output_dir, $self->img_dir);
    mkpath( $dir ) if not -e $dir;
}

=head1 AUTHOR

Emmanuel Di Pretoro, C<< <<edipretoro at gmail.com>> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-image-save at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-Image-Save>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::Image::Save


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-Image-Save>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTML-Image-Save>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTML-Image-Save>

=item * Search CPAN

L<http://search.cpan.org/dist/HTML-Image-Save/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Emmanuel Di Pretoro, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of HTML::Image::Save
