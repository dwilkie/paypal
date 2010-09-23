# paypal
A simple ruby wrapper for paypal.

## Features
Currently paypal supports the following:

* Verifying Paypal IPN's
* MassPay Requests

## Configuration
    Paypal.setup do |config|
      config.environment = "sandbox" # replace with "live" in production
      config.api_username = "Replace me with your api username"
      config.api_password = "Replace me with your api password"
      config.api_signature = "Replace me with your api signature"
    end

## Usage
### IPN Modules
#### Paypal::Ipn
    class PaypalIpn
      include Paypal::Ipn
      attr_accessor :params
    end
Note: Your class must respond to `params` and return a hash of paypal ipn parameters

##### Public methods
* `payment_completed?`
* `payment_status`
* `txn_id`

##### Private methods
* `verify` Verifies the IPN with paypal and returns true or false
* `receiver_email`
* `self.txn_type(params)`
* `self.masspay_transaction?(params)`

#### Paypal::Ipn::Buyer
    class BuyerPaypalIpn
      include Paypal::Ipn::Buyer
      attr_accessor :params
    end

##### Public methods
* `customer_address` Convienence method. e.g.
John Smith,
5 Some Street,
Some City,
Some State,
Australia 1234
* `customer_address_name`
* `customer_address_street`
* `customer_address_city`
* `customer_address_state`
* `customer_address_zip`
* `customer_address_country`

#### Paypal::Ipn::Item
    class ItemPaypalIpn
      include Paypal::Ipn::Item
      attr_accessor :params
    end

##### Public methods
* `item_name(index = nil)` If index is supplied it will return item_name#index otherwise simply item_name
* `item_number(index = nil)`
* `item_quantity(index = nil)`
* `number_of_cart_items`

#### Paypal::Ipn::Masspay
    class MasspayPaypalIpn
      include Paypal::Ipn::Masspay
      attr_accessor :params
    end
Note: Currently Masspay IPN's only support a single transaction

##### Public methods
* `payment_status` Returns the payment status for the 1st transaction
* `txn_id` Returns the transaction id for the 1st transaction

##### Private methods
* `unique_id` Returns the unique_id for the 1st transaction

### Masspay
    class Masspay
      include Paypal::Masspay
      attr_accessor :payment_response
    end
Note: Your class must respond to `payment_response` and return the payment response as a hash

##### Public methods
* `successful_payment?` Returns whether the masspay request was successful or not. Note: This only tells you if the request was successful or not. You should wait for an IPN to verify the receiver has been paid.

##### Private methods
* `masspay(payer_email, receiver_email, amount, currency, note, unique_id)` Sends a mass pay request from *payer_email* to *receiver_email* for *amount* in *currency*. The *note* will appear on the receivers paypal account and the *unique_id* will be passed back in the Paypal IPN. Returns the response from paypal.

* `payment_error_type` Returns *:unauthorized* or *:insufficient_funds* for these types of errors otherwise returns nil

Note: Currently Masspay payments only support a single recipient

## Rails
    `rails g paypal:initializer`
Generates a stub initializer under config/initializers

## Installation

    gem install paypal

Copyright (c) 2010 David Wilkie, released under the MIT license

