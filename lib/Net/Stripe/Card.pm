package Net::Stripe::Card;
use Moose;
use Moose::Util::TypeConstraints;
use methods;

# ABSTRACT: represent a Card object from Stripe

union 'StripeCard', ['Str', 'Net::Stripe::Card', 'Net::Stripe::Token'];

# Input fields
has 'number'          => (is => 'ro', isa => 'Maybe[Str]');
has 'cvc'             => (is => 'ro', isa => 'Maybe[Int]');
has 'name'            => (is => 'ro', isa => 'Maybe[Str]');
has 'address_line1'   => (is => 'ro', isa => 'Maybe[Str]');
has 'address_line2'   => (is => 'ro', isa => 'Maybe[Str]');
has 'address_zip'     => (is => 'ro', isa => 'Maybe[Str]');
has 'address_state'   => (is => 'ro', isa => 'Maybe[Str]');
has 'address_country' => (is => 'ro', isa => 'Maybe[Str]');

# Both input and output
has 'exp_month'       => (is => 'ro', isa => 'Maybe[Int]', required => 1);
has 'exp_year'        => (is => 'ro', isa => 'Maybe[Int]', required => 1);

# Output fields
has 'address_line_1_check' => (is => 'ro', isa => 'Maybe[Str]');
has 'address_zip_check'    => (is => 'ro', isa => 'Maybe[Str]');
has 'country'              => (is => 'ro', isa => 'Maybe[Str]');
has 'cvc_check'            => (is => 'ro', isa => 'Maybe[Str]');
has 'fingerprint'          => (is => 'ro', isa => 'Maybe[Str]');
has 'last4'                => (is => 'ro', isa => 'Maybe[Str]');
has 'type'                 => (is => 'ro', isa => 'Maybe[Str]');

method form_fields {
    return (
        map { ("card[$_]" => $self->$_) }
            grep { defined $self->$_ }
                qw/number cvc name address_line1 address_line2 address_zip
                   address_state address_country exp_month exp_year/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Card - represent a Card object from Stripe

=head1 VERSION

version 0.11

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
