#!/usr/bin/perl

use Data::Dumper;

$hash = { arg1 => 1, arg2 => 2 };

%defaults = ( first => un, second => deux );
$defref   = { blaine => three, pascal => four };

# print "ref: ref($hash)\n";
# print Dumper($hash);


sub gethash
{
    my %inhash = @_;

    $hashref = \%inhash;
    # print "ref(@_)\n";
    print "ref($hashref)\n";
    # print Dumper(@_);
    print Dumper(\%inhash);
    # print Dumper(\$hashref);

    foreach $key (keys(%inhash))
    {
	print "$key is set to $inhash{$key}\n";
    }
    print "\n\n";
}

gethash( one => 1, two => 2);

gethash( %defaults ); 

gethash( %{$defref}); 
