# if there are no command line arguments (i.e. filenames)
if (@ARGV < 1) {
	print "USAGE: perl filter_mag.pl input_filename slope igrf_val > output_filename\n";
	exit;
}

open(MAG, $ARGV[0]) || die "Cannot open <$ARGV[0]> for input: [$@]";
@LINES = <MAG>;

($eref, $nref, $magref ) = split " ", $LINES[0];
print stderr "$eref, $nref, $magref\n";
print stderr "$ARGV[1] $ARGV[2]\n";
$igrf = $ARGV[2];
$i = 1;

foreach my $line (@LINES) {
  #$lon, $lat, $mag_dc, $mag_o, $drift, $mmddyy, $hhmmss_mag, $mag_time;
  ($e, $n, $mag_dc, $mag_o, $drift, $mmddyy, $hhmmss, $mag_time ) = split " ", $line;
  $mag_a = $mag_dc-$igrf;
  $d=((($e-$eref)**2+($n-$nref)**2)**(0.5)+0.001);
  $s=abs(($mag_a-$magref)/$d);
  if ($s <= $ARGV[1]) {
  printf "%.0f %.0f %.3f %.3f %.3f %.3f %s %s %.4f\n", $e, $n, $mag_a, $mag_o, $mag_dc, $drift, $mmddyy, $hhmmss, $mag_time;
    #printf "$e $n $mag_a $mag_o $mag_dc $drift $mmddyy $hhmmss $mag_time\n";
    $eref=$e;
    $nref=$n;
    $magref=$mag_a;
  }
  else {
       #print stderr "$s\n";
       #print stderr "$eref, $nref, $magref, $elref\n";
  	$i++;
  }

}
print stderr "Removed $i lines\n";
