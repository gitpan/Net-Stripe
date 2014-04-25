package Net::Stripe;
use Moose;
use MooseX::Method::Signatures;
use LWP::UserAgent;
use HTTP::Request::Common qw/GET POST DELETE/;
use MIME::Base64 qw/encode_base64/;
use URI::Escape qw/uri_escape/;
use JSON qw/decode_json/;
use Net::Stripe::Token;
use Net::Stripe::Invoiceitem;
use Net::Stripe::Invoice;
use Net::Stripe::Card;
use Net::Stripe::Plan;
use Net::Stripe::Coupon;
use Net::Stripe::Charge;
use Net::Stripe::Customer;
use Net::Stripe::Discount;
use Net::Stripe::Subscription;
use Net::Stripe::SubscriptionList;
use Net::Stripe::Error;
use Net::Stripe::BalanceTransaction;

our $VERSION = '0.09';

# ABSTRACT: API client for Stripe.com


has 'debug'         => (is => 'rw', isa => 'Bool',   default    => 0);
has 'debug_network' => (is => 'rw', isa => 'Bool',   default    => 0);
has 'api_key'       => (is => 'ro', isa => 'Str',    required   => 1);
has 'api_base'      => (is => 'ro', isa => 'Str',    lazy_build => 1);
has 'ua'            => (is => 'ro', isa => 'Object', lazy_build => 1);



Charges: {
    sub post_charge {
        my $self = shift;
        my $charge = Net::Stripe::Charge->new(@_);
        return $self->_post('charges', $charge);
    }

    method get_charge(Str $id) {
        return $self->_get("charges/$id");
    }

    method refund_charge($id, $amount?) {
        $id = $id->id if ref($id);
        
        if($amount) {
            $amount = "?amount=$amount";
        } else {
            $amount = '';
        }
        
        return $self->_post("charges/$id/refund" . $amount);
    }

    sub get_charges {
        my $self = shift;
        $self->_get_collections('charges', @_);
    }
    
    
}

BalanceTransactions: {
  method get_balance_transaction(Str $id) {
    return $self->_get("balance/history/$id");
  }
}



Customers: {
    sub post_customer {
        my $self = shift;
        # Update from an existing object
        if (@_ == 1) {
            my $c = shift;
            return $self->_post("customers/" . $c->id, $c);
        }

        my $customer = Net::Stripe::Customer->new(@_);
        return $self->_post('customers', $customer);
    }

    # adds a subscription, keeping any existing subscriptions unmodified
    sub post_customer_subscription {
        my $self = shift;
        my $customer_id = shift;
        defined($customer_id) || die 'post_customer_subscription() requires a customer_id';
        die 'post_customer_subscription() requires a param hash' unless @_;
        $self->_post("customers/$customer_id/subscriptions", @_);
    }

    sub list_subscriptions {
        my $self = shift;
        my %args = @_;
        my $cid = delete $args{customer_id};
        return $self->_get("customers/$cid/subscriptions", @_);
    }

    method get_customer(Str $id) {
        return $self->_get("customers/$id");
    }

    method delete_customer($id) {
        $id = $id->id if ref($id);
        $self->_delete("customers/$id");
    }

    sub get_customers {
        my $self = shift;
        $self->_get_collections('customers', @_);
    }
}



Cards: {
    method get_card {
        my %args = @_;
        my $cid = delete $args{customer_id};
        my $card_id = delete $args{card_id};
        return $self->_get("customers/$cid/cards/$card_id");
    }

    method get_cards {
        $self->_get_collections('cards', @_);
    }

    method post_card {
        my %args = @_;
        my $cid = delete $args{customer_id};
        my $card = Net::Stripe::Card->new(%args);
        return $self->_post("customers/$cid/cards", $card);
    }

    method update_card {
      my %args = @_;
      my $cid  = delete $args{customer_id};
      my $card_id = delete $args{card_id};
      return $self->_post("customers/$cid/cards/$card_id", \%args);
    }

    method delete_card {
      my %args = @_;
      my $cid  = delete $args{customer_id};
      my $card_id = delete $args{card_id};
      return $self->_delete("customers/$cid/cards/$card_id");
    }
}



