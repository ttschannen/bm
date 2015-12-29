#!/usr/bin/perl
#
#
#
my $DEBUG=0;
my $odir="content";

my $bm={};
while(<>){
    # skip comments and empty lines
    next if $_=~/^\s*#/;
    next if $_=~/^\s*$/;
    chop;
    my ($file,$title,$url)=split(/\s*;\s*/);
    printf ("in File[%s] with title '%s' for %s\n",$file,$title,$url) if $DEBUG;
    $bm->{$file}->{$title}=$url;
}

foreach $f(keys $bm){
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
    foreach $t(sort keys $bm->{$f}){
        printf ("  found title [%s]\n",$t) if $DEBUG;
        printf (F "    <item>\n");
        printf (F "      <title>%s</title>\n",$t);
        printf (F "      <link>%s</link>\n",$bm->{$f}->{$t});
        printf (F "    </item>\n");
    }
    print F <<'EndOfTrailer';
  </channel>
</rss>
EndOfTrailer
}
