#!/usr/bin/perl
#
#
#
my $DEBUG=0;
my $bdir="content";

open(BMFILES,"ls -1 $bdir/bm_*.xml|");

open(I,">$bdir/bmi.asciidoc")||die "cannot open $bdir/index.asiidoc for writing";


    print I <<"EndOfHeader";
+++
date = "2015-12-29T08:36:54-07:00"
draft = false
title = "Index"

+++
= Index

We have these bookmarkfiles:

[options="compact"]
EndOfHeader


while(<BMFILES>){
	chop;
	$_=~/bm_(\w+)\.xml$/;
	$fn=$1;
	printf (I "* http://ttschannen.github.io/bm/bm_%s.xml[%s]\n",$fn,$fn);
}
    print I <<'EndOfTrailer';

Enjoy!
EndOfTrailer
