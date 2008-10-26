use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Image::Resize',
    license             => 'perl',
    dist_author         => 'Ryusuke Goto <goryugo33@gmail.com>',
    dist_version_from   => 'lib/Image/Resize.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Image-Resize-*' ],
);

$builder->create_build_script();
