

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Judo::Notator',
    VERSION_FROM => 'lib/Judo/Notator.pm', # finds \$VERSION
    AUTHOR       => 'Lance Wicks (lw@judocoach.com)',
    ABSTRACT     => 'Module designed for building Judo Notator software.',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                    },
);
