package Tropo;

# ABSTRACT: Use the TropoAPI via Perl

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef);
use Path::Tiny;
use JSON;

use overload '""' => \&json;

our $VERSION = 0.13;

has objects => (
    is      => 'rw',
    isa     => ArrayRef,
    default => sub { [] },
);

for my $subname ( qw(call say) ) {
    my $name     = ucfirst $subname;
    my @parts    = qw/Tropo WebAPI/;
    
    my $filename = path( @parts, $name . '.pm' );
    require $filename;
    
    my $module = join '::', @parts, $name;
    
    no strict 'refs';
    
    *{"Tropo::$subname"} = sub {
        my ($tropo,@params) = @_;
        
        my $obj = $module->new( @params );
        $tropo->add_object( { $subname => $obj } );
    };
}

sub perl {
    my ($self) = @_;
    
    my @objects;
    my $last_type = '';
    
    for my $index ( 0 .. $#{ $self->objects } ) {
        my $object      = $self->objects->[$index];
        my $next_object = $self->objects->[$index+1];

        my ($type,$obj) = %{ $object };
        my ($next_type) = %{ $next_object || { '' => ''} };
        
        if ( $type ne $last_type && $type eq $next_type ) {
            push @objects, { $type => [ $obj->to_hash ] };
        }
        elsif ( $type ne $last_type && $type ne $next_type ) {
            push @objects, { $type => $obj->to_hash };
        }
        else {
            push @{ $objects[-1]->{$type} }, $obj->to_hash;
        }

        $last_type = $type;
    }
    
    my $data = {
        tropo => \@objects,
    };
    
    return $data;
}

sub json {
    my ($self) = @_;
    
    my $data   = $self->perl;
    my $string = JSON->new->encode( $data );
    
    return $string;
}

sub add_object {
    my ($self, $object) = @_;
    
    return if !$object;
    
    push @{ $self->{objects} }, $object;
}

1;

__END__

=pod

=head1 NAME

Tropo - Use the TropoAPI via Perl

=head1 VERSION

version 0.13

=head1 SYNOPSIS

Ask the 

  my $tropo = Tropo->new;
  $tropo->call(
    to => $clients_phone_number,
  );
  $tropo->say( 'hello ' . $client_name );
  $tropo->json;

Creates this JSON output:

  {
      "tropo":[
          {
              "call": [
                  {
                      "to":"+14155550100"
                  }
              ]
          },
          {
              "say": [
                  {
                      "value":"Tag, you're it!"
                  }
              ]
          }
      ]
  }

=head1 DESCRIPTION

=head1 HOW THE TROPO API WORKS

=head1 AUTHOR

Renee Baecker <module@renee-baecker.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Renee Baecker.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
