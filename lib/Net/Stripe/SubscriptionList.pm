package Net::Stripe::SubscriptionList;
$Net::Stripe::SubscriptionList::VERSION = '0.22';
use Moose;
use Kavorka;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a list of Subscriptions from Stripe

has 'object' => (is => 'ro', isa => 'Str');
has 'count'  => (is => 'ro', isa => 'Int'); # no longer included by default, see note below
has 'url'    => (is => 'ro', isa => 'Str');
has 'data'   => (is => 'ro', isa => 'ArrayRef[Net::Stripe::Subscription]');

method form_fields {
    die("Cannot transform a SubscriptionList into form fields");
}

__PACKAGE__->meta->make_immutable;
1;

=pod

=head1 NAME

Net::Stripe::SubscriptionList - represent a list of Subscriptions from Stripe

=head1 VERSION

version 0.22

=head1 ATTRIBUTES

=head2 count

Reader: count

Type: Int

=head2 data

Reader: data

Type: ArrayRef[Net::Stripe::Subscription]

=head2 object

Reader: object

Type: Str

=head2 url

Reader: url

Type: Str

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

__END__
From the Stripe Change Log:
2014-03-28
Remove count property from list responses, replacing it with the optional property total_count. 
You can request that total_count be included in your responses by specifying include[]=total_count.