Subscriptions: {
    sub get_subscription {
        my $self = shift;
        my %args = @_;
        my $cid = delete $args{customer_id};
        return $self->_get("customers/$cid/subscription");
    }

    # adds a subscription, keeping any existing subscriptions unmodified
    sub post_subscription {
        my $self = shift;
        my %args = @_;
        my $cid = delete $args{customer_id};
        my $subs = Net::Stripe::Subscription->new(%args);
        return $self->_post("customers/$cid/subscriptions", $subs);
    }
    
    sub update_subscription {
        my $self = shift;
        my %args = @_;
        my $cid  = delete $args{customer_id};
        my $sid  = delete $args{subscription_id};
        return $self->_post("customers/$cid/subscriptions/$sid", \%args);
    }

    sub delete_subscription {
        my $self = shift;
        my %args = @_;
        my $cid  = delete $args{customer_id};
        my $sid  = delete $args{subscription_id};
        my $query = '';
        $query .= '?at_period_end=true' if $args{at_period_end};
        return $self->_delete("customers/$cid/subscriptions/$sid$query");
    }
}



Tokens: {
    sub post_token {
        my $self = shift;
        my $token = Net::Stripe::Token->new(@_);
        return $self->_post('tokens', $token);
    }

    method get_token(Str $id) {
        return $self->_get("tokens/$id");
    }
}


Plans: {
    sub post_plan {
        my $self = shift;
        my $plan = Net::Stripe::Plan->new(@_);
        return $self->_post('plans', $plan);
    }

    method get_plan(Str $id) {
        return $self->_get("plans/" . uri_escape($id));
    }

    method delete_plan($id) {
        $id = $id->id if ref($id);
        $self->_delete("plans/$id");
    }

    sub get_plans {
        my $self = shift;
        $self->_get_collections('plans', @_);
    }
}



Coupons: {
    sub post_coupon {
        my $self = shift;
        my $coupon = Net::Stripe::Coupon->new(@_);
        return $self->_post('coupons', $coupon);
    }

    method get_coupon(Str $id) {
        return $self->_get("coupons/" . uri_escape($id));
    }

    method delete_coupon($id) {
        $id = $id->id if ref($id);
        $self->_delete("coupons/$id");
    }

    sub get_coupons {
        my $self = shift;
        $self->_get_collections('coupons', @_);
    }
}



Invoices: {
    method post_invoice($i) {
        return $self->_post("invoices/" . $i->id, $i);
    }

    method get_invoice(Str $id) {
        return $self->_get("invoices/$id");
    }

    sub get_invoices {
        my $self = shift;
        $self->_get_collections('invoices', @_);
    }

    method get_upcominginvoice(Str $id) {
        return $self->_get("invoices/upcoming?customer=$id");
    }
}


InvoiceItems: {
    sub post_invoiceitem {
        my $self = shift;
        # Update from an existing object
        if (@_ == 1) {
            my $i = shift;
            my $item = $i->clone; $item->clear_currency;
            return $self->_post("invoiceitems/" . $i->id, $item);
        }

        my $invoiceitem = Net::Stripe::Invoiceitem->new(@_);
        return $self->_post('invoiceitems', $invoiceitem);
    }

    method get_invoiceitem(Str $id) {
        return $self->_get("invoiceitems/$id");
    }

    method delete_invoiceitem($id) {
        $id = $id->id if ref($id);
        $self->_delete("invoiceitems/$id");
    }

    sub get_invoiceitems {
        my $self = shift;
        $self->_get_collections('invoiceitems', @_);
    }
}

# Helper methods

method _get(Str $path) {
    my $req = GET $self->api_base . '/' . $path;
    return $self->_make_request($req);
}

