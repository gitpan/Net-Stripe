package Net::Stripe::Discount;
use Moose;
use Moose::Util::TypeConstraints;
use methods;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a Discount object from Stripe

has 'coupon' => (is => 'rw', isa => 'Maybe[Net::Stripe::Coupon]');

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Discount - represent a Discount object from Stripe

=head1 VERSION

version 0.11

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
