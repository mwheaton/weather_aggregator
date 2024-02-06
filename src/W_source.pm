package W_source;
use strict;
use DBI;
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
    # unlink returns number of files removed, check to verify
    unlink "$sconf{result_dir}/$sconf{result_file}";
    
    # split the line by commas
    my ($ut, undef, $temp, undef, undef, $ws, $wd) = split(",", $line);
        
    $data{utime} = $ut;
    $data{temp} = $temp;
    $data{wind_speed} = $ws;
    $data{wind_dir} = $wd;
    
    my $entry  = W_entry->new(%data);

    # print Dumper($entry);
   
    $entry->print();
    print "\n\n";
    return $entry;    # keep this for test_source, but comment out for production
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

    # filename no longer has a gz extention
    my $csv_file;
    ($csv_file = $sconf{result_file}) =~ s/\.gz$//;

    # open the database
    # DBI->connect(dbi:Pg:dbname=$dbname);
    
    # FIXTHIS:  wind_direction can be 'VRB'  Find out what that means, filter or correct
    my ($line, @fields, %data);
    open(FILE, "<", "$sconf{result_dir}/$csv_file") or die ("cannot open weather file: $csv_file");
    foreach $line (<FILE>) 
    {
	# need to filter out non data lines
	if( $line !~ /\,/ || $line =~ /^raw_text/) { next;}
	
	# print "$line\n";
	@fields = split(",", $line);

	$data{source}     = $fields[1];
	$data{utime}      = $fields[2];
	$data{lat}        = $fields[3];
	$data{long}       = $fields[4];
	$data{temp}       = $fields[5];
	$data{wind_dir}   = $fields[7];
	$data{wind_speed} = $fields[8];

	my $entry  = W_entry->new(%data);
 	$entry->print();
	print "\n\n";
	
	# ideally, the entries should be written to database at this point either by insert or update

	# not sure if I can simply insert or if I need to test for a row, insert if not found, update otherwise
	# statement handles might be prepared outside the loop if I can bind parameters with statements
	# example:
	# my $sth = $dbh->prepare("select source from payroc_weather where source = ?");
	# $sth->bind_param( 1, $data{source} );
	# $sth-execute();
	# if( $sth->fetchrow_array)
	# {
	#     $dbh->do(update payroc_weather
	# 	     set .....
	# 	     where source = $data{source} );
	# }
	# else
	# {
	#     $dbh->do( insert into payroc_weather values ( ....) );
	# }

	# # the insert would probably look more like:
	# $I_sth = $dbh->prepare( "insert into payroc_weather ( source, wind_dir.... ) VALUES ( ? )");  # OUTSIDE THE LOOP
	# $I_sth->execute( $values );   INSIDE THE LOOP
	# not sure on the syntax!

	# likewise the update would be prepared as well and parameters would be bound apprpriately
					  
    } # foreach $line

    
    unlink $sconf{result_file};
    unlink $csv_file;
    
}
# ------------------------------------------------------------------------------------------

sub update_all()
{
    # put each update source here to invoke
    sherman_get_entry();
    metars_get_entries();

}
    
1;

