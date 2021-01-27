package Local::Notator;

use strict;
use warnings;

use English qw( -no_match_vars );
use version;
use Curses::UI;
use Readonly;
use IO::File;

local $OUTPUT_AUTOFLUSH = 1;

# $Id$
our $VERSION = qv('0.2.0');

# ---------------------------------------------------------
#
# This file created by Lance Wicks, 18 April 2009.
#                    Last Modified, 21 July 2009.
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

my $segments = 0;
my $active   = 0;
my $events   = 0;

my %counters = (
    blue => {
        attack    => 0,
        effattack => 0,
        koka      => 0,
        yuko      => 0,
        wazari    => 0,
        ippon     => 0,
        penalty   => 0
    },
    white => {
        attack    => 0,
        effattack => 0,
        koka      => 0,
        yuko      => 0,
        wazari    => 0,
        ippon     => 0,
        penalty   => 0
    },
);

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

    $cui = Curses::UI->new( -color_support => 1 );

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

    $cui->set_binding( \&save_results,                             'w' );
    $cui->set_binding( sub { reset_counters(); update_screen(); }, 'a' );

    my @keys = (
        [ 'blue', 'attack',    'inc', 'f' ],
        [ 'blue', 'attack',    'dec', 'F' ],
        [ 'blue', 'effattack', 'inc', 'd' ],
        [ 'blue', 'effattack', 'dec', 'D' ],
        [ 'blue', 'koka',      'inc', 'v' ],
        [ 'blue', 'koka',      'dec', 'V' ],
        [ 'blue', 'yuko',      'inc', 'c' ],
        [ 'blue', 'yuko',      'dec', 'C' ],
        [ 'blue', 'wazari',    'inc', 'x' ],
        [ 'blue', 'wazari',    'dec', 'X' ],
        [ 'blue', 'ippon',     'inc', 'z' ],
        [ 'blue', 'ippon',     'dec', 'Z' ],
        [ 'blue', 'penalty',   'inc', 't' ],
        [ 'blue', 'penalty',   'dec', 'T' ],

        [ 'white', 'attack',    'inc', 'j' ],
        [ 'white', 'attack',    'dec', 'J' ],
        [ 'white', 'effattack', 'inc', 'k' ],
        [ 'white', 'effattack', 'dec', 'K' ],
        [ 'white', 'koka',      'inc', 'n' ],
        [ 'white', 'koka',      'dec', 'N' ],
        [ 'white', 'yuko',      'inc', 'm' ],
        [ 'white', 'yuko',      'dec', 'M' ],
        [ 'white', 'wazari',    'inc', ',' ],
        [ 'white', 'wazari',    'dec', '<' ],
        [ 'white', 'ippon',     'inc', '.' ],
        [ 'white', 'ippon',     'dec', '>' ],
        [ 'white', 'penalty',   'inc', 'u' ],
        [ 'white', 'penalty',   'dec', 'U' ],

    );

    for my $k (@keys) {
        $cui->set_binding(
            sub {
                update(
                    colour    => $k->[0],
                    statistic => $k->[1],
                    mode      => $k->[2],
                    ),
                    update_screen();
            },
            $k->[3]
        );
    }

    $cui->set_binding( sub { add_one_matte(); update_screen(); }, '343' );

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

    $welcome
        .= "-------------------------------------------------------------------------------\n";
    $welcome
        .= "|                     BLUE           |                   WHITE                |\n";
    $welcome
        .= "|  F = Attack                        |  J = Attack                            |\n";
    $welcome
        .= "|  D = Effective Attack              |  K = Effective Attack                  |\n";
    $welcome
        .= "|  V = Koka                          |  N = Koka                              |\n";
    $welcome
        .= "|  C = Yoka                          |  M = Yoka                              |\n";
    $welcome
        .= "|  X = Wazari                        |  < = Wazari                            |\n";
    $welcome
        .= "|  Z = Ippon                         |  > = Ippon                             |\n";
    $welcome
        .= "|  T = Receive Penalty               |   U = Receive Penalty                  |\n";
    $welcome
        .= "|                                    |                                        |\n";
    $welcome
        .= "|                              ENTER = MATTE                                  |\n";
    $welcome
        .= "|                          w = save data to file                              |\n";
    $welcome
        .= "|                           a = reset counters                                |\n";
    $welcome
        .= "|                                  Q = Quit                                   |\n";
    $welcome
        .= "|                                    |                                        |\n";
    $welcome
        .= "|             <SHIFT>  plus any of these keys will delete that score          |\n";

    $welcome
        .= "-------------------------------------------------------------------------------\n";
    $welcome .= "Segments: $segments \n";

    return ($welcome);
}

