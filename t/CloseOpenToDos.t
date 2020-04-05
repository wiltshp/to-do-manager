use strict;
use warnings;
use Test::More::Behaviour 'no_plan';
use Data::Dumper;
use lib::CreateNewToDo;
use Test::File;
use Date::Calc qw/Delta_DHMS Today_and_Now/;


BEGIN { use_ok( 'CloseOpenToDos' ); }

my $file = 'ToDoTest.txt';
my $test_row = 'Test Generate New Entry';

describe 'CloseOpenToDos' => sub {
    
	sub before_each {
	    unlink($file);
            CreateNewToDo->generate_new_entry($file, $test_row);
	    CreateNewToDo->generate_new_entry($file, $test_row.'abc');
	    CreateNewToDo->generate_new_entry($file, $test_row.'123');
            file_exists_ok($file);
            file_readable_ok($file);
            file_writeable_ok($file);	    
	}
        
        it 'Should intaniate itself' => sub {
	    my $object = CloseOpenToDos->new ();
	    isa_ok ($object, 'CloseOpenToDos');
	};
        
        it 'Should close out an open ToDo number by noting the date and time it was closed' => sub {
            my ($year, $mon, $day, $hr, $min, $sec) = Today_and_Now();
            CloseOpenToDos->CloseToDo($file,3); #close the 123 row only
            open(FILE, $file);
            my @row;
	    my $closed_date_time;

            while(<FILE>) {
                chomp;
		@row = split('~',$_);
		my $match = 'Test Generate New Entry123';
		if ( grep(/^$match/,$row[1]) ) {
			$closed_date_time = $row[2];
		}
            }
            close (FILE);

	    my ($filemon, $fileday, $fileyear,$filehr, $filemin, $filesec) = split (/[:\/-]/,$closed_date_time);
	    $fileday = int($fileday);
	    $filemon = int($filemon);
	    $fileyear = int($fileyear);
	    $filehr = int($filehr);
	    $filemin = int($filemin);
	    $filesec = int($filesec);
	    my ($Dd,$Dh,$Dm,$Ds) = Delta_DHMS($year,$mon,$day,$hr,$min,$sec, $fileyear,$filemon,$fileday,$filehr,$filemin,$filesec);
	    is($Dd,0, 'Has the correct day');
	    is($Dh,0, 'Has the correct hour');
	    is($Dm,0, 'Has the correct min');
	    is($Ds,0, 'Has the correct second');
        };
        
        it 'Should return a msg noting an invalid To Do number was picked' => sub {
	    my $return = CloseOpenToDos->CloseToDo($file,'10');
	    is($return,'An invalid option was chosen','Returns correct Message');
            
        };
        

};