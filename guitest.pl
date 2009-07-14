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
        
        
    my @menu = (
          { -label => 'File', 
            -submenu => [
           { -label => 'Exit      ^Q', -value => \&exit_dialog  }
                        ]
           },
        );    
        
        
    my $menu = $cui->add(
                'menu','Menubar', 
                -menu => \@menu,
                -fg  => "blue",
        );
     
    
     
     my $win1 = $cui->add(
        'win1', 'Window',
        -border => 1,
        -title => 'BLUE',
        -width => $colum_width,
        -pad => 2,
    );     
    
    my $win2 = $cui->add(
        'win2', 'Window',
        -border => 1,
        -x => $colum_width,
        -width => $colum_width,
        -title => 'JUDO-NOTATOR',
        -pad => 2,
    );                      
     
    my $win3 = $cui->add(
        'win3', 'Window',
        -border => 1,
        -x => $colum_width*2,
        -width => $colum_width,
        -title => 'WHITE',
        -pad => 2,
    );                
                     
   
   my $textviewer = $win1->add( 
        'mytextviewer', 'TextViewer',
    -text => "Hello, world!\n"
               . "Goodbye, world!"
    );

                                            
    $cui->set_binding(sub {$menu->focus()}, "\cX");
    $cui->set_binding( \&exit_dialog , "\cQ");  
    $cui->set_binding( \&exit_dialog , "q"); 
    $cui->set_binding( \&exit_dialog , "Q"); 
    
    $win2->focus();
   
        
    
     
    $cui->mainloop();    
    
    
       
    