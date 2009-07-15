package Local::notator;

use strict;
use warnings;

use English qw( -no_match_vars );
use version;
use Curses::UI;

# __PACKAGE__->main() unless caller; # executes at run-time, unless used as module

$OUTPUT_AUTOFLUSH = 1;

# $Id$
our $VERSION = qv('0.2.0');

# ---------------------------------------------------------
#
# This file created by Lance Wicks, 18 April 2009.
#                    Last Modified, 15 July 2009.
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

# -----------------------------------------------
# Global Variables
# -----------------------------------------------

my $run_flag = 1;

my $segments = 0;
my $active   = 0;
my $events   = 0;

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

my $cui;
my $win1;
my $win2;
my $win3;
my $info_blue;
my $info_white;
my $textviewer;

# -----------------------------------------------
# MAIN LOOP
# -----------------------------------------------
__PACKAGE__->run() unless caller();

sub run {

    $cui = new Curses::UI( -color_support => 1 );
    $win1 = $cui->add(
        'win1', 'Window',
        -border => 1,
        -title  => 'BLUE',
        -bfg    => "blue",
        -width  => 35,
        -pad    => 2,
    );

    $win2 = $cui->add(
        'win2', 'Window',
        -border => 1,
        -x      => 35,
        -width  => 86,
        -title  => 'JUDO-NOTATOR',
        -pad    => 2,
    );

    $win3 = $cui->add(
        'win3', 'Window',
        -border => 1,
        -x      => 120,
        -width  => 35,
        -title  => 'WHITE',
        -bfg    => "white",
        -pad    => 2,
    );

    $info_blue  = $win1->add( 'blue',  'TextViewer', -text => show_blue(), );
    $info_white = $win3->add( 'white', 'TextViewer', -text => show_white(), );

    # -----------------------------------------------
    # Key Bindings
    # -----------------------------------------------

    $cui->set_binding( \&exit_dialog, "\cQ" );
    $cui->set_binding( \&exit_dialog, "q" );
    $cui->set_binding( \&exit_dialog, "Q" );

    $cui->set_binding( \&add_one_blue_Attack,    "f" );
    $cui->set_binding( \&remove_one_blue_Attack, "F" );

    $cui->set_binding( \&add_one_blue_EffAttack,    "d" );
    $cui->set_binding( \&remove_one_blue_EffAttack, "D" );

    $cui->set_binding( \&add_one_blue_Koka,    "v" );
    $cui->set_binding( \&remove_one_blue_Koka, "V" );

    # -----------------------------------------------

    $win2->focus();

    $textviewer = $win2->add( 'menu', 'TextViewer', -text => printMenu(), );

    $cui->mainloop();
    return;
}

# -----------------------------------------------
# Sub Routines
# -----------------------------------------------

sub printMenu {
    my $welcome;

    $welcome .=
"-------------------------------------------------------------------------------\n";
    $welcome .=
"|                     BLUE           |                   WHITE                |\n";
    $welcome .=
"|  F = Attack                        |  J = Attack                            |\n";
    $welcome .=
"|  D = Effective Attack              |  K = Effective Attack                  |\n";
    $welcome .=
"|                                    |                                        |\n";
    $welcome .=
"|  V = Koka                          |  N = Koka                              |\n";
    $welcome .=
"|  C = Yoka                          |  M = Yoka                              |\n";
    $welcome .=
"|  X = Wazari                        |  < = Wazari                            |\n";
    $welcome .=
"|  Z = Ippon                         |  > = Ippon                             |\n";
    $welcome .=
"|  T = Receive Penalty               |   U = Receive Penalty                  |\n";
    $welcome .=
"|                                    |                                        |\n";
    $welcome .=
"|                              SPACE = MATTE                                  |\n";
    $welcome .=
"|                                    |                                        |\n";
    $welcome .=
"|                              Q     = SOREMADE                               |\n";
    $welcome .=
"|                                    |                                        |\n";
    $welcome .=
"|             <SHIFT>  plus any of these keys will delete that score          |\n";

    $welcome .=
"-------------------------------------------------------------------------------\n";

    return ($welcome);
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
    return $segments;
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

sub show_blue {
    my $temp = " \n";
    $temp .= "Ineffective Attacks: $blue_Attack\n";
    $temp .= "Effective Attacks: $blue_EffAttack\n";
    $temp .= "Koka: $blue_Koka\n";
    $temp .= "Yuka: $blue_Yuko\n";
    $temp .= "Wazari: $blue_Wazari\n";
    $temp .= "Ippon: $blue_Ippon\n";
    $temp .= "Penalty: $blue_Penalty\n";
    return $temp;

}

sub show_white {
    my $temp = " \n";
    $temp .= "Ineffective Attacks: $white_Attack\n";
    $temp .= "Effective Attacks: $white_EffAttack\n";
    $temp .= "Koka: $white_Koka\n";
    $temp .= "Yuka: $white_Yuko\n";
    $temp .= "Wazari: $white_Wazari\n";
    $temp .= "Ippon: $white_Ippon\n";
    $temp .= "Penalty: $white_Penalty\n\n\n";
    return $temp;

}

sub add_one_blue_Attack {
    $blue_Attack++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_Attack);

}

sub remove_one_blue_Attack {
    $blue_Attack--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_Attack);

}

sub add_one_blue_EffAttack {
    $blue_EffAttack++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_EffAttack);

}

sub remove_one_blue_EffAttack {
    $blue_EffAttack--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_EffAttack);

}

sub add_one_blue_Koka {
    $blue_Koka++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_Koka);

}

sub remove_one_blue_Koka {
    $blue_Koka--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_Koka);

}

sub exit_dialog {
    my $return = $cui->dialog(
        -message => "Do you really want to quit?",
        -title   => "Are you sure???",
        -buttons => [ 'yes', 'no' ],

    );

    exit(0) if $return;
    return;
}

1;
