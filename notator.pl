package Local::Notator;

use strict;
use warnings;

use English qw( -no_match_vars );
use version;
use Curses::UI;
use Readonly;

$OUTPUT_AUTOFLUSH = 1;

# $Id$
our $VERSION = qv('0.2.0');

# ---------------------------------------------------------
#
# This file created by Lance Wicks, 18 April 2009.
#                    Last Modified, 20 July 2009.
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

my $blue_attack    = 0;
my $blue_effattack = 0;
my $blue_koka      = 0;
my $blue_yuko      = 0;
my $blue_wazari    = 0;
my $blue_ippon     = 0;
my $blue_penalty   = 0;

my $white_attack    = 0;
my $white_effattack = 0;
my $white_koka      = 0;
my $white_yuko      = 0;
my $white_wazari    = 0;
my $white_ippon     = 0;
my $white_penalty   = 0;

my $cui;
my $win1;
my $win2;
my $win3;
my $info_blue;
my $info_white;
my $textviewer;

Readonly my $BASEYEAR => 1900;

# -----------------------------------------------
# MAIN LOOP
# -----------------------------------------------
if ( !caller ) {
    __PACKAGE__->run();

}

sub run {

    $cui = new Curses::UI( -color_support => 1 );

    $win1 = $cui->add(
        'win1', 'Window',
        -border => 1,
        -title  => 'BLUE',
        -bfg    => 'blue',
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
        -bfg    => 'white',
        -pad    => 2,
    );

    $info_blue  = $win1->add( 'blue',  'TextViewer', -text => show_blue(), );
    $info_white = $win3->add( 'white', 'TextViewer', -text => show_white(), );

    # -----------------------------------------------
    # Key Bindings
    # -----------------------------------------------

    $cui->set_binding( \&exit_dialog, "\cQ" );
    $cui->set_binding( \&exit_dialog, 'q' );
    $cui->set_binding( \&exit_dialog, 'Q' );

    $cui->set_binding( \&add_one_blue_attack,    'f' );
    $cui->set_binding( \&remove_one_blue_attack, 'F' );

    $cui->set_binding( \&add_one_blue_effattack,    'd' );
    $cui->set_binding( \&remove_one_blue_effattack, 'D' );

    $cui->set_binding( \&add_one_blue_koka,    'v' );
    $cui->set_binding( \&remove_one_blue_koka, 'V' );

    $cui->set_binding( \&add_one_blue_yuko,    'c' );
    $cui->set_binding( \&remove_one_blue_yuko, 'C' );

    $cui->set_binding( \&add_one_blue_wazari,    'x' );
    $cui->set_binding( \&remove_one_blue_wazari, 'X' );

    $cui->set_binding( \&add_one_blue_ippon,    'z' );
    $cui->set_binding( \&remove_one_blue_ippon, 'Z' );

    $cui->set_binding( \&add_one_blue_penalty,    't' );
    $cui->set_binding( \&remove_one_blue_penalty, 'T' );

    $cui->set_binding( \&add_one_white_attack,    'j' );
    $cui->set_binding( \&remove_one_white_attack, 'J' );

    $cui->set_binding( \&add_one_white_effattack,    'k' );
    $cui->set_binding( \&remove_one_white_effattack, 'K' );

    $cui->set_binding( \&add_one_white_koka,    'n' );
    $cui->set_binding( \&remove_one_white_koka, 'N' );

    $cui->set_binding( \&add_one_white_yuko,    'm' );
    $cui->set_binding( \&remove_one_white_yuko, 'M' );

    $cui->set_binding( \&add_one_white_wazari,    q{,} );
    $cui->set_binding( \&remove_one_white_wazari, q{<} );

    $cui->set_binding( \&add_one_white_ippon,    q{.} );
    $cui->set_binding( \&remove_one_white_ippon, q{>} );

    $cui->set_binding( \&add_one_white_penalty,    'u' );
    $cui->set_binding( \&remove_one_white_penalty, 'U' );

    # -----------------------------------------------

    $win2->focus();

    $textviewer = $win2->add( 'menu', 'TextViewer', -text => print_menu(), );

    $cui->mainloop();
    return;
}

# -----------------------------------------------
# Sub Routines
# -----------------------------------------------

