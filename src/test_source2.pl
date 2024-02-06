#!/usr/bin/perl
# test to confirm W_source works properly

# use the BEGIN code below or invoke with:  perl -I . test_entry.pl
# to import the local modules
use strict;

BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;
use W_source;
use Data::Dumper;



W_source::metars_get_entries();
