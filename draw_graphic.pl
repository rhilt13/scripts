#! /usr/bin/env perl

use GD;
my $im = new GD::Image(2500, 3000);

open PICFILE, ">map1.png" or die "Couldn't open image file\n";
Graphics();
close PICFILE;

sub Graphics{
# define colors
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0, 0, 0);
my $red = $im->colorAllocate(255, 0, 0);
my $blue = $im->colorAllocate(0, 0, 255);
my $green = $im->colorAllocate(50, 200, 0);

# set background and interlacing 
$im->transparent($white);
$im->interlaced('true');

# border 
$im->rectangle(1, 1, 2999, 2400, $black);

$im->line(50, 3620, 650, 3620, $black);
$im->string(gdMediumBoldFont, 325, 3645, "-log e-value", $black);
my $x_ori = 50;
my $px_per_unit = 600/200;

for (my $i=0; $i<21; $i++){
        my $val = $i*10;
        my $pos = ($val*$px_per_unit)+$x_ori;
        $im->line($pos, 3615, $pos, 3625, $black);
        if (($val/10)%2 == 0){
                $im->string(gdSmallFont, $pos, 3626, "$val", $black);
        }
}
my %y_pos;
foreach my $key(sort keys %plot){
        $y_pos{$plot{$key}} = 3611;
}
foreach my $key(sort keys %plot){
        my $val = $plot{$key};
        my $pos = ($val*$px_per_unit)+$x_ori;
        $im->arc($pos, $y_pos{$plot{$key}}, 2, 2, 0, 360, $red);
        $y_pos{$plot{$key}} -= 5;
}

binmode PICFILE;
print PICFILE $im->png;
close PICFILE;

}