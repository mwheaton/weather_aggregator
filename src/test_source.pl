#!/usr/bin/perl
# test to confirm W_source works properly

# use the BEGIN code below or invoke with:  perl -I . test_entry.pl
# to import the local modules

BEGIN { push(@INC, "/home/mwheat/payroc/weather_aggregator/src") }
use W_entry;
use W_source;
use Data::Dumper;

my %sherman_data =
    (
     pcode => '06784',
     source => "Sherman",
     lat => 41.5772,
     long => -73.4730,
    );

sub sherman_get_entry
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

# passing the subroutine into the class is not working.  I need to try another approach
$ge_ref =  \&sherman_get_entry;

$source = W_source->new(%sherman_data, get_entry => $ge_ref);
