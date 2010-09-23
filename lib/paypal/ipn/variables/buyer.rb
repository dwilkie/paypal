module Paypal
  module Ipn
    module Buyer
      def customer_address(delimeter = ",\n")
        [
          customer_address_name,
          customer_address_street,
          customer_address_city,
          customer_address_state,
          customer_address_country + " " + customer_address_zip,
        ].join(delimeter)
      end

      def customer_address_name
        self.params["address_name"].to_s
      end

      def customer_address_street
        self.params["address_street"].to_s
      end

      def customer_address_city
        self.params["address_city"].to_s
      end

      def customer_address_state
        self.params["address_state"].to_s
      end

      def customer_address_zip
        self.params["address_zip"].to_s
      end

      def customer_address_country
        self.params["address_country"].to_s
      end
    end
  end
end

