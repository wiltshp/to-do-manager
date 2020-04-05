package Generate_GUI;
use strict;
use warnings;
use Data::Dumper;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    @EXPORT      = qw(generate);
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
}


sub new {
	my $self = {};
	
	bless($self);
	return $self;
}

sub generate {
	my @gui = ();
	push (@gui,"\n\tHello, how would you like to alter the current To Do list:");
	push (@gui,"\n\t\t1)\tGenerate a new To Do");
	push (@gui,"\n\t\t2)\tList Current Open To Dos");
	push (@gui,"\n\t\t3)\tClose out a current To Do");
	push (@gui,"\n\t\t4)\tList Closed To Dos");
	push (@gui,"\n\t\t5)\tExit To Do manager");
	push (@gui,"\n\n\t--> ");
	return @gui;
}

1;
