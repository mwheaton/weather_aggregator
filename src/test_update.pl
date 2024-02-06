#!/usr/bin/perl
# test to confirm W_source does updates for all sources

# use the BEGIN code below or invoke with:  perl -I . test_entry.pl
# to import the local modules

BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;
use W_source;
use DBI;
use Data::Dumper;

# W_source::sherman_get_entry();
# W_source::metars_get_entries();

# alternatively, open the database here
 DBI->connect(dbi:Pg:dbname=$dbname);

W_source::update_all();

