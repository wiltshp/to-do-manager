package CreateNewToDo;
use strict;
use warnings;
use Data::Dumper;
use Date::Calc qw/Today_and_Now/;

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

sub generate_new_entry {
    
    my ($class,$file,$description) = @_;
    
    if_file_doesnt_exist_create_it($file);    
    
    my @lines = slurp_existing_to_dos_into_array($file);

    my @currently_open_to_dos = create_array_with_just_open_entries_as_an_easy_way_to_check_for_duplicates(@lines);

    foreach my $existing_todo (@currently_open_to_dos) {
	if (to_do_is_already_open($existing_todo, $description)) {
	    return "Cannot create '$description', To Do already exists";
	}
    }
    
    write_new_valid_to_do_to_file($file,$description);
    
}

sub write_new_valid_to_do_to_file
{
    my ($file, $description) = @_;
    
    #Get current date and time and format to append to transaction
    my ($year,$mon,$day,$hour,$min,$sec) = Today_and_Now();
    my $curr_date_time = sprintf( "%02d/%02d/%04d-%02d:%02d:%02d", $mon, $day, $year, $hour, $min, $sec );

    open FILE, ">>", $file;
    print FILE $curr_date_time.'~'.$description.'~';
    print FILE "\n";
    close FILE;
}

sub to_do_is_already_open
{
    my ($existing_todo, $new_to_do) = @_;

    if( $existing_todo=~/$new_to_do/i ) {
	return 1;
    } else {
	return ;
    }
}

sub create_array_with_just_open_entries_as_an_easy_way_to_check_for_duplicates
{
    my (@array_of_data) = @_;
    my @currently_open_to_dos;

    foreach my $row (@array_of_data) {
	my @distinct_row_values = split(/~/, $row);
	if (currently_open_to_do(@distinct_row_values)) {
		push(@currently_open_to_dos,$row);
	}
    }
    
    return @currently_open_to_dos;
}

sub currently_open_to_do
{
    my (@distinct_row_values) = @_;
    if (@distinct_row_values > 3) {
	return ;
    }else{
	return 1;
    }

}
sub if_file_doesnt_exist_create_it
{
    my ($file) = @_;
    if (! -r $file) {
        open FILE, "+>>", $file or die $!;
        close FILE;
    }
}

sub slurp_existing_to_dos_into_array
{
    my ($file) = @_;
    
    open FILE, "<", $file;
    my @lines = <FILE>;
    close FILE;

    return @lines;
}

1;