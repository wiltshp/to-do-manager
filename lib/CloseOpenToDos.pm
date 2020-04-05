package CloseOpenToDos;
use strict;
use warnings;
use Data::Dumper;
use Date::Calc qw/Today_and_Now/;
use lib::ListOpenCloseToDos;

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
}


sub new {
    my $self = {};
	
    bless($self);
    return $self;
}

sub CloseToDo {
    
    my ($class,$file,$closenum) = @_;
    
    my @lines = slurp_all_existing_to_dos_into_array($file);
    
    my @currently_open_items = ListOpenCloseToDos->listopen($file);

    $closenum--;

    if ( invalid_option_is_chosen($closenum, @currently_open_items) ) {
	return 'An invalid option was chosen';
    }

    my @new_records = ();
    my $test_for_valid_option = 0;
    
    foreach my $row (@lines) {
        if ( this_is_the_item_to_be_closed($currently_open_items[$closenum],$row) ) {
	    @new_records = close_to_do_out(@new_records, $row);
	    $test_for_valid_option++;
        }else {
	    push(@new_records, $row);
        }
    }

    write_closed_record_back_out(@new_records, $file);
    
    if ($test_for_valid_option > 0) {
	return 'An invalid option was chosen';
    }
    
}

sub close_to_do_out
{
    my (@new_records) = @_;
    my $row = pop(@new_records);
    
    my ($open_date, $descr, $close_date) = split('~',$row);
    
    my ($year,$mon,$day,$hour,$min,$sec) = Today_and_Now();
    my $closed_date = sprintf( "%02d/%02d/%04d-%02d:%02d:%02d", $mon, $day, $year, $hour, $min, $sec );
    
    my $new_row = join('~',$open_date,$descr,$closed_date."~\n");

    push (@new_records,$new_row);
    
    return @new_records;
}

sub this_is_the_item_to_be_closed {
    my ($current_description_to_be_closed, $current_grep_record) = @_;

    if ( grep(/$current_description_to_be_closed/,$current_grep_record) ) {
	return 1;
    }else{
	return ;
    }
}

sub write_closed_record_back_out
{
    my (@dump_array) = @_;
    my $file = pop(@dump_array);

    open FILE, ">", $file;
    print FILE @dump_array;
    close FILE;
}

sub invalid_option_is_chosen {
    
    my ($closenum, @currently_open_items) = @_;

    if ($closenum > @currently_open_items) {
	return 1;
    }else{
	return;
    }
}

sub slurp_all_existing_to_dos_into_array
{
    my ($file) = @_;
    
    open FILE, "<", $file;
    my @lines = <FILE>;
    close FILE;

    return @lines;
}

1;