
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "use regexes with file utils like rm, cp, mv, ln",
  "AUTHOR" => "Graham Ollis <plicease\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-RegexFileUtils",
  "EXE_FILES" => [
    "bin/recp",
    "bin/remv",
    "bin/rerm",
    "bin/reln",
    "bin/retouch"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::RegexFileUtils",
  "PREREQ_PM" => {
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "File::Temp" => 0,
    "Test::More" => 0
  },
  "VERSION" => "0.04_01",
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



