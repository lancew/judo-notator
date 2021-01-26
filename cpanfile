requires "Curses::UI"       => "0.9609";
requires "Readonly"         => "2.05";

on 'test' => sub {
    requires "File::Find::Rule" => "0.34";
    requires "Test::Output"     => "1.031";

};

on 'develop' => sub {
    requires "Perl::Tidy"       => "2021011";
    requires "Perl::Critic"     => "1.138"
};
