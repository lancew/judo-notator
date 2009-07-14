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
        -width => 100,
        -pad => 2,
    );     
    

    $cui->set_binding( \&exit_dialog , "\cQ");  
    $cui->set_binding( \&exit_dialog , "q"); 
    $cui->set_binding( \&exit_dialog , "Q"); 
    $cui->set_binding( \&go1 , "1"); 
    
    
    $win1->focus();
   
    
  
my $textviewer = $win1->add( 
        'test', 'TextViewer',
    	-text => '---',
    );  

 sub go1 {
  $textviewer->text('hello');    
 }   
 
 
 
    $cui->mainloop();    
    
    
       
    