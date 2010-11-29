module Paypal
  module Ipn
    module Payment
      def gross_payment_amount
        self.params["mc_gross"]
      end

      def payment_currency
        self.params["mc_currency"]
      end
    end
  end
end

