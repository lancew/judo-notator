    #!/usr/bin/perl -w

    use strict;
    use warnings;
    use Curses::UI;
    my $cui = new Curses::UI( -color_support => 1 );
    
    my $screen_width = $cui->width();
    my $colum_width = ($screen_width-12)/3;
    
    
    
        
        
    sub exit_dialog()
        {
                my $return = $cui->dialog(
                        -message   => "Do you really want to quit?",
                        -title     => "Are you sure???", 
                        -buttons   => ['yes', 'no'],

                );

        exit(0) if $return;
        }
        
        
        
     my $win1 = $cui->add(
        'win1', 'Window',
        -border => 1,
        -title => 'BLUE',
        -bfg=>"blue",
        -width => 35,
        -pad => 2,
    );     
    
    my $win2 = $cui->add(
        'win2', 'Window',
        -border => 1,
        -x => 35,
        -width => 86,
        -title => 'JUDO-NOTATOR',
        -pad => 2,
    );                      
     
    my $win3 = $cui->add(
        'win3', 'Window',
        -border => 1,
        -x => 120,
        -width => 35,
        -title => 'WHITE',
        -bfg=>"white",
        -pad => 2,
    );                
                     
   
   

                                            
    
    $cui->set_binding( \&exit_dialog , "\cQ");  
    $cui->set_binding( \&exit_dialog , "q"); 
    $cui->set_binding( \&exit_dialog , "Q"); 
    
    $win2->focus();
   
    
    sub Menu {
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
    
    return($welcome);
}

  my $textviewer = $win2->add( 
        'menu', 'TextViewer',
    -text => Menu(),
    );  
    
    
    
    
    
    
        
    
     
    $cui->mainloop();    
    
    
       
    