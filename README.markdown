# paypal

A simple ruby wrapper for paypal.

## Features
Currently paypal supports the following:
* Verifying Paypal IPN's
* MassPay Requests

## Configuration
    Paypal.setup do |config|
      config.environment = "sandbox" # Change this to "live" in production
      config.api_username = XXXX
      config.api_password = XXXX
      config.api_signature = XXXX
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
##### Private methods
* `verify` Verifies the IPN with paypal and returns true or false
* `receiver_email`
* `payment_status`
* `self.txn_type(params)`
* `self.masspay_transaction?(params)`
* `self.txn_id(params)`
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
##### Private methods
* `unique_id` Returns the unique_id for the 1st transaction
* `self.masspay_txn_id(params)` Returns the transaction id for the 1st transaction
### Masspay
    class Masspay
      include Paypal::Masspay
    end
### Private methods
* `masspay(payer_email, receiver_email, amount, currency, note, unique_id)` Sends a mass pay request from *payer_email* to *receiver_email* for *amount* in *currency*. The *note* will appear on the receivers paypal account and the *unique_id* will be passed back in the Paypal IPN. Returns the response from paypal.

Note: Currently Masspay payments only support a single recipient

## Rails
    `rails g paypal:initializer`
Generates a stub initializer under config/initializers

## Installation

    gem install paypal

Copyright (c) 2010 David Wilkie, released under the MIT license

