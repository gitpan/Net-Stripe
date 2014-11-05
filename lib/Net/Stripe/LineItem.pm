package Net::Stripe::LineItem;
$Net::Stripe::LineItem::VERSION = '0.19';
use Moose;

# ABSTRACT: represent an Line Item object from Stripe

has 'id'                => (is => 'ro', isa => 'Maybe[Str]');
has 'livemode'          => (is => 'ro', isa => 'Maybe[Bool]');
has 'amount'            => (is => 'ro', isa => 'Maybe[Int]');
has 'currency'          => (is => 'ro', isa => 'Maybe[Str]');
has 'period'            => (is => 'ro', isa => 'Maybe[HashRef]');
has 'proration'         => (is => 'ro', isa => 'Maybe[Bool]');
has 'type'              => (is => 'ro', isa => 'Maybe[Str]');
has 'description'       => (is => 'ro', isa => 'Maybe[Str]');
has 'metadata'          => (is => 'ro', isa => 'Maybe[HashRef]');
has 'plan'              => (is => 'ro', isa => 'Maybe[Net::Stripe::Plan]');
has 'quantity'          => (is => 'ro', isa => 'Maybe[Int]');

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::LineItem - represent an Line Item object from Stripe

=head1 VERSION

version 0.19

=head1 ATTRIBUTES

=head2 amount

Reader: amount

Type: Maybe[Int]

=head2 currency

Reader: currency

Type: Maybe[Str]

=head2 description

Reader: description

Type: Maybe[Str]

=head2 id

Reader: id

Type: Maybe[Str]

=head2 livemode

Reader: livemode

Type: Maybe[Bool]

=head2 metadata

Reader: metadata

Type: Maybe[HashRef]

=head2 period

Reader: period

Type: Maybe[HashRef]

=head2 plan

Reader: plan

Type: Maybe[Net::Stripe::Plan]

=head2 proration

Reader: proration

Type: Maybe[Bool]

=head2 quantity

Reader: quantity

Type: Maybe[Int]

=head2 type

Reader: type

Type: Maybe[Str]

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
