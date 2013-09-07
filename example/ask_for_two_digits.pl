#!/usr/bin/perl

use strict;
use warnings;

use Tropo;
use Data::Dumper;

    my $tropo      = Tropo->new;
    $tropo->say(
        'Willkommen bei WeekendsSale',
    );
    $tropo->ask( 
        'Bitte wählen geben Sie die Ziffer des Artikels ein', 
        choices => '[2 DIGITS]',
    );

    $tropo->on(
        event => 'continue',
        next  => 'http://localhost/continue',
    );

    $tropo->on(
        event => 'hangup',
        next  => 'http://localhost/hangup',
    );

    my $perl = $tropo->perl;

print Dumper $perl;
