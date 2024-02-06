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

#------------------------------------------------------------------------------------------
# metars weather config
#------------------------------------------------------------------------------------------

sub metars_get_entries
{
    # values that are specific to this source retrieval 
    my %sconf =
	(
	 result_dir          => "metar_results",
	 url                 => 'https://aviationweather.gov/data/cache/metars.cache.csv.gz',
	 result_file         => "metars.cache.csv.gz",
	);

    # wget -q = quiet output
    # wget -O <output>  specify a filename, allowing overwriting without prompt (y/n) for permission
    # may want to break up this trio and test for individual success?
    # cd into result directory, wget the file, and unzip it
    system("cd $sconf{result_dir} ;
	    wget -qO \'$sconf{result_file}\' \'$sconf{url}\' ;
	    gunzip -f $sconf{result_file};
	    ");
    if($?) { die "\n*** EXITING ****: data retrieval failed for metar weather\n\n";}

    # # if cleanup did not occur, get the most recent file (last on the list)  FIXME: Think about this!
    
    # filename no longer has a gz extention
    my $csv_file;
    ($csv_file = $sconf{result_file}) =~ s/\.gz$//;
    # print "csv_file = $csv_file\n";

    my ($line, @fields, %data);
    open(FILE, "<", "$sconf{result_dir}/$csv_file") or die ("cannot open weather file: $csv_file");
    foreach $line (<FILE>) 
    {
	# need to filter out non data lines
	if( $line !~ /\,/ || $line =~ /^raw_text/) { next;}
	
	# print "$line\n";
	@fields = split(",", $line);

	# for( my $i = 0; $i < 9; $i++)
	# {
	#     print "$i: $fields[$i]\n";
	# }

	$data{source}     = $fields[1];
	$data{utime}      = $fields[2];
	$data{lat}        = $fields[3];
	$data{long}       = $fields[4];
	$data{temp}       = $fields[5];
	$data{wind_dir}   = $fields[7];
	$data{wind_speed} = $fields[8];

	# # $data{pcode} = "???";   #FIXTHIS:  may be doing away with postal code
	# my $source = $fields[1];
	# my $ut     = $fields[2];
	# my $lat    = $fields[3];
	# my $long   = $fields[4];
	# my $temp   = $fields[5];
	# my $wd     = $fields[7];
	# my $ws     = $fields[8];

	# print "src: $data{source}, utime: $data{utime}  lat: $data{lat} long: $data{long} temp: $data{temp} windir: $data{wind_dir} windspeed: $data{wind_speed}    \n\n";
	# print Dumper(\%data);

	my $entry  = W_entry->new(%data);
 	$entry->print();
	# ideally, the entries should be written to database at this point either by insert or update

    } # foreach $line

    
    unlink $sconf{result_file};
    unlink $csv_file;
    
}
    
1;

