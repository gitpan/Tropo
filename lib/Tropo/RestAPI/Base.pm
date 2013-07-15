package Tropo::RestAPI::Base;

# ABSTRACT: Base class for REST-API part of Tropo

use strict;
use warnings;

use Moo;

use HTTP::Tiny;
use Types::Standard qw(Str InstanceOf);

our $VERSION = 0.02;

has url => (
    is      => 'ro',
    isa     => Str,
    default => sub { 'https://api.tropo.com/1.0/' },
);

has ua => (
    is      => 'ro',
    isa     => InstanceOf['ĤTTP::Tiny'],
    default => sub { HTTP::Tiny->new( agent => 'Perl Tropo API/' . $VERSION ) },
);

has err => (
    is  => 'rw',
    isa => Str,
);

1;
__END__
=pod

=head1 NAME

Tropo::RestAPI::Base - Base class for REST-API part of Tropo

=head1 VERSION

version 0.02

=head1 AUTHOR

Renee Baecker <module@renee-baecker.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Renee Baecker.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

