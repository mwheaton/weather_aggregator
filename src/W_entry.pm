package W_entry;
use strict;
use Carp;
use Data::Dumper;

# this package represents the class that manages data, one object per entry

sub new
{
    my $caller = shift;
    my %args = @_;
    my $class = ref($caller) || $caller;

    my $self = { @_ };  #code review!  why am I using input twice!?
   {
	# pcode         => $args{pcode}         || croak ("missing pcode key value\n"),
	source        => $args{source}        || croak ("missing source key value\n"),
	utime         => $args{utime}         || "????",
	lat           => $args{lat}           || "????",
	long          => $args{long}          || "????",
	temp          => $args{temp}          || "????",
	wind_speed    => $args{wind_speed}    || "????",
	wind_dir      => $args{wind_dir}      || "????",
	chance_precip => $args{chance_precip} || "unknown",
    };
    bless $self, $class;
    return $self;
}
    
sub print
{
    my $self = shift @_;

    foreach my $key (sort(keys( %{$self} )))
    {
	# FIXME:  format this output
	print "$key => $self->{$key} \n";
    }
}

1;
    
