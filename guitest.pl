    #!/usr/bin/perl -w

    use strict;
    use warnings;
    use Curses::UI;
    my $cui = new Curses::UI( -color_support => 1 );
    
    my @menu = (
          { -label => 'File', 
            -submenu => [
           { -label => 'Exit      ^Q', -value => \&exit_dialog  }
                        ]
           },
        );
        
        
    sub exit_dialog()
        {
                my $return = $cui->dialog(
                        -message   => "Do you really want to quit?",
                        -title     => "Are you sure???", 
                        -buttons   => ['yes', 'no'],

                );

        exit(0) if $return;
        }
        
        
        
    my $menu = $cui->add(
                'menu','Menubar', 
                -menu => \@menu,
                -fg  => "blue",
        );
        
        
    my $win1 = $cui->add(
                             'win1', 'Window',
                             -border => 1,
                             -y    => 1,
                             -bfg  => 'red',
                     );
                     
                     
                                            
    $cui->set_binding(sub {$menu->focus()}, "\cX");
    $cui->set_binding( \&exit_dialog , "\cQ");  
    $cui->set_binding( \&exit_dialog , "q"); 
    $cui->set_binding( \&exit_dialog , "Q"); 
    
    my $label = $win1->add(
        'mylabel', 'Label',
        -text      => 'Hello, world!',
        -bold      => 1,
    );

    $label->draw;
    
    
    
    
    $cui->mainloop();    
    slepp(1);
    $label->text('Lance');
    
    $label->refresh;
    
    