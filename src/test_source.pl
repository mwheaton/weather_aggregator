#!/usr/bin/perl
# test to confirm W_source works properly

# use the BEGIN code below or invoke with:  perl -I . test_entry.pl
# to import the local modules

BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;
use W_source;
use Data::Dumper;


my $new_entry = W_source::sherman_get_entry();

print "printing the new entry:\n";
$new_entry->print();

