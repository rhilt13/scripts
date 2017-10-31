#!/usr/bin/perl -w

#use strict;
use warnings;

use HTML::TreeBuilder;
use Data::Dumper;
use Scalar::Util qw/reftype/;

my $html  = HTML::TreeBuilder->new;
my $root  = $html->parse_file($ARGV[0]);


print extract_html_text($root);
 sub extract_html_text
  {
    HTML::TreeBuilder->new_from_content($_[0])->as_text
  }

=ccc
## Use this line to print everything stored from the HTML file
#print Dumper(\%{$root});

my $head  = $root->find( 'head' );
my $title = $head->find( 'title' );

my $body  = $root->find( 'body' );
my $content  = ${$body}{_content};

#if (my $title_text =eval{$title->content_array_ref->[0]}){
#	print "Title is [$title_text]\n";
#}

my @queue = ( $root->elementify );
my @links = ();
my @head3 = ();
my @selected = ();

my %tags = qw(
	h3    td
	a     href
#	);
#	img   src
#	frame src
#	);

while( my $element = shift @queue ){	
	foreach ( $element->content_list ){
		## Use this line to print everything stored from the HTML file
		print Dumper(%{$_});
#		print $_->tag."\t";
#		print @{$_->content};
#		print "\n";
		if( not ref $_){ 
			1;
#		}elsif( $_->tag eq 'a' ){
#			push @links, $_->attr( 'href' );
		}elsif( $_->tag eq 'tr' ){
			push @head3, $_->attr( 'href' );			
		}elsif( exists $tags{ $_->tag } ){
			my $tag = $_->tag;
			print $_->tag."\t";
			foreach $elem(@{$_->content}){
				if (reftype($elem) eq 'HASH'){
					foreach $key(%{$elem}){
						print "$key,";
					}
				}
				print "$elem\t";
			}
			print "\n";
			push @selected, $_->attr( $tags{$tag} );
		}else{
## Uncomment line below to see which tags are available.
#			printf "Tag was %s\n", $_->tag;
			push @queue, $_;
		}			
	}
}

#print @selected;
