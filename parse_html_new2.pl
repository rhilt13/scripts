#! /usr/bin/perl -w

use HTML::TreeBuilder::XPath;
use Text::Table;
use Data::Dumper;
 
#my $tree = HTML::TreeBuilder::XPath->new;
my $toc_table = Text::Table->new('Entry', 'Link');
 
#$tree->parse_file($ARGV[0]);

my $tree = HTML::TreeBuilder::XPath->new_from_file( $ARGV[0] );
#print $tree->findvalue( '//pre/text()' );

for my $section ($tree->findnodes(q{/html/body/table/tr/td})){
#for my $section ($tree->findnodes(q{/html/body/table})){
#	print Dumper(\%{$section});
	$sel = $section->findnodes(q{/div/form});
	print ref($sel);
	print $sel;
#	if ($sel = $section->findnodes(q{/div/form})){
#		print $sel;
#	}
#	print Dumper(\%{$sel});
#	print $sel1;
#	$sel = $x->findvalue(q{//div[@id="homologousGeneDiv"]});
}
#print $tree->findnodes('h3');

=ccc
for my $result ($tree->findnodes(q{/html/body/div/h3})) {
    my $x = HTML::TreeBuilder::XPath->new;
        $x->parse($result->as_HTML);
	print Dumper(\%{$x});
    print "<br>".("-" x 17)."<br>";

}
#=ccc 
my @toc = $tree->findnodes('//table[@id="bookmark"]/tbody/*/*/*//li/a');
for my $el ( @toc ) {
    $toc_table->add(
        $el->as_trimmed_text,
        $el->attr('href'),
    );
}
 
print $toc_table;
=cut
