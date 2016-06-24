################################################################
# STEP 1: Edit the values within this box to direct the script
# to process a single day of magnetometer and GPS data
# ------------------------------------------------------------

# Data INPUT and OUTPUT directory name 
# (This the date of the survey)
# Don't use spaces! The 'b' indicates
# a second instrument. 
$date = "03262014a";

#GPS Model: choose either: DG100 or DG200
$gps_model = "DG100";

# GPS data directory (path name)
$gps_dir = "gpsDG100";

# MAG data directory (path name)
$mag_dir = "mag858";

# Drift file
$drift_file = "drift/03262014.dft";

# Hour correction for mag858 (add this time to mag data)
$hour = 0;

# UTM zone of survey
$utm_zone = 11;

# nT values (low high) for initial filtering of magnetic data
$slope = 75;
$igrf = 49083.5;

####################################################################

####################################################################
# STEP 2: run the PERL script by typing on the command line:
# perl run-mmddyyyy.pl
# The outputs will be put in the directory/folder specified above,
# by the variable, $date
# The final data file will have the final file extension:  .F
# Each days data should be concatenated (cat) into one complete
# dataset after all of the days are processed. 
#################################################################### 

system "date";
if (! -d $date) {mkdir($date);} 
# Changes the format of the GlobalSat GPS data to decimal time and decimal degrees 
$func = ($gps_model =~ m/DG100/) ? "scripts/dg100_to_decimal_time_decimal_deg.pl"  : "scripts/dg200_to_decimal_time_decimal_deg.pl";
$directory = "$gps_dir/$date";
opendir (DIR, $directory) or die "$!";
while (my $file = readdir(DIR)) {
if ($file =~ /csv/) {
		$do = "perl $func $directory/$file > $date/$file.D";	
		print "$do\n";
		system $do;
	}
}
closedir(DIR);

# Changes the format of the 858mag time to decimal time 
$directory = "$mag_dir/$date";
opendir (DIR, $directory) or die $!;
while (my $file = readdir(DIR)) {
	if ($file =~ /stn/) {
		$do = "perl scripts/stn2decimal_time.pl $directory/$file $hour > $date/$file.D";
		print "$do\n";
		system $do;
	}
}
closedir(DIR);

# Reverses the sorted order of the mag data from descending to ascending time
opendir (DIR, $date) or die $!;
while (my $file = readdir(DIR)) {
	if ($file =~ /stn.D$/) {
		$do = "perl scripts/reverse.pl $date/$file > $date/$file.r";
		print "$do\n";
		system $do;
	}
}
closedir(DIR);

# Open the mag data file
# Correct the collected magentic data for drift
opendir (DIR, $date) or die $!;
while (my $file = readdir(DIR)) {
	if ($file =~ /stn.D.r$/) {
		$mag_file = $file;
		$do = "perl scripts/drift.pl $date/$mag_file $drift_file> $date/$file.dc";
		print "$do\n";
		system $do;
	}
}

# Open the GPS data files
opendir (DIR, $date) or die $!;
while (my $file = readdir(DIR)){
	if ($file =~ /csv.D$/) {
		$gps_file = $file;
		print "GPS file = $gps_file\n";
	}
}
closedir(DIR);

# Open the Mag data files
# Match the GPS data and the Mag data according to decimal time 
opendir (DIR, $date) or die $!;
while (my $file = readdir(DIR)) {
	if ($file =~ /stn.D.r.dc/) {
		$mag_file = $file;
		print "";
		$do = "perl scripts/match_mag_gps.pl $date/$mag_file $date/$gps_file >> $date/match_$date.xyz";
		print "$do\n";
		system $do;
	}
}
closedir(DIR);

# Convert longitude latitude to Easting and Northing (UTM)
opendir (DIR, $date) or die $!;
while (my $file = readdir(DIR)) {
	if ($file =~ /.xyz$/) {
		$do = "perl scripts/lonlat2utm.pl $date/$file $utm_zone > $date/$file.utm";
		print "$do\n";
		system $do;
		last;
	}
}
closedir(DIR);

# Filter out bad Mag data, slope is defined above
opendir (DIR, $date) or die $!;
while (my $file = readdir(DIR)) {
	if ($file =~ /.utm$/) {
		$do = "perl scripts/filter_mag.pl $date/$file $slope $igrf > $date/$file.F";
		print "$do\n";
		system $do;
		last;
	}
}	
closedir(DIR);

# These next two scripts use GMT version 5 to make plots
# Plot a histogram of the nT values and store in OUTPUT directory
#opendir (DIR, $date) or die $!;
#while (my $file = readdir(DIR)) {
#	if ($file =~ /.utm.F$/) {
#		$do = "perl scripts/histogram.gmt.pl $date/$file";
#		print "$do\n";
#		system $do;
#		last;
#	}
#}	
#closedir(DIR);

## Plot a color-coded map of the final collated data.
#opendir (DIR, $date) or die $!;
#while (my $file = readdir(DIR)) {
#	if ($file =~ /.utm.F$/) {
#		$do = "perl scripts/plot_points.gmt.pl $date/$file";
#		print "$do\n";
#		system $do;
#		last;
#	}
#}	
#closedir(DIR);
print "Done\n";
exit;

