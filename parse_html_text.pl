#!/usr/bin/perl 

BEGIN {
    $|  = 1;
    $^W = 1;
}

use strict;
use autodie;
use warnings;
use HTML::TreeBuilder;
use HTML::FormatText;

my $html = shift @ARGV;

my $tree = HTML::TreeBuilder->new->parse_file($html);

my $formatter = HTML::FormatText->format_file(
    $html,
    leftmargin  => 0,
    rightmargin => 50,
);
print $formatter;
