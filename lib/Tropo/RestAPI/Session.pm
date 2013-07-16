package Tropo::RestAPI::Session;

# ABSTRACT: Tropo session handling

use strict;
use warnings;

use Moo;
use XML::Simple;

extends 'Tropo::RestAPI::Base';

our $VERSION = 0.04;

sub create {
    my ($self, %param) = @_;
    
    if ( !defined $param{token} ) {
        return;
    }
    
    $param{action} = 'create';
    
    my $session_url = $self->url . 'sessions';
    my $response    = $self->get(
        $session_url,
        \%param,
    );
    
    if ( !$response ) {
        $self->err( 'Cannot connect to ' . $session_url );
        return;
    }
    
    if ( !$response->{success} ) {
        $self->err( $response->{reason} . ': ' . $response->{content} );
        return;
    }
    
    my $data = XMLin( $response->{content} );
    
    if ( $data->{success} ne 'true' ) {
        $self->err( 'Tropo session launch failed!' );
        return;
    }
    
    return $data;
}


1;
__END__
=pod

=head1 NAME

Tropo::RestAPI::Session - Tropo session handling

=head1 VERSION

version 0.06

=head1 SYNOPSIS

    use Tropo::RestAPI::Session;
    
    my $session_object = Tropo::RestAPI::Session->new;
    my $tropo_session  = $session_object->create(
        token => $token,
        # more optional params
    ) or die $session_object->err;

=head1 AUTHOR

Renee Baecker <module@renee-baecker.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Renee Baecker.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

