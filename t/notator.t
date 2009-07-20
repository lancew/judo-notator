#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Output;



require 'notator.pl';



like( Local::Notator::print_menu(), qr/SPACE = MATTE/, 'Menu routine is OK' );
is( Local::Notator::reset_counters(), 1, 'reset_counters is OK');
like( Local::Notator::print_results(), qr/Segments/, 'print_results is OK' );
like( Local::Notator::show_blue(), qr/Penalty: 0/, 'show_blue is OK' );
like( Local::Notator::show_white(), qr/Penalty: 0/, 'show_white is OK' );
#is( Local::Notator::add_one_blue_attack(), 1, 'add_one_blue_Attack is OK');