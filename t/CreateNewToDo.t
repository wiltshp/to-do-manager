use strict;
use warnings;
use Test::More::Behaviour 'no_plan';
use Data::Dumper;
use Test::File;
use Date::Calc qw/Delta_DHMS Today_and_Now/;

BEGIN { use_ok( 'CreateNewToDo' ); }

my $file = 'ToDoTest.txt';
my $test_row = 'Test Generate New Entry';

describe 'CreateNewToDo' => sub {
    
	sub before_each {
	    unlink($file);
            CreateNewToDo->generate_new_entry($file, $test_row);
            file_exists_ok($file);
            file_readable_ok($file);
            file_writeable_ok($file);	    
	}

	it 'Should intaniate itself' => sub {
	    my $object = CreateNewToDo->new ();
	    isa_ok ($object, 'CreateNewToDo',);
	};
        
        it 'Should create a new entry if the create new To Do option is chosen.' => sub {
            open(FILE, $file);
            my @row;
            while(<FILE>) {
                chomp;
		@row = split('~',$_);
            }
            close (FILE);
            is($row[1],$test_row, 'The Row was created successfully');
        };
        
        it 'Should put the current date and time on a new entry to know when it was created' => sub {
            my ($year, $mon, $day, $hr, $min, $sec) = Today_and_Now();
            open(FILE, $file);
            my @row;
            while(<FILE>) {
                chomp;
                @row = split('~',$_);
            }
            close (FILE);
	    my ($filemon, $fileday, $fileyear,$filehr, $filemin, $filesec) = split (/[:\/-]/,$row[0]);
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
	
	    
	it 'Should not let you create duplicate open entries' => sub {
	    my $return_msg = CreateNewToDo->generate_new_entry($file, $test_row);
	    is($return_msg,"Cannot create '$test_row', To Do already exists",'Will not create duplicate entries');
	};
};