method _get_with_args(Str $path, $args?) {
    if (@$args) {
        $path .= "?" . join('&', @$args);
    }
    return $self->_get($path);
}

sub _get_collections { 
    my $self = shift;
    my $path = shift;
    my %args = @_;
    my @path_args;
    if (my $c = $args{count}) {
        push @path_args, "count=$c";
    }
    if (my $o = $args{offset}) {
        push @path_args, "offset=$o";
    }
    if (my $c = $args{customer}) {
        push @path_args, "customer=$c";
    }
    
    # example: $Stripe->get_charges( 'count' => 100, 'created' => { 'gte' => 1397663381 } );
    if (defined($args{created})) {
      my %c = %{$args{created}};   
      foreach my $key (keys %c) {
        if ($key =~ /(?:l|g)te?/) {
          push @path_args, "created[".$key."]=".$c{$key};
        }
      }        
    }
    return $self->_get_with_args($path, \@path_args);
}

method _delete(Str $path) {
    my $req = DELETE $self->api_base . '/' . $path;
    return $self->_make_request($req);
}

method _post(Str $path, $obj?) {
    my $req = POST $self->api_base . '/' . $path, 
        ($obj ? (Content => [ref($obj) eq 'HASH' ? %$obj : $obj->form_fields]) : ());
    return $self->_make_request($req);
}

method _make_request($req) {
    $req->header( Authorization => 
        "Basic " . encode_base64($self->api_key . ':'));

    if ($self->debug_network) {
        print STDERR "Sending to Stripe:\n------\n" . $req->as_string() . "------\n";

    }
    my $resp = $self->ua->request($req);

    if ($self->debug_network) {
        print STDERR "Received from Stripe:\n------\n" . $resp->as_string()  . "------\n";
    }

    if ($resp->code == 200) {
        my $hash = decode_json($resp->content);
        if( $hash->{object} && 'list' eq $hash->{object} ) {
          my @objects = ();
          foreach my $object_data (@{$hash->{data}}) {
            push @objects, hash_to_object($object_data);            
          }
          return \@objects;
        }     
        return hash_to_object($hash) if $hash->{object};
        if (my $data = $hash->{data}) {
            return [ map { hash_to_object($_) } @$data ];
        }
        return $hash;
    } elsif ($resp->code == 500) {
        die Net::Stripe::Error->new(
            type => "HTTP request error",
            code => $resp->code,
            message => $resp->status_line . " - " . $resp->content,
        );
    }

    my $e = eval {
        my $hash = decode_json($resp->content);
        Net::Stripe::Error->new($hash->{error})
    };
    if ($@) {
        Net::Stripe::Error->new(
            type => "Could not decode HTTP response: $@",
            message => $resp->status_line . " - " . $resp->content,
        );
    };

    warn "$e\n" if $self->debug;
    die $e;
}


sub hash_to_object {
    my $hash   = shift;
    my @words  = map { ucfirst($_) } split('_', $hash->{object});
    my $object = join('', @words);
    my $class  = 'Net::Stripe::' . $object;
    return $class->new($hash);
}

method _build_api_base { 'https://api.stripe.com/v1' }

method _build_ua {
    my $ua = LWP::UserAgent->new();
    $ua->agent("Net::Stripe/$VERSION");
    return $ua;
}


__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Stripe - API client for Stripe.com

=head1 VERSION

version 0.12

=head1 SYNOPSIS

 my $stripe     = Net::Stripe->new(api_key => $API_KEY);
 my $card_token = 'a token';
 my $charge = $stripe->post_charge(  # Net::Stripe::Charge
     amount      => 12500,
     currency    => 'usd',
     card        => $card_token,
     description => 'YAPC Registration',
 );
 print "Charge was not paid!\n" unless $charge->paid;
 my $card = $charge->card;           # Net::Stripe::Card

 # look up a charge by id
 my $same_charge = $stripe->get_charge($charge->id);

 # ... and the api mirrors https://stripe.com/docs/api
 # Charges: post_charge() get_charge() refund_charge() get_charges()
 # Customer: post_customer() 

