use strict;
use warnings;
use Test::More::Behaviour 'no_plan';
use Data::Dumper;
use lib::CreateNewToDo;
use Test::File;
use lib::CloseOpenToDos;

BEGIN { use_ok( 'ListOpenCloseToDos' ); }

my $file = 'ToDoTest.txt';
my $test_row = 'Test Generate New Entry';

describe 'ListOpenCloseToDos' => sub {
    
	sub before_each {
	    unlink($file);
            for (my $num_of_to_do_entries = 1; $num_of_to_do_entries <= 10; $num_of_to_do_entries++) {
                CreateNewToDo->generate_new_entry($file, $test_row.$num_of_to_do_entries);
            }
            file_exists_ok($file);
            file_readable_ok($file);
            file_writeable_ok($file);	    
	}
        
        it 'Should intaniate itself' => sub {
	    my $object = ListOpenCloseToDos->new ();
	    isa_ok ($object, 'ListOpenCloseToDos');
	};
        
        it 'Should generate a list of descriptions for only currently open to dos' => sub {
	    CloseOpenToDos->CloseToDo($file,'10');	
            my @currently_open_items = ListOpenCloseToDos->listopen($file);
            is(@currently_open_items,9,'Listed correct number of open to dos');
            my $rownum = 1;
            foreach my $row (@currently_open_items) {
                is($row,'Test Generate New Entry'.$rownum, $rownum.' row is valid and is open');
                $rownum++;
            }
        };
	
	it 'Should generate a list of descriptions for only closed to dos' => sub {
	    CloseOpenToDos->CloseToDo($file,'10');
	    CloseOpenToDos->CloseToDo($file,'9');
	    CloseOpenToDos->CloseToDo($file,'8');	
            my @currently_closed_items = ListOpenCloseToDos->listclosed($file);
            is(@currently_closed_items,3, 'Closed the correct number of items');
            my $rownum = 8;

            foreach my $row (@currently_closed_items) {
                is($row,'Test Generate New Entry'.$rownum, $rownum.' row is valid and is closed');
                $rownum++;
            }
        };
        
};