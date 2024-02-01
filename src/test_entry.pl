#!/usr/bin/perl
# initial test to confirm W_entry is correct

# invoke with:  perl -I . test_entry.pl
# to import the local modules

use strict;

# add local directory to @INC to find local module
# change this to your local path or use the abovd invocation of perl above
BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;
use Data::Dumper;

# sample data from ShermanCT weather:
# "Time (UTC)" 2024-01-24 19:15:00
# "Barometric Pressure (mbar)" 1028.90
# "Temperature (degrees F)" 35.0
# "Dewpoint (degrees F)" 33.7
# "Relative Humidity (%)" 95
# "Wind speed (mph)" 0
# "Wind direction (degrees)" 85
# "Percent chance of rain"  25

# Latitude: 41° 34' 38" N (deg min sec), 41.5772° (decimal), 4134.63N (LORAN)
# Longitude: 73° 28' 23" W (deg min sec), -73.4730° (decimal), 07328.38W

# CSV:
# 2024-01-31 18:15:00,1018.50,32.0,28.6,87,0,157,,,,,,

# pcode, zip,precip and lat long are missing so we will fudge that for testing

# data initialization is broken up into two steps to simulate how it
# will actually be processed when retrieved from an API.  In this
# example shermanctweather returns only its own weather so thinks like
# postal address, lat, and long are fixed.  The rest will be filtered
# out of the content returned

# unchanging data for the shermanctweather site
my %data =
(
    pcode => '06784',
    source => "Sherman",
    lat => 41.5772,
    long => -73.4730,
);

# FIXTHIS: output from wget includes file name generated.  seems to be
# coming out of stderr?  retrieve lines, clean up output, and get that filename
system("cd sherman_results;wget 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1'");
if($?) { die "\n*** EXITING ****: data retrieval failed for sherman CT weather\n\n";}

# open file and parse last line
# if cleanup did not occur, get the most recent file (assumed to be the last on the list)
my $file;
my @files = <./sherman_results/wxobservations*>;
if(@files) { $file = pop(@files);}

# print "@files \n";
print "$file \n";
	     
open(FILE, "<", $file) or die ("cannot open weather file: $file");
my $line;
my @lines = <FILE>; 
# foreach $line (@lines)
# {
#     print $line;
# }

$line = pop(@lines);
if(!$line)
{  
    warn "data retrieval failed\n";
    # don't update, leave file for debug
    exit;  # should be return if used as a method
}
# unlink returns number of files removed, check count or perhaps use the file list from the above glob (@files)
unlink $file;
print "last line:\n";
print $line;

# split the line by commas
my ($ut, undef, $temp, undef, undef, $ws, $wd) = split(",", $line);
print "$ut,, $temp,, $ws, $wd\n"; 

$data{utime} = $ut;
$data{temp} = $temp;
$data{wind_speed} = $ws;
$data{wind_dir} = $wd;

my $entry  = W_entry->new(%data);

# # print "back from new\n";
print Dumper($entry);
# # print "ref: ref($entry)\n";

# $entry->print();
