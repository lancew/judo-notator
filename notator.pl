use strict;
use warnings;

use English qw( -no_match_vars );
use version;
use Term::ReadKey;
use Switch;

local $OUTPUT_AUTOFLUSH = 1;

# $Id$
our $VERSION = qv('0.1.1');

# ---------------------------------------------------------
#
# This file created by Lance Wicks, 18 April 2009.
#                    Last Modified, 13 June 2009.
#
#
#    notator.pl - Notation software for BSc. project.
#    Copyright (C) 2009  Lance Wicks
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.fsf.org/licensing/licenses/agpl.html>.
#
# -----------------------------------------------------------

# ---------------------------------------------
# Sub routine stubs
# ---------------------------------------------

sub do_main;
sub DisplayWelcome;
sub ResetCounters;
sub PrintResults;

# -----------------------------------------------
# Global Variables
# -----------------------------------------------
my $key;

my $segments = 1;

my $events = 0;

my $blue_Attack    = 0;
my $blue_EffAttack = 0;
my $blue_Koka      = 0;
my $blue_Yuko      = 0;
my $blue_Wazari    = 0;
my $blue_Ippon     = 0;
my $blue_Penalty   = 0;

my $white_Attack    = 0;
my $white_EffAttack = 0;
my $white_Koka      = 0;
my $white_Yuko      = 0;
my $white_Wazari    = 0;
my $white_Ippon     = 0;
my $white_Penalty   = 0;

# -----------------------------------------------
# MAIN LOOP
# -----------------------------------------------

do_main unless (caller);

sub do_main {
    ReadMode 'raw';
    DisplayWelcome();

    my $run_flag = 1;
    while ($run_flag) {

        while ( not defined( $key = ReadKey(-1) ) ) {

            # No key yet
        }

        switch ($key) {
            case "q" { $run_flag = 0; }
            case "Q" { $run_flag = 0; }
            case "f" { $blue_Attack++;     $events++; }
            case "F" { $blue_Attack--;     $events--; }
            case "d" { $blue_EffAttack++;  $events++; }
            case "D" { $blue_EffAttack--;  $events--; }
            case "v" { $blue_Koka++;       $events++; }
            case "V" { $blue_Koka--;       $events--; }
            case "c" { $blue_Yuko++;       $events++; }
            case "C" { $blue_Yuko--;       $events--; }
            case "x" { $blue_Wazari++;     $events++; }
            case "X" { $blue_Wazari--;     $events--; }
            case "z" { $blue_Ippon++;      $events++; }
            case "Z" { $blue_Ippon--;      $events--; }
            case "t" { $blue_Penalty++;    $events++; }
            case "T" { $blue_Penalty--;    $events--; }
            case "j" { $white_Attack++;    $events++; }
            case "J" { $white_Attack--;    $events--; }
            case "k" { $white_EffAttack++; $events++; }
            case "K" { $white_EffAttack--; $events--; }
            case "n" { $white_Koka++;      $events++; }
            case "N" { $white_Koka--;      $events--; }
            case "m" { $white_Yuko++;      $events++; }
            case "M" { $white_Yuko--;      $events--; }
            case "," { $white_Wazari++;    $events++; }
            case "<" { $white_Wazari--;    $events--; }
            case "." { $white_Ippon++;     $events++; }
            case ">" { $white_Ippon--;     $events--; }
            case "u" { $white_Penalty++;   $events++; }
            case "U" { $white_Penalty--;   $events--; }
            case " " { $segments++;        $events++; }

        }

        if ( $events >= 10 ) {
            print "\b\b";
        }
        else {
            print "\b";
        }
        print "$events";

    }
    ReadMode 'restore';

    PrintResults();
    return;
}

# -----------------------------------------------
# Sub Routines
# -----------------------------------------------

sub DisplayWelcome {
    print "\n\nJudo Notator ($VERSION)\n\n";
    print
"-------------------------------------------------------------------------------\n";
    print
"|                     BLUE           |                   WHITE                |\n";
    print
"|  F = Attack                        |  J = Attack                            |\n";
    print
"|  D = Effective Attack              |  J = Effective Attack                  |\n";
    print
"|                                    |                                        |\n";
    print
"|  V = Koka                          |  N = Koka                              |\n";
    print
"|  C = Yoka                          |  M = Yoka                              |\n";
    print
"|  X = Wazari                        |  < = Wazari                            |\n";
    print
"|  Z = Ippon                         |  > = Ippon                             |\n";
    print
"|  T = Receive Penalty               |   U = Receive Penalty                  |\n";
    print
"|                                    |                                        |\n";
    print
"|                              SPACE = MATTE                                  |\n";
    print
"|                                    |                                        |\n";
    print
"|                              Q     = SOREMADE                               |\n";
    print
"|                                    |                                        |\n";
    print
"|             <SHIFT>  plus any of these keys will delete that score          |\n";

    print
"-------------------------------------------------------------------------------\n";
    print "  Events:  ";
    return;
}

sub ResetCounters {
    $segments = 1;

    $blue_Attack    = 0;
    $blue_EffAttack = 0;
    $blue_Koka      = 0;
    $blue_Yuko      = 0;
    $blue_Wazari    = 0;
    $blue_Ippon     = 0;
    $blue_Penalty   = 0;

    $white_Attack    = 0;
    $white_EffAttack = 0;
    $white_Koka      = 0;
    $white_Yuko      = 0;
    $white_Wazari    = 0;
    $white_Ippon     = 0;
    $white_Penalty   = 0;

    $events = 0;
    return 1;
}

sub PrintResults {
    print "\n\n";

    my @months   = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
    my (
        $seconds,    $minute,    $hour,
        $dayOfMonth, $month,     $yearOffset,
        $dayOfWeek,  $dayOfYear, $daylightSavings
    ) = localtime();
    my $year = 1900 + $yearOffset;
    my $theTime =
"$hour:$minute:$seconds, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
    print "Notation Time and Date\n$theTime\n\n";

    print "Segments: $segments\n";
    print "\nBLUE\n";
    print "Ineffective Attacks: $blue_Attack\n";
    print "Effective Attacks: $blue_EffAttack\n";
    print "Koka: $blue_Koka\n";
    print "Yuka: $blue_Yuko\n";
    print "Wazari: $blue_Wazari\n";
    print "Ippon: $blue_Ippon\n";
    print "Penalty: $blue_Penalty\n";
    print "\nWHITE\n";
    print "Ineffective Attacks: $white_Attack\n";
    print "Effective Attacks: $white_EffAttack\n";
    print "Koka: $white_Koka\n";
    print "Yuka: $white_Yuko\n";
    print "Wazari: $white_Wazari\n";
    print "Ippon: $white_Ippon\n";
    print "Penalty: $white_Penalty\n\n\n";
    return;
}

sub dumb_test {
    print "yes";
    return 1;

}

1;
