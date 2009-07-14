#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Output;



require 'notator.pl';


stdout_is(\&dumb_test,"yes",'Dumb test');
like( printMenu(), qr/SPACE = MATTE/, 'Menu routine' );
unlike( printMenu(), qr/chicken/, 'QUick check to test printMenu is not working' );