package Net::Stripe::Customer;
use Moose;
use Kavorka;
use Net::Stripe::Plan;
use Net::Stripe::Token;
use Net::Stripe::Card;
use Net::Stripe::Discount;
use Net::Stripe::List;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a Customer object from Stripe

# Customer creation args
has 'email'       => (is => 'rw', isa => 'Maybe[Str]');
has 'description' => (is => 'rw', isa => 'Maybe[Str]');
has 'trial_end'   => (is => 'rw', isa => 'Maybe[Int|Str]');
has 'card'        => (is => 'rw', isa => 'Maybe[Net::Stripe::Token|Net::Stripe::Card|Str]');
has 'plan'        => (is => 'rw', isa => 'Maybe[Net::Stripe::Plan|Str]');
has 'coupon'      => (is => 'rw', isa => 'Maybe[Net::Stripe::Coupon|Str]');
has 'discount'    => (is => 'rw', isa => 'Maybe[Net::Stripe::Discount]');
has 'metadata'    => (is => 'rw', isa => 'Maybe[HashRef]');
has 'cards'       => (is => 'ro', isa => 'Net::Stripe::List');

# API object args
has 'id'           => (is => 'ro', isa => 'Maybe[Str]');
has 'deleted'      => (is => 'ro', isa => 'Maybe[Bool|Object]', default => 0);
has 'default_card' => (is => 'ro', isa => 'Maybe[Net::Stripe::Token|Net::Stripe::Card|Str]');
has 'subscriptions' => (is => 'ro', isa => 'Net::Stripe::List');
has 'subscription' => (is => 'ro',
                       lazy => 1,
                       builder => '_build_subscription');

sub _build_subscription {
    my $self = shift;
    return $self->subscriptions->get(0);
}

method form_fields {
    return (
        (($self->card && ref($self->card) eq 'Net::Stripe::Token') ?
            (card => $self->card->id) : $self->fields_for('card')),
        $self->fields_for('plan'),
        $self->fields_for('coupon'),
        $self->form_fields_for_metadata(),
        map { ($_ => $self->$_) }
            grep { defined $self->$_ } qw/email description trial_end/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Customer - represent a Customer object from Stripe

=head1 VERSION

version 0.16

=head1 ATTRIBUTES

=head2 card

Reader: card

Writer: card

Type: Maybe[Net::Stripe::Card|Net::Stripe::Token|Str]

=head2 cards

Reader: cards

Type: Net::Stripe::List

=head2 coupon

Reader: coupon

Writer: coupon

Type: Maybe[Net::Stripe::Coupon|Str]

=head2 default_card

Reader: default_card

Type: Maybe[Net::Stripe::Card|Net::Stripe::Token|Str]

=head2 deleted

Reader: deleted

Type: Maybe[Bool|Object]

=head2 description

Reader: description

Writer: description

Type: Maybe[Str]

=head2 discount

Reader: discount

Writer: discount

Type: Maybe[Net::Stripe::Discount]

=head2 email

Reader: email

Writer: email

Type: Maybe[Str]

=head2 id

Reader: id

Type: Maybe[Str]

=head2 metadata

Reader: metadata

Writer: metadata

Type: Maybe[HashRef]

=head2 plan

Reader: plan

Writer: plan

Type: Maybe[Net::Stripe::Plan|Str]

=head2 subscription

Reader: subscription

=head2 subscriptions

Reader: subscriptions

Type: Net::Stripe::List

=head2 trial_end

Reader: trial_end

Writer: trial_end

Type: Maybe[Int|Str]

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
