package App::RegexFileUtils::MSWin32;

use strict;
use warnings;
use File::ShareDir qw( dist_dir );
use File::Basename qw( dirname );
use File::Spec;

# ABSTRACT: MSWin32 specific code for App::RegexFileUtils
our $VERSION = '0.05_02'; # VERSION

warn "only needed on MSWin32" unless $^O eq 'MSWin32';

my $path;

sub App::RegexFileUtils::share_dir
{
  unless(defined $path)
  {
    if(defined $App::RegexFileUtils::MSWin32::VERSION && $INC{'App/RegexFileUtils/MSWin32.pm'} =~ /blib/)
    {
      $path = File::Spec->catdir(
        dirname(__FILE__), 
        File::Spec->updir,
        File::Spec->updir,
        File::Spec->updir,
        File::Spec->updir,
        'share',
      );
      undef $path unless $path && -d "$path/ppt";
    }
    
    eval {
      if(defined $App::RegexFileUtils::MSWin32::VERSION)
      {
        $path = dist_dir('App-RegexFileUtils');
      }
      undef $path unless $path && -d "$path/ppt";
    };
    
    unless(defined $path)
    {
      $path = File::Spec->catdir(
        dirname(__FILE__),
        File::Spec->updir,
        File::Spec->updir,
        File::Spec->updir,
        'share',
      );
    }
    
    die 'can not find share directory' unless $path && -d "$path/ppt";    
  }
  
  $path;
}

1;

__END__

=pod

=head1 NAME

App::RegexFileUtils::MSWin32 - MSWin32 specific code for App::RegexFileUtils

=head1 VERSION

version 0.05_02

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
