open(MAG, $ARGV[0]) || die "Cannot open <$ARGV[0]> for input: [$@]";
open(GPS, $ARGV[1]) || die "Cannot open <$ARGV[1]> for input: [$@]";
open(LOG, ">log") || die "Cannot open <log> for input: [$@]";
$i = 0;
$mag_line = 0;
$gps_line = 0;
$gps_time = 0;
    
OUTER: while (<MAG>) { # Read MAG line
  $mag_line++;
  # $mag_time $corrected $mag $drift $hhmmss_mag $mmddyy_mag
  ($mag_time, $mag_dc, $mag_o, $drift, $hhmmss_mag, $mmddyy) = split " ", $_;
   $line = <GPS> || last OUTER; #die "No more gps lines for input";
   $gps_line++;
   # $d_hour, $ddeg_lat, $ddeg_lon, $hhmmss   
   ($gps_time, $lat, $lon, $hhmmss_gps) = split " ", $line;
  
  while ($gps_time < $mag_time) {
  printf LOG "%.15f %.15f %.3f %f %f (gpsT < magT)\n", $lon, $lat, $mag_dc, $gps_time, $mag_time;
  	$line = <GPS> || last OUTER; #die "No more gps lines for input";
   	$gps_line++;
   	# $d_hour, $ddeg_lat, $ddeg_lon, $hhmmss
   ($gps_time, $lat, $lon, $hhmmss_gps) = split " ", $line;
  }

  
  
  while ($gps_time > $mag_time) { # Read another MAG line
  		printf LOG "%.15f %.15f %.3f %f %f (gpsT > magT)\n", $lon, $lat, $mag_dc, $gps_time, $mag_time;
        $line = <MAG> || last OUTER; 
        #die "No more mag lines for input";
        $mag_line++;
        # $mag_time $corrected $mag $drift $hhmmss_mag $mmddyy_mag
        ($mag_time, $mag_c, $mag_o, $drift, $hhmmss_mag, $mmddyy) = split " ", $line;
  }
    
  if (($gps_time - $mag_time) == 0) {   	
      $i++;	
      printf "%.15f %.15f %.3f %.3f %f %s %s %f\n", $lon, $lat, $mag_dc, $mag_o, $drift, $mmddyy, $hhmmss_mag, $mag_time;
      next OUTER;  
      } 
      else { 
      	printf LOG "%.15f %.15f %.3f %f %f\n", $lon, $lat, $mag_dc, $gps_time, $mag_time;
      } 

}
printf stderr "Total lines processed = $i\nGPS lines read = $gps_line\nMAG lines read = $mag_line\n";
close MAG;
close GPS;

