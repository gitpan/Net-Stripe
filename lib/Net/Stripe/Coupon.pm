package Net::Stripe::Coupon;
use Moose;
use Moose::Util::TypeConstraints;
use methods;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a Coupon object from Stripe

union 'StripeCoupon', ['Str', 'Net::Stripe::Coupon'];

has 'id'                 => (is => 'rw', isa => 'Maybe[Str]');
has 'percent_off'        => (is => 'rw', isa => 'Maybe[Int]', required => 1);
has 'duration'           => (is => 'rw', isa => 'Maybe[Str]', required => 1);
has 'duration_in_months' => (is => 'rw', isa => 'Maybe[Int]');
has 'max_redemptions'    => (is => 'rw', isa => 'Maybe[Int]');
has 'redeem_by'          => (is => 'rw', isa => 'Maybe[Int]');

method form_fields {
    return (
        map { ($_ => $self->$_) }
            grep { defined $self->$_ }
                qw/id percent_off duration duration_in_months 
                   max_redemptions redeem_by/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Coupon - represent a Coupon object from Stripe

=head1 VERSION

version 0.11

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
