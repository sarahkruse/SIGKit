
$in = $ARGV[0];
$out = $in."_histogram.eps";
open IN, "<$in" or die "$!";
@line = <IN>;
$nl = @line;
$minm = 10e6;
$maxm = 0;
foreach (@line) {
	($ea, $no, $mag, $ht) = split " ";
	if ($mag > $maxm) {$maxm = $mag;}
	if ($mag < $minm) {$minm = $mag;}
}
close IN;
$xtick = int(($maxm - $minm)/4);
$ytick = int($nl/10);
$nl = int($nl);
`gmt pshistogram --FONT_ANNOT_PRIMARY=8p --FONT_LABEL=10p $in -R$minm/$maxm/0/$nl -JX3i/4i -W100 -i2 -Lthinner -BWS -Bx+l"nT" -Bxa$tickf$xtick -By+l"Counts" -Bya$ytick -G200 -V -P > $out`;
system "ps2raster $out -A -P -Tg";
system "rm $out";

