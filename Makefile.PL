use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Image::Resize',
    AUTHOR              => 'Ryusuke Goto <goryugo33@gmail.com>',
    VERSION_FROM        => 'lib/Image/Resize.pm',
    ABSTRACT_FROM       => 'lib/Image/Resize.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Image-Resize-*' },
);
