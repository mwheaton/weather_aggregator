#!/usr/bin/perl -w

# quick test to confirm syntax for reference to subroutine

sub say_hello
{
    print "hey yall, (waving)\n";
}

$fref = \&say_hello;





package main;

say_hello;

&$fref;
