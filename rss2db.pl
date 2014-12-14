#!/usr/bin/perl

use DBI;
use XML::Feed;
use DateTime::Format::Strptime;
use encoding "utf-8";
use POSIX qw(strftime);

my $necro = 86400; # 24 hours
# get timestamp
my $now = strftime "%F %T", localtime;
my $now_s  = strftime "%s", localtime;

# DBI init (pretend we are compatible)
my $db = "/www/putinometras.lt/data/headlines.db";
my $driver   = "SQLite"; 
my $dsn = "DBI:$driver:dbname=$db";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
    or die $DBI::errstr; #FIXME error handling
my $sql = "create table if not exists headlines (date, time, site, headline, unique(date, time, site, headline))";
$dbh->do($sql); #FIXME error handling
$sql = "create table if not exists system (timestamp)";
$dbh->do($sql);

# RSS feeds of the most popular news portals
# according to http://www.audience.lt
my @rss = ('http://www.delfi.lt/rss/feeds/daily.xml',
           'http://www.15min.lt/rss',
           'http://www.lrytas.lt/rss/',
           'http://vz.lt/RSS.aspx',
           'http://www.balsas.lt/rss/sarasas/0');


for my $url (@rss){
    my $feed = XML::Feed->parse(URI->new($url))
        or next; #FIXME error handling
    # reverse loop to get older records first
    for my $entry (reverse $feed->entries) {
        # prepare pubDate container
        # LT locale fix
        my $strp = new DateTime::Format::Strptime(
            pattern     => '%a, %d %b %Y %T %z',
            locale      => 'lt_LT',
        );
        my $date;
        if($entry->issued){
            $date = $entry->issued;
        }else{
            # if standard method fails, try LT locale on raw date
            $date = $strp->parse_datetime($entry->unwrap->{'pubDate'});
        }
        # ignore necromants
        next if (($now_s - $date->strftime("%s")) > $necro);
        my $link =  $feed->link;
        # cosmetic fixes
        $link =~ s/^http:\/\///;
        $link =~ s/^www\.//;
        $link =~ s/\/$//;
        my $title = $entry->title;
        my $dd = $date->strftime("%F");
        my $dt = $date->strftime("%T");

        $sql = "insert or replace into headlines values(?, ?, ?, ?)";
        my $sth = $dbh->prepare( $sql );
        $sth->execute( $dd, $dt, $link, $title );
    }
}

# this hack is so dirty... FIXME later
$dbh->do("delete from system");
$dbh->do("insert into system values ('$now')");

$dbh->disconnect();
