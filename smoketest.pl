use Perl::Critic;
use Perl::Tidy;
use File::Find::Rule;
use Test::Harness qw(&runtests);

    my $file = 'notator.pl';
    my $backup = 'notator.old';

	rename($file, 'notator.old');
	perltidy( source => $backup, destination => $file );



    for($count = 1; $count < 6; $count++){
    	open (MYFILE, ">critic-$count.txt");
        my $critic = Perl::Critic->new(-severity => $count);
    	my @violations = $critic->critique($file);
    	#print @violations;
    	print MYFILE @violations;
    	close (MYFILE);
    	}

