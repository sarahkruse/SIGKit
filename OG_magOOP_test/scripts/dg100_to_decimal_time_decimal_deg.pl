# GlobalSat format for position:
# ddmm.mmmmm (lat)
# +dddmm.mmmmm

<>;
while (<>) {
  # Read line of data	
  ($id, $date, $hhmmss, $lat_str, $lon_str, $speed, $ht) = split ",", $_;
  
  # Process time to decimal hours
  #($date, $hhmmss) = split " ", $datetime;
  ($hh, $mm, $ss) = split ":", $hhmmss;
  $d_hour = ($hh*3600 + $mm*60 +$ss)/3600;
  #print "$d_hour, $hhmmss\n";

  # Process latitude to decimal degrees
  #print "$lat_str\n";
  $tmp_str = ($lat_str/100.0);
  $deg_lat = int($tmp_str);
  
  $min_lat = $lat_str - $deg_lat*100; 
  #print stderr "$lat_str: $deg_lat, $min_lat\n";
  #$deg_lat = substr($lat_str, 0, 2);
  #$min_lat = substr($lat_str, 2);
  $ddeg_lat = $deg_lat + ($min_lat/60);
  #print stderr "$ddeg_lat\n";

  # Process longitude to decimal degrees
  #$lon /= 100.0;
  $tmp_str = ($lon_str/100.0);
  $deg_lon = int($tmp_str);
  $min_lon = $lon_str - $deg_lon*100;
  #print stderr "$lon_str: $deg_lon, $min_lon\n";
  #$deg_lon = substr($lon_str, 0, 4);
  #$min_lon = substr($lon_str, 4);
  $ddeg_lon = $deg_lon + ($min_lon/60);
  #print stderr "$ddeg_lon = \n";
  printf "%.4f %.15f %.15f %s\n", $d_hour, $ddeg_lat, $ddeg_lon, $hhmmss ;
}
