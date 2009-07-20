#!/usr/bin/perl
system('clear');
print("Running Smoketests...\n");
push @INC, "./";
use strict;
use warnings;
use Perl::Critic;
use Perl::Tidy;
use File::Find::Rule;
use Test::Harness qw(&runtests);

my $file   = 'Notator.pl';
my $backup = 'Notator.old';

rename( $file, 'Notator.old' );
perltidy( source => $backup, destination => $file );

for ( my $count = 1 ; $count < 6 ; $count++ ) {
    open( MYFILE, ">critic-$count.txt" );
    my $critic = Perl::Critic->new( -severity => $count );
    my @violations = $critic->critique($file);

    #print $violations;
    print MYFILE @violations;
    close(MYFILE);
}

my $rule = File::Find::Rule->new;
$rule->or( $rule->new->directory->name('CVS')->prune->discard,
    $rule->new->file->name('*.t') );
my @start = @ARGV ? @ARGV : '.';
my @files;
for (@start) {
    push( @files, (-d) ? $rule->in($_) : $_ );
}

runtests(@files);
