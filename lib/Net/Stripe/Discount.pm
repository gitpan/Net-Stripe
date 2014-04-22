package Net::Stripe::Discount;
use Moose;
use Moose::Util::TypeConstraints;
use methods;
extends 'Net::Stripe::Resource';

has 'coupon' => (is => 'rw', isa => 'Maybe[Net::Stripe::Coupon]');



__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=cut
