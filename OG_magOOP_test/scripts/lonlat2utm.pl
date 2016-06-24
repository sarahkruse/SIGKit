
#-l[p|P|=|e|u|d]id
#              List  projection identifiers with -l, -lp
#              or -lP (expanded) that  can  be  selected
#              with   +proj.    -l=id   gives   expanded
#              description  of  projection   id.    List
#              ellipsoid  identifiers with -le, that can
#              be selected  with  +ellps,  -lu  list  of
#              cartesian  to  meter  conversion  factors
#              that can be selected with +units  or  -ld
#              list  of datums that can be selected with
#              +datum.
my $zone;
if (@ARGV < 1) {
	print "USAGE: perl lonlat2utm.pl utm_zone#\n";
	exit;
}

$zone = $ARGV[1];

system "proj +ellps=WGS84 +datum=WGS84  +proj=utm +zone=$zone -f %.0f $ARGV[0]";
#> $ARGV[0].z$zone.utm
