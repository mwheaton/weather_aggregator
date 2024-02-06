package W_source;
use strict;
use Data::Dumper;

BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;

# class to store data and methods per weather data source.  Each
# object is a separate source with relevant info on source and method
# of retrieval.

# if source returns data for more than one location, location info may
# be passed in on the argument list 

# retrieval method is unique to each source stored as an anonymous
# function, handling retrieval and parsing

# returns a reference to a W_entry

# ------------------------------------------------------------------------------------------
# sherman ct weather config
# ------------------------------------------------------------------------------------------
sub sherman_get_entry
{
    # information not provided by source retrieval
    my %data =
	(
	 source => 'CW0465',
	 lat => 41.5772,
	 long => -73.4730,
	);
    
    # values that are specific to this source retrieval (source config)
    my %sconf =
	(
	 result_dir          => "sherman_results",
	 url                 => 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1',
	 result_file_pattern => "wxobservations*",         # no longer needed
	 result_file         => "sherman_wxobservations",
	);

    # wget -q = quiet output
    # wget -O <output>  specify a filename, allowing overwriting without prompt (y/n) for permission
    # may want to break up this pair and test for individual success?
    system("cd $sconf{result_dir};
    	    wget -qO \'$sconf{result_file}\' \'$sconf{url}\' ");
    if($?) { die "\n*** EXITING ****: data retrieval failed for sherman CT weather\n\n";}
    
    open(FILE, "<", "$sconf{result_dir}/$sconf{result_file}") or die ("cannot open weather file: $sconf{result_file}");
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
    unlink "$sconf{result_dir}/$sconf{result_file}";
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

1;

