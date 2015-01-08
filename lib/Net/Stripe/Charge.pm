package Net::Stripe::Charge;
$Net::Stripe::Charge::VERSION = '0.23';
use Moose;
use Kavorka;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent an Charge object from Stripe

has 'id'                  => (is => 'ro', isa => 'Maybe[Str]');
has 'created'             => (is => 'ro', isa => 'Maybe[Int]');
has 'amount'              => (is => 'ro', isa => 'Maybe[Int]', required => 1);
has 'currency'            => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'customer'            => (is => 'ro', isa => 'Maybe[Str]');
has 'card'                => (is => 'ro', isa => 'Maybe[Net::Stripe::Token|Net::Stripe::Card|Str]');
has 'description'         => (is => 'ro', isa => 'Maybe[Str]');
has 'livemode'            => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'paid'                => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'refunded'            => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'amount_refunded'     => (is => 'ro', isa => 'Maybe[Int]');
has 'captured'            => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'balance_transaction' => (is => 'ro', isa => 'Maybe[Str]');
has 'failure_message'     => (is => 'ro', isa => 'Maybe[Str]');
has 'failure_code'        => (is => 'ro', isa => 'Maybe[Str]');
has 'application_fee'     => (is => 'ro', isa => 'Maybe[Int]');

method form_fields {
    return (
        $self->fields_for('card'),
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                qw/amount currency customer description application_fee/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Charge - represent an Charge object from Stripe

=head1 VERSION

version 0.23

=head1 ATTRIBUTES

=head2 amount

Reader: amount

Type: Maybe[Int]

This attribute is required.

=head2 amount_refunded

Reader: amount_refunded

Type: Maybe[Int]

=head2 application_fee

Reader: application_fee

Type: Maybe[Int]

=head2 balance_transaction

Reader: balance_transaction

Type: Maybe[Str]

=head2 captured

Reader: captured

Type: Maybe[Bool|Object]

=head2 card

Reader: card

Type: Maybe[Net::Stripe::Card|Net::Stripe::Token|Str]

=head2 created

Reader: created

Type: Maybe[Int]

=head2 currency

Reader: currency

Type: Maybe[Str]

This attribute is required.

=head2 customer

Reader: customer

Type: Maybe[Str]

=head2 description

Reader: description

Type: Maybe[Str]

=head2 failure_code

Reader: failure_code

Type: Maybe[Str]

=head2 failure_message

Reader: failure_message

Type: Maybe[Str]

=head2 id

Reader: id

Type: Maybe[Str]

=head2 livemode

Reader: livemode

Type: Maybe[Bool|Object]

=head2 paid

Reader: paid

Type: Maybe[Bool|Object]

=head2 refunded

Reader: refunded

Type: Maybe[Bool|Object]

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
