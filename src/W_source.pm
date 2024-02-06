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
my %sherman_data =
    (
     pcode => '06784',
     source => "CW0465",
     lat => 41.5772,
     long => -73.4730,
    );


sub sherman_get_entry
{
    # values that are specific to this source retrieval (source config)
    my %sconf =
	(
	 pcode => '06784',
	 source => "Sherman",
	 lat => 41.5772,
	 long => -73.4730,
	 result_dir          => "sherman_results",
	 url                 => 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1',
	 result_file_pattern => "wxobservations*",
	);
    # # FIXTHIS: output from wget includes file name generated.  seems to be
    # # coming out of stderr?  retrieve lines, clean up output, and get that filename
    # # alternatively replace it with an LWP exchange
    # # system("cd sherman_results;wget 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1'");
    # system("cd $sconf{result_dir} ;wget \'$sconf{url}\'");
    # if($?) { die "\n*** EXITING ****: data retrieval failed for sherman CT weather\n\n";}

    # # open file and parse last line
    # # if cleanup did not occur, get the most recent file (last on the list)
    # my $file;
    # # my @files = <./$sconf{result_dir}/wxobservations*>;
    # my @files = <./$sconf{result_dir}/$sconf{result_file_pattern}>;
    # if(@files) { $file = pop(@files);}

    # # print "@files \n";
    # print "File to parse: $file \n";
    
    # open(FILE, "<", $file) or die ("cannot open weather file: $file");
    # my $line;
    # my @lines = <FILE>; 
    
    # $line = pop(@lines);
    # if(!$line)
    # {  
    # 	warn "data retrieval failed\n";
    # 	# don't update, leave file for debug
    # 	exit;  # should be return if used as a method
    # }
    # # unlink returns number of files removed, check count or perhaps use the file list from the above glob (@files)
    # unlink $file;
    # print "last line:\n";
    # print $line;

    # # split the line by commas
    # my ($ut, undef, $temp, undef, undef, $ws, $wd) = split(",", $line);
    # print "$ut,, $temp,, $ws, $wd\n"; 
    
    # $data{utime} = $ut;
    # $data{temp} = $temp;
    # $data{wind_speed} = $ws;
    # $data{wind_dir} = $wd;
    
    # my $entry  = W_entry->new(%data);

    # # # print "back from new\n";
    # print Dumper($entry);
    # # # print "ref: ref($entry)\n";

    # # $entry->print();
    # return $entry;
}

# ------------------------------------------------------------------------------------------
# METARS  weather config
# ------------------------------------------------------------------------------------------

sub metars_get_entries
{

#      wget "https://aviationweather.gov/data/cache/metars.cache.csv.gz"
    # values that are specific to this source retrieval 
    my %sconf =
	(
	 result_dir          => "metar_results",
	 url                 => 'https://aviationweather.gov/data/cache/metars.cache.csv.gz',
	 result_file         => "metars.cache.csv.gz*",
	);
    # # FIXTHIS: output from wget includes file name generated.  seems to be
    # # coming out of stderr?  retrieve lines, clean up output, and get that filename
    # # alternatively replace it with an LWP exchange
    # # system("cd sherman_results;wget 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1'");
    system("cd $sconf{result_dir} ;wget \'$sconf{url}\' -O \'$sconf{result_file}\'");
    if($?) { die "\n*** EXITING ****: data retrieval failed for sherman CT weather\n\n";}
    
    # strip off numeric extenstion? unzip file

    # # open file and parse last line
    # # if cleanup did not occur, get the most recent file (last on the list)
    # my $file;
    # # my @files = <./$sconf{result_dir}/wxobservations*>;
    # my @files = <./$sconf{result_dir}/$sconf{result_file_pattern}>;
    # if(@files) { $file = pop(@files);}

    # # print "@files \n";
    # print "File to parse: $file \n";
    
    # open(FILE, "<", $file) or die ("cannot open weather file: $file");
    # my $line;
    # my @lines = <FILE>; 
    
    # $line = pop(@lines);
    # if(!$line)
    # {  
    # 	warn "data retrieval failed\n";
    # 	# don't update, leave file for debug
    # 	exit;  # should be return if used as a method
    # }
    # # unlink returns number of files removed, check count or perhaps use the file list from the above glob (@files)
    # unlink $file;
    # print "last line:\n";
    # print $line;

    # # split the line by commas
    # my ($ut, undef, $temp, undef, undef, $ws, $wd) = split(",", $line);
    # print "$ut,, $temp,, $ws, $wd\n"; 
    
    # $data{utime} = $ut;
    # $data{temp} = $temp;
    # $data{wind_speed} = $ws;
    # $data{wind_dir} = $wd;
    
    # my $entry  = W_entry->new(%data);

    # # # print "back from new\n";
    # print Dumper($entry);
    # # # print "ref: ref($entry)\n";

    # # $entry->print();
    # return $entry;
}


# ------------------------------------------------------------------------------------------

# sub new
# {
#     my($caller, %args) = @_;
#     my $class = ref($caller) || $caller;

#     # expect data to vary from source to source, so in this case we want to initialize based on the argument list
#     print "class = $class\n";
#     my $self = {};

#     print ref($args{get_entry});
#     foreach my $key (keys(%args))
#     {
# 	print "new key: $key\n";
# 	$self->{$key} = $args{$key}; 
#     }

#     bless $self, $class;
#     print Dumper($self);

#     $self->get_entry();
# }
    

1;

