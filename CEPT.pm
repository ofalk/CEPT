package CEPT;

use strict;
use warnings;

require LWP::UserAgent;
require Carp;
require Time::HiRes;
require JSON::XS;

use Carp qw/carp/;
use LWP::UserAgent;
use Time::HiRes qw/gettimeofday tv_interval/;
use JSON::XS;

require Exporter;

our @ISA = qw/Exporter/;
our %EXPORT_TAGS = ( 'all' => [ qw() ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

(our $VERSION) = '$Revision: 0.1 $' =~ /([\d.]+)/;

use constant DEFAULT_APIENDPOINT	=> 'http://api.cept.at/';
use constant DEFAULT_APIVERSION		=> 'v1';

our @methods = qw(similarterms similarterms-xl autocomplete term2bitmap bitmap2terms compare compare/img);

sub new {
	my $class = shift;
	my $args = shift;
	my $self = {};

	$self->{ua} = LWP::UserAgent->new;
	$self->{ua}->timeout(30);
	$self->{ua}->env_proxy;

	$self->{debug} = 1 if $args->{debug};

	die "No method given" unless $args->{method};
	$self->{method} = $args->{method};
	die "Unknown method: $self->{method}" unless (grep { $_ eq $self->{method} } @methods);

	die "No APPKEY" unless $args->{appkey};
	$self->{appkey} = $args->{appkey};

	die "No APPID" unless $args->{appid}; 
	$self->{appid} = $args->{appid};

	$self->{apiversion} = $args->{apiversion} || DEFAULT_APIVERSION;
	$self->{apiendpoint} = $args->{apiendpoint} || DEFAULT_APIENDPOINT;

	$self->{base_url} = $self->{apiendpoint} . $self->{apiversion} . "/" . $self->{method} . '?app_key=' . $self->{appkey} . '&app_id=' . $self->{appid};

	die "No term1" unless $args->{term1};
	$self->{term1} = lc($args->{term1});

	if($self->{method} eq 'image') {
		die "No term2" unless $args->{term2};
		$self->{term2} = lc($args->{term2});
		$self->{url} = $self->{base_url} . "&term1=$self->{term1}&term2=$self->{term2}";
	} elsif($self->{method} eq 'autocomplete') {
		$self->{url} = $self->{base_url} . "&prefix=" . $self->{term1};
	} else {
		$self->{url} = $self->{base_url} . "&term=" . $self->{term1};
	}
	$self->{url} .= "&rows=$args->{rows}" if $args->{rows};

	bless($self, $class);
	return $self;
}

sub run {
	my $self = shift;

	my $t0 = [gettimeofday];
	$self->{response} = $self->{ua}->get($self->{url});
	$self->{elapsed} = sprintf("%.2f", tv_interval($t0));
	if($self->{response}->is_success) {
		unless($self->{method} =~ /image/) {
			my $ref = decode_json($self->{response}->decoded_content);
			my $terms;
			if($ref->{similarterms}) {
				if(@{$ref->{similarterms}}) {
					$terms = $ref->{similarterms};
				}
			}
			if($ref->{contexts}) {
				if(@{$ref->{contexts}}) {
					$self->{contexts} = $ref->{contexts};
				}
			}
			if($ref->{completedTerms}) {
				$terms = $ref->{completedTerms};
			}
			if($terms) {
				carp scalar @{$terms} . " terms found. " if $self->{debug};
				$self->{terms} = $terms;
			} else {
				carp "no terms found. " if $self->{debug};
			}
		} else {
			# skip
		}
	} else {
		carp "$self->{url} returned an error" if $self->{debug};
	}
	return $self->{response};
}

1;

__END__

=head1 NAME

CEPT - CEPT API in Perl

=head1 SYNOPSIS

  use CEPT;

  use constant APPKEY     => 'someappkey'; # replace this
  use constant APPID      => 'someappid';  # replace this

  my $c = new CEPT({
    appkey  => APPKEY,
    appid   => APPID,
    method  => 'autocomplete',
    term1   => 'appl',
    rows    => 10,
  });
  $c->run();

  use Data::Dumper;

  print Dumper($c);

=head1 DESCRIPTION

Access the CEPT API via Perl.

=head2 EXPORT

None by default.

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
