#!/usr/bin/perl
# initial test to confirm W_entry is correct

# use the BEGIN code below or invoke with:  perl -I . test_entry.pl
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

# sample CSV:
# 2024-01-31 18:15:00,1018.50,32.0,28.6,87,0,157,,,,,,

# data initialization is broken up into two steps to simulate how it
# will actually be processed when retrieved from an API.  In this
# example shermanctweather returns only its own weather so things like
# postal address, lat, and long are fixed.  The rest will be filtered
# out of the content returned

# unchanging data for the shermanctweather site
my %data =
    (
     pcode => '06784',
     source => 'CW0465',
     lat => 41.5772,
     long => -73.4730,
    );


sub get_entry
{
    # values that are specific to this source retrieval (source config)
    my %sconf =
	(
	 result_dir          => "sherman_results",
	 url                 => 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1',
	 result_file_pattern => "wxobservations*",
	);
    # FIXTHIS: output from wget includes file name generated.  seems to be
    # coming out of stderr?  retrieve lines, clean up output, and get that filename
    # alternatively replace it with an LWP exchange
    # system("cd sherman_results;wget 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1'");
    system("cd $sconf{result_dir} ;wget \'$sconf{url}\'");
    if($?) { die "\n*** EXITING ****: data retrieval failed for sherman CT weather\n\n";}

    # open file and parse last line
    # if cleanup did not occur, get the most recent file (last on the list)
    my $file;
    # my @files = <./$sconf{result_dir}/wxobservations*>;
    my @files = <./$sconf{result_dir}/$sconf{result_file_pattern}>;
    if(@files) { $file = pop(@files);}

    # print "@files \n";
    print "File to parse: $file \n";
    
    open(FILE, "<", $file) or die ("cannot open weather file: $file");
    my $line;
    my @lines = <FILE>; 
    
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
    return $entry;
}

my $new_entry = get_entry();

print "printing the new entry:\n";
$new_entry->print();

print "ref: ref($new_entry)\n";
