use strict;
use warnings;
use Test::More::Behaviour 'no_plan';
use Data::Dumper;
use Test::Deep;

BEGIN { use_ok( 'Generate_GUI' ); }

describe 'Generate_GUI' => sub {

	it 'Should intaniate itself' => sub {
		my $object = Generate_GUI->new ();
		isa_ok ($object, 'Generate_GUI');
	};
	
	it 'Should generate a GUI with a nice heading' => sub {
		my @gui = Generate_GUI->generate();
		like($gui[0],qr/Hello, how would you like to alter the current To Do list:/,'Heading is ok');
	};		
	
	it 'Should generate a GUI with an option to create a new To Do entry' => sub {
		my @gui = Generate_GUI->generate();
		like($gui[1],qr/Generate a new To Do/,'Menu option New To Do ok');
	};
	
	it 'Should generate a GUI with an option to list current open To Dos' => sub {
		my @gui = Generate_GUI->generate();
		like($gui[2],qr/List Current Open To Dos/,'Menu option List open To Dos ok');		
	};
	
	it 'Should generate a GUI with an option to close out current open To Dos' => sub {
		my @gui = Generate_GUI->generate();
		like($gui[3],qr/Close out a current To Do/,'Menu option close a To Do ok');
	};
	
	it 'Should generate a GUI with an option to list all the closed To Dos from the past' => sub {
		my @gui = Generate_GUI->generate();
		like($gui[4],qr/List Closed To Dos/,'Menu option list closed To Dos ok');
	};
	
	it 'Should generate a GUI with an option to gracefully exit the To Do manager' => sub {
		my @gui = Generate_GUI->generate();
		like($gui[5],qr/Exit To Do manager/,'Menu option exit To Do manger ok');
	};
};
