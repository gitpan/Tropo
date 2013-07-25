#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use_ok( 'Tropo::RestAPI::Session' );

my $token = '1234';

my $session = Tropo::RestAPI::Session->new;
isa_ok $session, 'Tropo::RestAPI::Session';

my $result = $session->create;
ok !$result, 'Cannot create session - token missing';


$result = $session->create( token => $token );
ok !$result, 'Cannot create session - invalid token';
is $session->err, 'Tropo session launch failed!';

done_testing();