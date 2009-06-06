#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw(no_plan);
use Test::Output;



require 'notator.pl';


stdout_is(\&dumb_test,"yes",'Dumb test');
stdout_is(\&DisplayWelcome,"

Judo Notator (v0.0.1)

-------------------------------------------------------------------------------
|                     BLUE           |                   WHITE                |
|  F = Attack                        |  J = Attack                            |
|  D = Effective Attack              |  J = Effective Attack                  |
|                                    |                                        |
|  V = Koka                          |  N = Koka                              |
|  C = Yoka                          |  M = Yoka                              |
|  X = Wazari                        |  < = Wazari                            |
|  Z = Ippon                         |  > = Ippon                             |
|  T = Receive Penalty               |   U = Receive Penalty                  |
|                                    |                                        |
|                              SPACE = MATTE                                  |
|                                    |                                        |
|                              Q     = SOREMADE                               |
|                                    |                                        |
|             <SHIFT>  plus any of these keys will delete that score          |
-------------------------------------------------------------------------------
  Events:  ",'Display Welcome is OK');




#sub PrintResults;