sub reset_counters {
    $segments = 1;

    %counters = (
        blue => {
            attack    => 0,
            effattack => 0,
            koka      => 0,
            yuko      => 0,
            wazari    => 0,
            ippon     => 0,
            shido     => 0
        },
        white => {
            attack    => 0,
            effattack => 0,
            koka      => 0,
            yuko      => 0,
            wazari    => 0,
            ippon     => 0,
            shido     => 0
        },
    );

    $events = 0;
    return $segments;
}

sub print_results {
    my $results;
    $results .= "\n\n";

    my @months    = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    my @week_days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
    my ($seconds,      $minute,      $hour,
        $day_of_month, $month,       $year_offset,
        $day_of_week,  $day_of_year, $day_light_savings
    ) = localtime;
    my $year = $BASEYEAR + $year_offset;
    my $the_time
        = "$hour:$minute:$seconds, $week_days[$day_of_week] $months[$month] $day_of_month, $year";
    $results .= "Notation Time and Date\n$the_time\n\n";

    $results .= "Segments: $segments\n";
    $results .= "\nBLUE\n";
    $results .= "Ineffective Attacks: $counters{blue}{attack}\n";
    $results .= "Effective Attacks: $counters{blue}{effattack}\n";
    $results .= "Koka: $counters{blue}{koka}\n";
    $results .= "Yuko: $counters{blue}{yuko}\n";
    $results .= "Wazari: $counters{blue}{wazari}\n";
    $results .= "Ippon: $counters{blue}{ippon}\n";
    $results .= "Penalty: $counters{blue}{penalty}\n";
    $results .= "\nWHITE\n";
    $results .= "Ineffective Attacks: $counters{white}{attack}\n";
    $results .= "Effective Attacks: $counters{white}{effattack}\n";
    $results .= "Koka: $counters{white}{koka}\n";
    $results .= "Yuko: $counters{white}{yuko}\n";
    $results .= "Wazari: $counters{white}{wazari}\n";
    $results .= "Ippon: $counters{white}{ippon}\n";
    $results .= "Penalty: $counters{white}{penalty}\n\n\n";
    return ($results);
}

sub show_blue {
    my $temp = " \n";
    $temp .= "Ineffective Attacks: $counters{blue}{attack}\n";
    $temp .= "Effective Attacks: $counters{blue}{effattack}\n";
    $temp .= "Koka: $counters{blue}{koka}\n";
    $temp .= "Yuko: $counters{blue}{yuko}\n";
    $temp .= "Wazari: $counters{blue}{wazari}\n";
    $temp .= "Ippon: $counters{blue}{ippon}\n";
    $temp .= "Penalty: $counters{blue}{penalty}\n";
    return $temp;

}

sub show_white {
    my $temp = " \n";
    $temp .= "Ineffective Attacks: $counters{white}{attack}\n";
    $temp .= "Effective Attacks: $counters{white}{effattack}\n";
    $temp .= "Koka: $counters{white}{koka}\n";
    $temp .= "Yuko: $counters{white}{yuko}\n";
    $temp .= "Wazari: $counters{white}{wazari}\n";
    $temp .= "Ippon: $counters{white}{ippon}\n";
    $temp .= "Penalty: $counters{white}{penalty}\n\n\n";
    return $temp;

}

sub results {
    my $results;

    $results = print_results();
    return $results;
}

sub save_results {
    my $filename = time() . '.txt';
    my $fh       = IO::File->new("> $filename");
    if ( defined $fh ) {
        print {$fh} results() or croak('Unable to save');
        $fh->close;
    }

    my $dialog = $cui->add( 'mydialog', 'Dialog::Basic',
        -message => "Data saved to $filename" );
    $dialog->focus;
    $cui->delete('mydialog');

    return 1;

}

sub update {
    my (%args) = @_;

    if ( $args{'mode'} eq 'inc' ) {
        $counters{ $args{'colour'} }{ $args{'statistic'} }++;
    }
    else {
        $counters{ $args{'colour'} }{ $args{'statistic'} }--;
    }
}

# ------------------

sub add_one_matte {
    $segments++;
    return ($segments);
}

sub update_screen {
    $info_blue->text( show_blue() );
    $info_white->text( show_white() );
    $textviewer->text( print_menu() );
    $win1->focus();
    $win3->focus();
    $win2->focus();
    return 1;
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
