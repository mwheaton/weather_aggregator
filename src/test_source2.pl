#!/usr/bin/perl
# test to confirm W_source works properly

# use the BEGIN code below or invoke with:  perl -I . test_entry.pl
# to import the local modules
use strict;

BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;
# use W_source;
use Data::Dumper;


sub metars_get_entries
{

#      wget "https://aviationweather.gov/data/cache/metars.cache.csv.gz"
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
    system("cd $sconf{result_dir} ;
	    wget -qO \'$sconf{result_file}\' \'$sconf{url}\' ;
	    gunzip -f $sconf{result_file};
	    ");
    if($?) { die "\n*** EXITING ****: data retrieval failed for metar weather\n\n";}

    # # if cleanup did not occur, get the most recent file (last on the list)  FIXME: Think about this!
    
    # filename no longer has a gz extention
    my $csv_file;
    ($csv_file = $sconf{result_file}) =~ s/\.gz$//;
    print "csv_file = $csv_file\n";

    open(FILE, "<", "$sconf{result_dir}/$csv_file") or die ("cannot open weather file: $csv_file");
    my ($line, @fields, %data);
    foreach $line (<FILE>) 
    {
	# need to filter out non data lines
	print "$line\n";
	@fields = split(",", $line);

	for( my $i = 0; $i < 9; $i++)
	{
	    print "$i: $fields[$i]\n";
	}

	$data{source}     = $fields[1];
	$data{utime}      = $fields[2];
	$data{lat}        = $fields[3];
	$data{long}       = $fields[4];
	$data{temp}       = $fields[5];
	$data{wind_dir}   = $fields[7];
	$data{wind_speed} = $fields[8];

	$data{pcode} = "???";   #FIXTHIS:  may be doing away with postal code
	my $source = $fields[1];
	my $ut     = $fields[2];
	my $lat    = $fields[3];
	my $long   = $fields[4];
	my $temp   = $fields[5];
	my $wd     = $fields[7];
	my $ws     = $fields[8];

	print "src: $data{source}, utime: $data{utime}  lat: $data{lat} long: $data{long} temp: $data{temp} windir: $data{wind_dir} windspeed: $data{wind_speed}    \n\n";

	# my $entry  = W_entry->new(%data);

	# ideally, the entries should be written to database at this point either by insert or update

    }

    
    unlink $sconf{result_file};
    unlink $csv_file;
    
    # my $entry  = W_entry->new(%data);

    # # # print "back from new\n";
    # print Dumper($entry);
    # # # print "ref: ref($entry)\n";

    # # $entry->print();
    # return $entry;
}

metars_get_entries();
