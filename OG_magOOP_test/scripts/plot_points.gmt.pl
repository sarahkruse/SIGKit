$in = $ARGV[0];
$out = $in.eps;

open IN, "<$in" or die "$!";
open OUT, ">data" or die "$!";
@line = <IN>;
$nl = @line;
$minm = $mine = $minn = 10e9;
$maxm = $maxe = $maxn = 0;
foreach (@line) {
	($ea, $no, $mag, $ht) = split " ";
	if ($mag > $maxm) {$maxm = $mag;}
	if ($mag < $minm) {$minm = $mag;}
	if ($ea < $mine) {$mine = $ea;}
	if ($ea > $maxe) {$maxe = $ea;}
	if ($no < $minn) {$minn = $no;}
	if ($no > $maxn) {$maxn = $no;}
	$new_mag = $mag/200000;
	print OUT "$ea $no $mag $new_mag \n"; 
}
print stderr "Number of lines read=$nl\n";
$xtick = "a".int(($maxe-$mine)/10)."g".int(($maxe-$mine)/10);
$ytick = "a".int(($maxn-$minn)/10)."g".int(($maxn-$minn)/10);


$cint = 100;
`gmt makecpt -Chaxby -Di -T$minm/$maxm/$cint -V > colors.cpt`;

`gmt psbasemap --MAP_FRAME_TYPE=plain --MAP_GRID_PEN_PRIMARY=0.5p,200 --FONT_ANNOT_PRIMARY=8p --FONT_LABEL=10p -JX6i -R$mine/$maxe/$minn/$maxn -X1i -Y1i -B$xtick:'Easting (m)':/$ytick:'Northing (m)':/WSne -P -K -V > $out`;

`gmt psxy --FONT_ANNOT_PRIMARY=8p --FONT_ANNOT_SECONDARY=8p data -Sc2p -Ccolors.cpt \` minmax -I2 $in \` -JX -N -V -O -K >> $out`;

$scale_anot_int = $cint*2;
$scale_str = "a"."$scale_anot_int";
`gmt psscale --FONT_TITLE=8p --FONT_LABEL=8p --FONT_ANNOT_PRIMARY=7p -D3i/-0.6i/4i/0.1ih -Ccolors.cpt -B$scale_str/:'nT': -O -V >> $out`;

`gmt ps2raster $out -A -P -Tg`;
`rm colors.cpt data $out`;

