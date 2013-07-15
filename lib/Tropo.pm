package Tropo;

# ABSTRACT: Use the TropoAPI via Perl

use strict;
use warnings;

use Moo;
use Types::Standard qw(ArrayRef);
use Path::Tiny;
use JSON;

use overload '""' => \&json;

our $VERSION = 0.05;

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

sub json {
    my ($self) = @_;
    
    my @objects;
    my $last_type = '';
    
    for my $object ( @{ $self->objects } ) {
        my ($type,$obj) = %{ $object };
        
        if ( $type ne $last_type ) {
            push @objects, { $type => [ $obj->to_hash ] };
        }
        else {
            push @{ $objects[-1]->{$type} }, $obj->to_hash;
        }
    }
    
    my $string = JSON->new->encode( { tropo => \@objects } );
    
    return $string;
}

sub add_object {
    my ($self, $object) = @_;
    
    return if !$object;
    
    push @{ $self->{objects} }, $object;
}

1;



=pod

=head1 NAME

Tropo - Use the TropoAPI via Perl

=head1 VERSION

version 0.05

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

=cut

=head1 AUTHOR

Renee Baecker <module@renee-baecker.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Renee Baecker.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


__END__
