package W_entry;
use strict;
use Carp;
use Data::Dumper;

sub new
{
    print "inside new:\n";
    # print Dumper(@_);
    my $caller = shift;
    my %args = @_;
    my $class = ref($caller) || $caller;

    # print "caller; $caller\n";
    # print "class: $class\n";

    # my ($key, $val);
    # foreach $key ( keys(%args))
    # {
    # 	print "$key is $args{$key}\n";
    # }
    # print "arglist:\n";
    # print Dumper(\%args);
    
    my $self = { @_ };
   {
	pcode    => $args{pcode}   || "unknown",  # croak ("missing pcode key value\n"),
	source   => $args{source} || "unknown",   # croak ("missing source key value\n"),
	utime => $args{utime} || "????",
	lat => $args{lat} || "????",
	long => $args{long} || "????",
	temp => $args{temp} || "????",
	wind_speed => $args{wind_speed} || "????",
	wind_dir  => $args{wind_dir} || "????",
	chance_precip => $args{chance_precip} || "????"
    };
    bless $self, $class;
    print "self:\n";
    print Dumper($self);
    # print "ref($self) \n";
    return $self;
}
    
# sub print
# {
# }

1;
    
