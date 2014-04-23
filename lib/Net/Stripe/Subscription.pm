package Net::Stripe::Subscription;
use Moose;
use methods;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a Subscription object from Stripe

has 'id' => (is => 'ro', isa => 'Maybe[Str]');
has 'plan' => (is => 'rw', isa => 'Maybe[StripePlan]');
has 'coupon'    => (is => 'rw', isa => 'Maybe[StripeCoupon]');
has 'prorate'   => (is => 'rw', isa => 'Maybe[Bool|Object]');
has 'card'      => (is => 'rw', isa => 'Maybe[StripeCard]');
has 'quantity'  => (is => 'rw', isa => 'Int', default => 1);

# Other fields returned by the API
has 'customer'             => (is => 'ro', isa => 'Maybe[Str]');
has 'status'               => (is => 'ro', isa => 'Maybe[Str]');
has 'start'                => (is => 'ro', isa => 'Maybe[Int]');
has 'canceled_at'          => (is => 'ro', isa => 'Maybe[Int]');
has 'ended_at'             => (is => 'ro', isa => 'Maybe[Int]');
has 'current_period_start' => (is => 'ro', isa => 'Maybe[Int]');
has 'current_period_end'   => (is => 'ro', isa => 'Maybe[Int]');
has 'trial_start'          => (is => 'ro', isa => 'Maybe[Str]');
has 'trial_end'            => (is => 'rw', isa => 'Maybe[Str|Int]');


method form_fields {
    return (
        $self->fields_for('card'),
        $self->fields_for('plan'),
        map { ($_ => $self->$_) }
            grep { defined $self->$_ } qw/coupon prorate trial_end quantity/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Subscription - represent a Subscription object from Stripe

=head1 VERSION

version 0.10

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
