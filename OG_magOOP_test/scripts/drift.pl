open(MAG, $ARGV[0]) || die "Cannot open <$ARGV[0]> for input: [$@]";
open(DRIFT, $ARGV[1]) || die "Cannot open <$ARGV[1]> for input: [$@]";

$i = 0;
$mag_line = 0;
$drift_line = 0;
$drift_time = 0;
   
$line = <DRIFT> or die "No more drift lines";
$drift_line++;
($mmddyy_drift, $hhmmss_drift, $drift) = split " ", $line;
($dr_hr, $dr_min, $dr_sec) = split(':', $hhmmss_drift);

while (<MAG>) {
	$mag_line++;
	($mag_time, $mag, $hhmmss_mag, $mmddyy_mag) = split " ";
	($mag_hr, $mag_min, $mag_sec) = split(':', $hhmmss_mag);

    # IF the hours do not match, keep reading drift lines
    while ($mag_hr > $dr_hr) {
    	#print stderr "HOURS $mag_hr:$dr_hr\n";
		$line = <DRIFT> or die "No more drift lines for input";
   		$drift_line++;
		($mmddyy_drift, $hhmmss_drift, $drift) = split " ", $line;
		($dr_hr, $dr_min, $dr_sec) = split(':', $hhmmss_drift);
    }  
    # Hours match, check minutes    
    
    # If the minutes do not match, keep reading drift lines

    while ($mag_min > $dr_min) {
    	#print stderr "MIN $mag_min:$dr_min\n";
		$line = <DRIFT> or die "No more drift lines for input";
   		$drift_line++;
		($mmddyy_drift, $hhmmss_drift, $drift) = split " ", $line;
		($dr_hr, $dr_min, $dr_sec) = split(':', $hhmmss_drift);
    }
    if ($mag_hr == $dr_hr && $mag_min == $dr_min) {	
    
    	#Minutes and hours match
    	$corrected = $mag + $drift;	
    	print "$mag_time $corrected $mag $drift $hhmmss_mag $mmddyy_mag\n";
	
    }
}
 
print stderr "DRIFT lines read = $drift_line\nMAG lines read = $mag_line\n";
close MAG;
close DRIFT;

