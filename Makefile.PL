
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "use regexes with file utils like rm, cp, mv, ln",
  "AUTHOR" => "Graham Ollis <plicease\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "App-RegexFileUtils",
  "EXE_FILES" => [
    "bin/retouch",
    "bin/recp",
    "bin/reln",
    "bin/rerm",
    "bin/remv"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::RegexFileUtils",
  "PREREQ_PM" => {
    "File::ShareDir" => 0
  },
  "TEST_REQUIRES" => {},
  "VERSION" => "0.05_05",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };


my $sep = $^O eq 'MSWin32' ? ';' : ':';
my $ext = $^O =~ /^(MSWin32|cygwin)$/ ? '.exe' : '';
my %found;
foreach my $path (split $sep, $ENV{PATH})
{
  foreach my $program (qw( mv cp rm ))
  {
    my $exe = File::Spec->catfile($path, "$program$ext");
    if(-x $exe)
    {
      $found{$program} = 1;
    }
  }
}

foreach my $program (qw( mv cp rm ))
{
  warn "not found: $program" unless $found{$program};
}

# On Windows we use ppt implementation of some of these
# if they are not found i nthe path.
$found{cp} = $found{rm} = $found{mv} = $found{touch} = 1 if $^O eq 'MSWin32';

unless($found{mv} && $found{cp} && $found{rm})
{
  warn "this distribution requires GNU Coreutils (mv, cp, rm and ln), or equivalent";
  if($^O eq 'MSWin32')
  {
    warn "can be downloaded from the GnuWin32 project: http://gnuwin32.sourceforge.net/";
  }
  exit 2;
}



WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}


