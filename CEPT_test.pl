#!/usr/bin/perl

use strict;
use warnings;

use CEPT;
use YAML qw/LoadFile/;

use Getopt::Long;
Getopt::Long::Configure($_) foreach qw/bundling auto_version auto_help/;

my $config = LoadFile('CEPT.yml');

my($term1, $term2, $method);

my $rows = 50;

my $result = GetOptions(
	"term1|t1=s"		=> \$term1,
	"term2|t2=s"		=> \$term2,
	"method|m=s"		=> \$method,
	"rows|r=i"		=> \$rows,
);

my $c = new CEPT({
	appkey	=> $config->{appkey},
	appid	=> $config->{appid},
	method	=> $method,
	term1	=> $term1,
	term2	=> $term2,
	rows	=> $rows,
});
$c->run();

if($c->{terms}) {
	foreach(@{$c->{terms}}) {
		if(ref $_ eq 'HASH') {
			print "$_->{rank}: $_->{term} $_->{distance}\n";
		} else {
			print $_ . "\n";
		}
	}
}

1;

__END__

=head1 NAME

Blah

=head1 SYNOPSIS

Blah

=head1 DESCRIPTION

Blah

=head2 EXPORT

Blah

=head1 SEE ALSO

http://cept.at

=head1 AUTHOR

Oliver Falk, E<lt>oliver@linux-kernel.atE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Oliver Falk

This script is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