sub print_menu {
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

sub reset_counters {
    $segments = 1;

    $blue_attack    = 0;
    $blue_effattack = 0;
    $blue_koka      = 0;
    $blue_yuko      = 0;
    $blue_wazari    = 0;
    $blue_ippon     = 0;
    $blue_penalty   = 0;

    $white_attack    = 0;
    $white_effattack = 0;
    $white_koka      = 0;
    $white_yuko      = 0;
    $white_wazari    = 0;
    $white_ippon     = 0;
    $white_penalty   = 0;

    $events = 0;
    return $segments;
}

sub print_results {
    my $results;
    $results .= "\n\n";

    my @months    = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    my @week_days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
    my (
        $seconds,      $minute,      $hour,
        $day_of_month, $month,       $year_offset,
        $day_of_week,  $day_of_year, $day_light_savings
    ) = localtime;
    my $year = $BASEYEAR + $year_offset;
    my $the_time =
"$hour:$minute:$seconds, $week_days[$day_of_week] $months[$month] $day_of_month, $year";
    $results .= "Notation Time and Date\n$the_time\n\n";

    $results .= "Segments: $segments\n";
    $results .= "\nBLUE\n";
    $results .= "Ineffective Attacks: $blue_attack\n";
    $results .= "Effective Attacks: $blue_effattack\n";
    $results .= "Koka: $blue_koka\n";
    $results .= "Yuka: $blue_yuko\n";
    $results .= "Wazari: $blue_wazari\n";
    $results .= "Ippon: $blue_ippon\n";
    $results .= "Penalty: $blue_penalty\n";
    $results .= "\nWHITE\n";
    $results .= "Ineffective Attacks: $white_attack\n";
    $results .= "Effective Attacks: $white_effattack\n";
    $results .= "Koka: $white_koka\n";
    $results .= "Yuka: $white_yuko\n";
    $results .= "Wazari: $white_wazari\n";
    $results .= "Ippon: $white_ippon\n";
    $results .= "Penalty: $white_penalty\n\n\n";
    return ($results);
}

sub dumb_test {
    my $test = 'yes';
    return ($test);

}

sub show_blue {
    my $temp = " \n";
    $temp .= "Ineffective Attacks: $blue_attack\n";
    $temp .= "Effective Attacks: $blue_effattack\n";
    $temp .= "Koka: $blue_koka\n";
    $temp .= "Yuka: $blue_yuko\n";
    $temp .= "Wazari: $blue_wazari\n";
    $temp .= "Ippon: $blue_ippon\n";
    $temp .= "Penalty: $blue_penalty\n";
    return $temp;

}

sub show_white {
    my $temp = " \n";
    $temp .= "Ineffective Attacks: $white_attack\n";
    $temp .= "Effective Attacks: $white_effattack\n";
    $temp .= "Koka: $white_koka\n";
    $temp .= "Yuka: $white_yuko\n";
    $temp .= "Wazari: $white_wazari\n";
    $temp .= "Ippon: $white_ippon\n";
    $temp .= "Penalty: $white_penalty\n\n\n";
    return $temp;

}

sub add_one_blue_attack {
    $blue_attack++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_attack);

}

sub remove_one_blue_attack {
    $blue_attack--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_attack);

}

sub add_one_blue_effattack {
    $blue_effattack++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_effattack);

}

sub remove_one_blue_effattack {
    $blue_effattack--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_effattack);

}

sub add_one_blue_koka {
    $blue_koka++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_koka);

}

sub remove_one_blue_koka {
    $blue_koka--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_koka);

}

sub add_one_blue_yuko {
    $blue_yuko++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_yuko);

}

sub remove_one_blue_yuko {
    $blue_yuko--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_yuko);

}

sub add_one_blue_wazari {
    $blue_wazari++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_wazari);

}

sub remove_one_blue_wazari {
    $blue_wazari--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_wazari);

}

sub add_one_blue_ippon {
    $blue_ippon++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_ippon);

}

sub remove_one_blue_ippon {
    $blue_ippon--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_ippon);

}

sub add_one_blue_penalty {
    $blue_penalty++;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_penalty);

}

sub remove_one_blue_penalty {
    $blue_penalty--;
    $info_blue->text( show_blue() );
    $win1->focus();
    return ($blue_penalty);

}

# ------------------

sub add_one_white_attack {
    $white_attack++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_attack);

}

sub remove_one_white_attack {
    $white_attack--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_attack);

}

sub add_one_white_effattack {
    $white_effattack++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_effattack);

}

sub remove_one_white_effattack {
    $white_effattack--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_effattack);

}

sub add_one_white_koka {
    $white_koka++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_koka);

}

sub remove_one_white_koka {
    $white_koka--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_koka);

}

sub add_one_white_yuko {
    $white_yuko++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_yuko);

}

sub remove_one_white_yuko {
    $white_yuko--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_yuko);

}

sub add_one_white_wazari {
    $white_wazari++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_wazari);

}

sub remove_one_white_wazari {
    $white_wazari--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_wazari);

}

sub add_one_white_ippon {
    $white_ippon++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_ippon);

}

sub remove_one_white_ippon {
    $white_ippon--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_ippon);

}

sub add_one_white_penalty {
    $white_penalty++;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_penalty);

}

sub remove_one_white_penalty {
    $white_penalty--;
    $info_white->text( show_white() );
    $win3->focus();
    return ($white_penalty);

}

# ------------------

sub exit_dialog {
    my $return = $cui->dialog(
        -message => 'Do you really want to quit?',
        -title   => 'Are you sure???',
        -buttons => [ 'yes', 'no' ],

    );

    exit if $return;
    return;
}

1;
