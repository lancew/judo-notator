#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Output;



require 'notator.pl';



like( Local::Notator::printMenu(), qr/SPACE = MATTE/, 'Menu routine is OK' );
is( Local::Notator::ResetCounters(), 1, 'ResetCounters is OK');
#like( Local::Notator::PrintResults(), qr/Segments/, 'PrintResults is OK' );
like( Local::Notator::show_blue(), qr/Penalty: 0/, 'show_Blue is OK' );
like( Local::Notator::show_white(), qr/Penalty: 0/, 'show_White is OK' );
#is( Local::Notator::add_one_blue_Attack(), 1, 'add_one_blue_Attack is OK');