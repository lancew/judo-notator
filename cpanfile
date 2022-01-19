requires "Curses::UI"       => '== 0.9609';
requires "Readonly"         => '== 2.05';

on 'test' => sub {
    requires "File::Find::Rule" => '== 0.34';
    requires "Test::Output"     => '== 1.033';

};

on 'develop' => sub {
    requires "Perl::Tidy"       => '== 20211029';
    requires "Perl::Critic"     => '== 1.140'
};