=head1 DESCRIPTION

This module is a wrapper around the Stripe.com HTTP API.  Methods are 
generally named after the HTTP method and the object name.

This method returns Moose objects for responses from the API.

=head1 METHODS

=head2 new PARAMHASH

This creates a new stripe api object.  The following parameters are accepted:

=over

=item api_key

This is required. You get this from your Stripe Account settings.

=item debug

You can set this to true to see extra debug info.

=item debug_network

You can set this to true to see the actual network requests.

=back

=head1 Charge Methods

=head2 post_charge( PARAMHASH | OBJECT )

=head2 get_charge( CHARGE_ID )

=head2 refund_charge( CHARGE_ID )

=head2 get_charges( PARAMHASH )

=head1 Customer Methods

=head2 post_customer( PARAMHASH | OBJECT )

=head2 get_customer( CUSTOMER_ID )

=head2 delete_customer( CUSTOMER_ID )

=head2 post_customer_subscription( CUSTOMER_ID, PARAMHASH )

=head2 get_customers( PARAMHASH )

=head1 Card Methods

=head2 post_card( PARAMHASH )

=head2 get_card( customer_id => CUSTOMER_ID, card_id => CARD_ID )

=head2 get_cards( customer_id => CUSTOMER_ID)

=head2 update_card( customer_id => CUSTOMER_ID, card_id => CARD_ID)

=head2 delete_card( customer_id => CUSTOMER_ID, card_id => CARD_ID )

=head1 Subscription Methods

=head2 post_subscription( PARAMHASH )

=head2 get_subscription( customer_id => CUSTOMER_ID )

=head2 delete_subscription( customer_id => CUSTOMER_ID )

=head1 Token Methods

=head2 post_token( PARAMHASH )

=head2 get_token( TOKEN_ID )

=head1 Plan Methods

=head2 post_plan( PARAMHASH )

=head2 get_plan( PLAN_ID )

=head2 delete_plan( PLAN_ID )

=head2 get_plans( PARAMHASH )

=head1 Coupon Methods

=head2 post_coupon( PARAMHASH )

=head2 get_coupon( COUPON_ID )

=head2 delete_coupon( COUPON_ID )

=head2 get_coupons( PARAMHASH )

=head1 Invoice Methods

=head2 post_invoice( OBJECT )

=head2 get_invoice( INVOICE_ID )

=head2 get_upcominginvoice( COUPON_ID )

=head2 get_invoices( PARAMHASH )

=head1 Invoice Item Methods

=head2 post_invoiceitem( PARAMHASH | OBJECT )

=head2 get_invoiceitem( INVOICEITEM_ID )

=head2 delete_invoiceitem( INVOICEITEM_ID )

=head2 get_invoiceitems( PARAMHASH )

=head1 SEE ALSO

L<https://stripe.com>, L<https://stripe.com/docs/api>

=head1 CONTRIBUTORS

=head1 AUTHOR

Luke Closs

=head1 CONTRIBUTORS

=over 4

=item *

Andrew Solomon <andrew@illywhacker.net>

=item *

Brian Collins <bricollins@gmail.com>

=item *

Devin M. Certas <devin@nacredata.com>

=item *

Dimitar Petrov <mitakaa@gmail.com>

=item *

Dylan Reinhold <dylan@gasdasoftware.com>

=item *

Jonathan "Duke" Leto <jonathan@leto.net>

=item *

Luke Closs <me@luk.ec>

=item *

Olaf Alders <olaf@wundersolutions.com>

=item *

Rusty Conover <rusty@luckydinosaur.com>

=item *

Sachin Sebastian <sachinjsk@users.noreply.github.com>

=item *

Tom Eliaz <tom@tomeliaz.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Copyright 2011, Prime Radiant, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
