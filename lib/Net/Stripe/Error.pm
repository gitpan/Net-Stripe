package Net::Stripe::Error;
$Net::Stripe::Error::VERSION = '0.17';
use Moose;
with 'Throwable';
use namespace::clean -except => 'meta';

# ABSTRACT: represent an error result from interacting with Stripe

has 'type'    => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'message' => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'code'    => (is => 'ro', isa => 'Maybe[Str]');
has 'param'   => (is => 'ro', isa => 'Maybe[Str]');

use overload fallback => 1,
    '""' => sub {
        my $e = shift;
        my $msg = "Error: @{[$e->type]} - @{[$e->message]}";
        $msg .= " On parameter: " . $e->param if $e->param;
        $msg .= "\nCard error: " . $e->code   if $e->code;
        return $msg;
    };

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Error - represent an error result from interacting with Stripe

=head1 VERSION

version 0.17

=head1 ATTRIBUTES

=head2 code

Reader: code

Type: Maybe[Str]

=head2 message

Reader: message

Type: Maybe[Str]

This attribute is required.

=head2 param

Reader: param

Type: Maybe[Str]

=head2 previous_exception

Reader: previous_exception

=head2 type

Reader: type

Type: Maybe[Str]

This attribute is required.

=head1 AUTHORS

=over 4

=item *

Luke Closs

=item *

Rusty Conover

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Prime Radiant, Inc., (c) copyright 2014 Lucky Dinosaur LLC..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
