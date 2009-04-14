use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'HTML::Image::Save',
    AUTHOR              => 'Emmanuel Di Pretoro <<edipretoro@gmail.com>>',
    VERSION_FROM        => 'lib/HTML/Image/Save.pm',
    ABSTRACT_FROM       => 'lib/HTML/Image/Save.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Class::Accessor::Fast' => 0,
        'Class::ErrorHandler' => 0,
        'HTML::TreeBuilder' => 0,
        'LWP::Simple' => 0,
        'HTML::ResolveLink' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HTML-Image-Save-*' },
);
