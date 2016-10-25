#!/usr/bin/perl
#
#
#
my $DEBUG=0;
my $odir="content";
my $sdir="static";

my $bm={};
my @f;


while(<>){
# skip comments and empty lines
	next if $_=~/^\s*#/;
	next if $_=~/^\s*$/;
	chop;
	my ($file,$title,$url)=split(/\s*;\s*/);
        my @files = split(/\s*,\s*/,$file);
        foreach $file (@files){
	    printf ("in File[%s] with title '%s' for %s\n",$file,$title,$url) if $DEBUG;
	    $bm->{$file}->{$title}=$url;
       }
}

#
# for IE we produce a simple table in its own file
#
open(T,">$sdir/bm.asciidoc")||die "cannot open $sdir/bm.asciidoc for writing";
print T <<"EndOfHeader";
= TT's bookmarks

[grid="none",frame="topbot",width="40%",cols=">1,<5"]
|==============================
EndOfHeader


open(TS,">$sdir/bms.asciidoc")||die "cannot open $sdir/bm.asciidoc for writing";
print TS <<"EndOfHeader";
= TT's bookmarks

Go to http://ttschannen.github.io/bm/bm.html[flat version]

[grid="none",frame="topbot",width="40%",cols=">1,<5"]
|==============================
EndOfHeader


foreach $f(keys $bm){
        push(@f,$f);
	my $nf =1;
	printf ("found file [%s]\n",$f) if $DEBUG;
	open(F,">$odir/bm_$f.xml")||die "cannot open $odir/bm_$f.xml for writing";
	print F <<"EndOfHeader";
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>$f Bookmarks</title>
    <link>http://ttschannen.github.io/bm/</link>
    <description>TTs $f bookmarks</description>
    <generator>Hugo -- gohugo.io</generator>
    <language>en-us</language>
EndOfHeader
	printf (T "|http://ttschannen.github.io/bm/bm_%s.html[%s]",$f,$f);
	printf (TS "|http://ttschannen.github.io/bm/bm_%s.html[%s]|\n",$f,$f);
	foreach $t(sort keys $bm->{$f}){
		my $l = $bm->{$f}->{$t};
		my $el;
                ($el = $l) =~ s/&/&amp;/g;
		printf ("  found title [%s]\n",$t) if $DEBUG;
		printf (F "    <item>\n");
		printf (F "      <title>%s</title>\n",$t);
		printf (F "      <link>%s</link>\n",$el);
		printf (F "    </item>\n");
		if ($nf){
			$nf = 0;
			printf (T "|%s[%s]\n",$l,$t);
		} else {
			printf (T "||%s[%s]\n",$l,$t);
		}
	}
	print F <<'EndOfTrailer';
  </channel>
</rss>
EndOfTrailer
	print FH <<'EndOfTrailer';
|==============================
EndOfTrailer
}
print T <<'EndOfTrailer';
|==============================
EndOfTrailer
print TS <<'EndOfTrailer';
|==============================
EndOfTrailer


@fs=sort @f;


foreach $i (0  .. $#fs){
    #
    # ith bm file
    #
    my $f = $fs[$i];
    open(FH,">$sdir/bm_$f.asciidoc")||die "cannot open $odir/bm_$f.asciidoc for writing";
    print FH <<"EndOfHeader";

=  TT's $f bookmarks

Go to http://ttschannen.github.io/bm/bm.html[flat version]
[grid="none",frame="topbot",width="40%",cols="1a,5a"]
|==============================
|
[cols=">1",grid="none",frame="none"]
!==============================================
EndOfHeader
    foreach $tf (0 .. $#fs){
        #printf(FH "![big]#http://ttschannen.github.io/bm/bm_%s.html[%s]#\n",$fs[$tf],($i==$tf) ? "*$fs[$tf]*" : "$fs[$tf]");
        printf(FH "!http://ttschannen.github.io/bm/bm_%s.html[%s]\n",$fs[$tf],($i==$tf) ? "*$fs[$tf]*" : "$fs[$tf]");
    }
    print FH <<"EndOfHeader";
!==============================================
|
[cols="<1",grid="none",frame="none"]
!==============================================
EndOfHeader
    foreach $t(sort keys $bm->{$fs[$i]}){
        my $l = $bm->{$fs[$i]}->{$t};
        #printf(FH "![big]#%s[%s]#\n",$l,$t);
        printf(FH "!%s[%s]\n",$l,$t);
    }
    print FH <<"EndOfHeader";
!==============================================

|==============================================
EndOfHeader
    close(FH);
}
