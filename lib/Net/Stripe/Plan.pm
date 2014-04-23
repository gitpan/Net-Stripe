package Net::Stripe::Plan;
use Moose;
use Moose::Util::TypeConstraints;
use methods;
extends 'Net::Stripe::Resource';

# ABSTRACT: represent a Plan object from Stripe

union 'StripePlan', ['Str', 'Net::Stripe::Plan'];

subtype 'StatementDescription',
    as 'Str',
    where { !defined($_) || $_ =~ /^[^<>"']{0,15}$/ },
    message { "The statement description you provided '$_' must be 15 characters or less and not contain <>\"'." };

has 'id'                => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'amount'            => (is => 'ro', isa => 'Maybe[Int]', required => 1);
has 'currency'          => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'interval'          => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'interval_count'    => (is => 'ro', isa => 'Maybe[Int]', required => 0);
has 'name'              => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'trial_period_days' => (is => 'ro', isa => 'Maybe[Int]');
has 'statement_description' => ('is' => 'ro', isa => 'Maybe[StatementDescription]', required => 0);

method form_fields {
    return (
        map { $_ => $self->$_ }
            grep { defined $self->$_ }
                qw/id amount currency interval interval_count name statement_description trial_period_days/
    );
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe::Plan - represent a Plan object from Stripe

=head1 VERSION

version 0.10

=head1 AUTHOR

Luke Closs

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
