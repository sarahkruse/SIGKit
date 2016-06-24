# stn2decimal_time.pl
# Changes time string from magnetometer to decimal hours

use POSIX qw(ceil);

my $hour = 0;
if (@ARGV > 0) {
	$hour = $ARGV[1];
	$minute = $ARGV[2];
	pop(@ARGV);
}
while (<>) {
  # Read line of data	  
  ($id, $mag, $nada1, $hhmmss, $date, $nada2) = split " ";
  # Only process lines starting with a 0
  if (!$id) {
    # Process time to decimal time	
    ($hh, $mm, $ss) = split ":", $hhmmss;
    $d_min = ($hh*3600 + $mm*60 + ceil($ss))/3600;
    $d_min += $hour;
    printf "%.4f %f %s %s\n",$d_min, $mag, $hhmmss, $date;
   }

}
