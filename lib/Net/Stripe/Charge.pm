package Net::Stripe::Charge;
use Moose;
use methods;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent an Charge object from Stripe

has 'id'                  => (is => 'ro', isa => 'Maybe[Str]');
has 'created'             => (is => 'ro', isa => 'Maybe[Int]');
has 'amount'              => (is => 'ro', isa => 'Maybe[Int]', required => 1);
has 'currency'            => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'customer'            => (is => 'ro', isa => 'Maybe[Str]');
has 'card'                => (is => 'ro', isa => 'Maybe[StripeCard]');
has 'description'         => (is => 'ro', isa => 'Maybe[Str]');
has 'livemode'            => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'paid'                => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'refunded'            => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'amount_refunded'     => (is => 'ro', isa => 'Maybe[Int]');
has 'captured'            => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'balance_transaction' => (is => 'ro', isa => 'Maybe[Str]');
has 'failure_message'     => (is => 'ro', isa => 'Maybe[Str]');
has 'failure_code'        => (is => 'ro', isa => 'Maybe[Str]');


method form_fields {
    return (
        $self->fields_for('card'),
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                qw/amount currency customer description/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Charge - represent an Charge object from Stripe

=head1 VERSION

version 0.11

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
