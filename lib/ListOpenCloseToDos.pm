package ListOpenCloseToDos;
use strict;
use warnings;
use Data::Dumper;


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

sub listopen {
    
    my ($class,$file) = @_;
    
    my @lines = slurp_all_existing_to_dos_into_array($file);
    
    my @list_of_open_to_dos = return_to_dos(@lines,3);
    
    return @list_of_open_to_dos;    

}

sub listclosed {
    
    my ($class,$file) = @_;
    
    my @lines = slurp_all_existing_to_dos_into_array($file);
    
    my @list_of_closed_to_dos = return_to_dos(@lines,4);
    
    return @list_of_closed_to_dos;    
}

sub return_to_dos
{
    my (@lines) = @_;
    my $length = pop(@lines);

    my @return_array;

    foreach my $row (@lines) {
	if (to_do_is_correct_criteria($row, $length)) {
	    my @row_values= split(/~/, $row);
	    push (@return_array,$row_values[1]);
	}
    }
    
    return @return_array;
}

sub to_do_is_correct_criteria
{
    my ($row, $length) = @_;
    
    my @row_values= split(/~/, $row);
    if (@row_values == $length) {
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