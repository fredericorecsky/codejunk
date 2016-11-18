

use Proc::Daemon;

my $daemon = Proc::Daemon->new( 
    work_dir    =>  '/',
    pid_file    =>  '/tmp/useless_machine',
);

print $daemon->Status();

print "\n";
