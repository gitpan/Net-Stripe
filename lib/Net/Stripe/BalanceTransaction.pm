package Net::Stripe::BalanceTransaction;
use Moose;
use Moose::Util::TypeConstraints qw(subtype as where message);
use MooseX::Method::Signatures;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a BalanceTransaction object from Stripe

subtype 'TransactionType',
      as 'Str',
      where { $_ =~ /^(?:charge|refund|adjustment|application_fee(?:_refund)?|transfer_?(?:cancelfailure)?)$/ },
      message { "A transaction type must be one of charge, refund, adjustment, application_fee, application_fee_refund, transfer, transfer_cancel or transfer_failure" };
      
subtype 'StatusType',
  as 'Str',
  where { $_ =~ /^(?:available|pending)$/ },
  message { "A Status must be one of available or pending" };

has 'id'            => (is => 'ro', isa => 'Str');
has 'amount'        => (is => 'ro', isa => 'Int');
has 'currency'      => (is => 'ro', isa => 'Str', required => 1);
has 'net'           => (is => 'ro', isa => 'Int');
has 'type'          => (is => 'ro', isa => 'TransactionType');
has 'created'       => (is => 'ro', isa => 'Int');
has 'available_on'  => (is => 'ro', isa => 'Int');
has 'status'        => (is => 'ro', isa => 'StatusType'); 
has 'fee'           => (is => 'ro', isa => 'Int');
has 'fee_details'   => (is => 'ro', isa => 'Maybe[ArrayRef]');
has 'source'        => (is => 'ro', isa => 'Str');
has 'description'   => (is => 'ro', isa => 'Maybe[Str]');

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::BalanceTransaction - represent a BalanceTransaction object from Stripe

=head1 VERSION

version 0.14

=head1 ATTRIBUTES

=head2 amount

Reader: amount

Type: Int

=head2 available_on

Reader: available_on

Type: Int

=head2 created

Reader: created

Type: Int

=head2 currency

Reader: currency

Type: Str

This attribute is required.

=head2 description

Reader: description

Type: Maybe[Str]

=head2 fee

Reader: fee

Type: Int

=head2 fee_details

Reader: fee_details

Type: Maybe[ArrayRef]

=head2 id

Reader: id

Type: Str

=head2 net

Reader: net

Type: Int

=head2 source

Reader: source

Type: Str

=head2 status

Reader: status

Type: StatusType

=head2 type

Reader: type

Type: TransactionType

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
