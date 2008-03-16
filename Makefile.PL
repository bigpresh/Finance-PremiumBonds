use 5.008007;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Finance::PremiumBonds',
    VERSION_FROM      => 'lib/Finance/PremiumBonds.pm',
    PREREQ_PM         => { WWW::Mechanize => 0 },
    NO_META           => 1,
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Finance/PremiumBonds.pm',
       AUTHOR         => 'David Precious <davidp@preshweb.co.uk>') : ()),
);

# $Id$
