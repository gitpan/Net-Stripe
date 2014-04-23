package Net::Stripe::Token;
use Moose;
use methods;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a Token object from Stripe

# Args for creating a Token
has 'card'        => (is => 'ro', isa => 'Maybe[Net::Stripe::Card]', required => 1);
has 'amount'      => (is => 'ro', isa => 'Maybe[Int]');
has 'currency'    => (is => 'ro', isa => 'Maybe[Str]');

# Args returned by the API
has 'id'          => (is => 'ro', isa => 'Maybe[Str]');
has 'created'     => (is => 'ro', isa => 'Maybe[Int]');
has 'used'        => (is => 'ro', isa => 'Maybe[Bool|Object]');
has 'livemode'    => (is => 'ro', isa => 'Maybe[Bool|Object]');

method form_fields {
    return (
        (defined $self->card ? $self->card->form_fields : () ),
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                qw/amount currency/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Token - represent a Token object from Stripe

=head1 VERSION

version 0.10

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
