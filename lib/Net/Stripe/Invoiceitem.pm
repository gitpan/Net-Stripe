package Net::Stripe::Invoiceitem;
use Moose;
use methods;
extends 'Net::Stripe::Resource';
with 'MooseX::Clone';

# ABSTRACT: represent an Invoice Item object from Stripe

has 'id'                => (is => 'ro', isa => 'Maybe[Str]');
has 'customer'          => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'amount'            => (is => 'rw', isa => 'Maybe[Int]', required => 1);
has 'currency'          => (is => 'rw', isa => 'Maybe[Str]', required => 1, clearer => 'clear_currency');
has 'description'       => (is => 'rw', isa => 'Maybe[Str]');
has 'date'              => (is => 'ro', isa => 'Maybe[Int]');
has 'invoice'           => (is => 'ro', isa => 'Maybe[Str]');


method form_fields {
    return (
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                qw/amount currency description invoice/,
                ($self->id ? () : qw/customer/)
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Invoiceitem - represent an Invoice Item object from Stripe

=head1 VERSION

version 0.10

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
