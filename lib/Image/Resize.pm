package Image::Resize;

use warnings;
use strict;
use Carp;

use version; $VERSION = qv('0.0.3');

# Other recommended modules (uncomment to use):
#  use IO::Prompt;
#  use Perl6::Export;
#  use Perl6::Slurp;
#  use Perl6::Say;


# Module implementation here
use Image::Magick;
use Image::ExifTool;

sub new {
  my $class = shift;
  my $filename = shift;
  bless{
	filename => $filename,
       },$class;
}

sub filename{
  my $self = shift;
  $self->{filename};
}

sub resize_img{
  my $self = shift;
  my ($output, $size) = @_;
  my $image = Image::Magick->new;

  $image->Read(filename=>$self->filename, compression=>'None');

  my ($width, $height) = $image->Get('base-columns', 'base-rows');

  #check size
  if($width>$height && $width>$size){
    my $ratio = $height/$width;
    $width = $size;
    $height = int($size * $ratio);
  }
  elsif($height>$width && $height>$size){
    my $ratio = $width/$height;
    $width = int($size * $ratio);
    $height = $size;
  }

  $image->Thumbnail(geometry=>"${width}x${height}");
  $image->Write(filename=>$output);
  chmod 0666, "$output";
}

sub crop_img{
  my $self = shift;
  my ($output, $size) = @_;
  my $image = Image::Magick->new;

  $image->Read(filename=>$self->filename, compression=>'None');

  my ($width, $height) = $image->Get('base-columns', 'base-rows');

  my $crop_size;
  my $x;
  my $y;
  #切り出しが大きすぎないか
  if($size>$width*0.7 || $size>$height*0.68){
    if($width>$height){
      $crop_size = $height;
      $x = int( ($width-$height)/2);
      $y = 0;
      $size = $height if ($size > $height);
    }
    else{
      $crop_size = $width;
      $x = 0;
      $y = int( ($height-$width)/2);
      $size = $width if ($height > $size);
    }
  }
  else{
    $crop_size = int($height*0.50);
    $x = int($height*0.20);
    $y = int($width*0.18);
  }

  $image->Crop(width=>$crop_size, height=>$crop_size, x=>$x, y=>$y);
  $image->Thumbnail(width=>$size, height=>$size);
  $image->Write(filename=>$output);
  chmod 0666, "$output";
  return $self;
}

sub rotate_img{
}

sub make_frame{
  my $self = shift;
  my ($output, $size) = @_;

  croak('Need output filename') if ! $output;
  $size == 50 || $size == 40 || $size == 30 or croak('only 50, 40, or 30 pixel');
  #元画像読み込む
  my $image = Image::Magick->new;
  $image->Read($self->filename);

  #square check
  my ($width, $height) = $image->Get('base-columns', 'base-rows');
  if($width != $height){
    $self->crop_img($output, $size);
    undef $image;
    $image = Image::Magick->new;
    $image->Read($output);
  }

  #frameを読み込む
  my $frame = Image::Magick->new;
  $frame->Read("frame_${size}_${size}.png");

  my $resize = $size - 8;
  $image->Thumbnail(width=>$resize, height=>$resize);
  $image->Border(width=>4, height=>4, fill=>'');

  $image->Composite(image=>$frame, compose=>'Over');
  $image->Write(filename=>$output);
  chmod 0666, $output;
}


1; # Magic true value required at end of module
__END__

=head1 NAME

Image::Resize - [One line description of module's purpose here]


=head1 VERSION

This document describes Image::Resize version 0.0.1


=head1 SYNOPSIS

    use Image::Resize;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Image::Resize requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-image-resize@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Ryusuke Goto  C<< <goryugo33@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Ryusuke Goto C<< <goryugo33@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
