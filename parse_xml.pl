#! /usr/bin/perl -w 

package Study;

use strict;
use warnings;

use XML::Rabbit::Root;

has_xpath_value variation_name      => './variation/name';
has_xpath_value gene_name             => './variation/gene';
has_xpath_value strain_name      => './variation/strain/name';
has_xpath_value strain_genotype => './variation/strain/genotype';

has_xpath_object_list contacts  => './overall_contact|./overall_contact_backup'
                                => 'Study::Contact';

finalize_class();

package Study::Contact;

use strict;
use warnings;
use XML::Rabbit;

has_xpath_value email     => './email';
has_xpath_value last_name => './last_name';
has_xpath_value role      => './role';

finalize_class();

1;