#!/usr/bin/perl

use strict;
use warnings;
use lib::Generate_GUI;
use lib::CreateNewToDo;
use lib::ListOpenCloseToDos;
use lib::CloseOpenToDos;

my $file = 'ToDo.txt';
my $gui = Generate_GUI->new ();

while(1) {
    print $gui->generate;
    my $user_input = <>;
    EvaluateInput($user_input,$file);
    
}


sub EvaluateInput {
    my ($user_input, $file) = @_;
    if ($user_input == 1) {
        print "\n\tTo Do Description: ";
        my $to_do_descr = <>;
        chomp($to_do_descr);
        CreateNewToDo->generate_new_entry($file, $to_do_descr);
    }elsif ($user_input == 2) {
        my @currently_open_items = ListOpenCloseToDos->listopen($file);
        my $rowcount = 1;
        foreach (@currently_open_items) {
                print "\n\t$rowcount) $_";
                $rowcount++;
        }
        print "\n\n\tHit Any Key to Continue.";
        my $wait_for_any_key = <>;
    }elsif ($user_input == 3) {
        print "\n\t\tWhich Item would you like to close:\n";
        my @currently_open_items = ListOpenCloseToDos->listopen($file);
        my $rowcount = 1;
        foreach (@currently_open_items) {
                print "\n\t$rowcount) $_";
                $rowcount++;
        }
        print "\n\n\t--> ";
        my $user_input = <>;
        chomp($user_input);
        CloseOpenToDos->CloseToDo($file,$user_input);
    }elsif ($user_input == 4) {
        my @currently_closed_items = ListOpenCloseToDos->listclosed($file);
        my $rowcount = 1;
        foreach (@currently_closed_items) {
                print "\n\t$rowcount) $_";
                $rowcount++;
        }
        print "\n\n\tHit Any Key to Continue.";
        my $wait_for_any_key = <>;
    }elsif ($user_input == 5) {
        print "\n\tThank you for using To Do list manager!\n\n";
        exit 0;
    }else{
        print "\n\tInvalid Entry, Please try again.\n\n";
    }
}