use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HTML::Image::Save',
    license             => 'perl',
    dist_author         => 'Emmanuel Di Pretoro <<edipretoro@gmail.com>>',
    dist_version_from   => 'lib/HTML/Image/Save.pm',
    build_requires => {
        'Test::More' => 0,
        'Class::Accessor::Fast' => 0,
        'Class::ErrorHandler' => 0,
        'HTML::TreeBuilder' => 0,
        'LWP::Simple' => 0,
        'HTML::ResolveLink' => 0,
    },
    add_to_cleanup      => [ 'HTML-Image-Save-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
