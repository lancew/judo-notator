#!/usr/bin/perl
use strict;
use warnings;
use File::Find::Rule;
use Test::More qw(no_plan);

sub check {
    my $filename = shift;
    local $/ = undef;
    open( my $fh, $filename )
        or return fail("Couldn't open $filename: $!");
    my $text = <$fh>;
    close $fh;
    like( $text, qr/use strict;/, "$filename uses strict" );
}    # check()

my $rule = File::Find::Rule->new;
$rule->file;
$rule->name( '*.pm', '*.pl' );
$rule->maxdepth(1);

my @files = $rule->in('./');
for (@files) {
    check($_);
}
