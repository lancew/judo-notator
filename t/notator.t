#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Output;



require 'notator.pl';



like( Local::notator::printMenu(), qr/SPACE = MATTE/, 'Menu routine is OK' );
is( Local::notator::ResetCounters(), 1, 'ResetCounters is OK');
#like( Local::notator::PrintResults(), qr/Segments/, 'PrintResults is OK' );
like( Local::notator::show_blue(), qr/Penalty: 0/, 'show_Blue is OK' );
like( Local::notator::show_white(), qr/Penalty: 0/, 'show_White is OK' );
#is( Local::notator::add_one_blue_Attack(), 1, 'add_one_blue_Attack is OK');